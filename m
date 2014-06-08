Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503AbaFHJdf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 05:33:35 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:59478 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278AbaFHJdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 05:33:33 -0400
X-Greylist: delayed 1853 seconds by postgrey-1.27 at vger.kernel.org; Sun, 08 Jun 2014 05:33:33 EDT
Date: Sun, 8 Jun 2014 10:02:23 +0100
From: Sitsofe Wheeler <sitsofe@gmail.com>
To: Igor Mammedov <imammedo@redhat.com>
Cc: Toshi Kani <toshi.kani@hp.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Subject: [BISECTED][REGRESSION] Kernel does not boot on EeePC
Message-ID: <20140608090223.GA8703@sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The latest kernel (c593e8978722f7f4a12932733cfeed6c0c74fbaa) refuses to
boot on my EeePC - after grub is finished the screen just remains black
and the only thing that does something is pressing the power button. The
problem commit seems to be:

commit 3e1a878b7ccdb31da6d9d2b855c72ad87afeba3f
Author: Igor Mammedov <imammedo@redhat.com>
Date:   Thu Jun 5 15:42:45 2014 +0200

    x86/smpboot: Initialize secondary CPU only if master CPU will wait for it

Here's the bisection log:
# bad: [c593e8978722f7f4a12932733cfeed6c0c74fbaa] Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs
# good: [14186fea0cb06bc43181ce239efe0df6f1af260a] Merge tag 'locks-v3.15-4' of git://git.samba.org/jlayton/linux
git bisect start 'HEAD@{3}' 'HEAD@{4}'
# good: [5fa6a683c061cd4662b436135cc76552dbc29a43] Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net
git bisect good 5fa6a683c061cd4662b436135cc76552dbc29a43
# good: [9f12600fe425bc28f0ccba034a77783c09c15af4] dcache: add missing lockdep annotation
git bisect good 9f12600fe425bc28f0ccba034a77783c09c15af4
# good: [ca755175f245b91f72cfa474aaa8acd9c26996f4] Merge tag 'md/3.15-fixes' of git://neil.brown.name/md
git bisect good ca755175f245b91f72cfa474aaa8acd9c26996f4
# bad: [3e1a878b7ccdb31da6d9d2b855c72ad87afeba3f] x86/smpboot: Initialize secondary CPU only if master CPU will wait for it
git bisect bad 3e1a878b7ccdb31da6d9d2b855c72ad87afeba3f
# good: [c65c7a306610ee7c13669a8f5601b472c19dc6f1] bridge: notify user space after fdb update
git bisect good c65c7a306610ee7c13669a8f5601b472c19dc6f1
# good: [3aab01d800eb195de3f273d9a195fe070a507d56] net: ec_bhf: Add runtime dependencies
git bisect good 3aab01d800eb195de3f273d9a195fe070a507d56
# good: [d2cfd3105094f593bc1fbd0b042a7752ddf08691] Merge tag 'sound-3.15' of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound
git bisect good d2cfd3105094f593bc1fbd0b042a7752ddf08691
# good: [89f898c1e195fa6235c869bb457e500b7b3ac49d] x86: Fix list/memory corruption on CPU hotplug
git bisect good 89f898c1e195fa6235c869bb457e500b7b3ac49d
# good: [feef1e8ecbadf24f8e6829c935df8683cabae41b] x86/smpboot: Log error on secondary CPU wakeup failure at ERR level
git bisect good feef1e8ecbadf24f8e6829c935df8683cabae41b
# first bad commit: [3e1a878b7ccdb31da6d9d2b855c72ad87afeba3f] x86/smpboot: Initialize secondary CPU only if master CPU will wait for it

-- 
Sitsofe | http://sucs.org/~sits/

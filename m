Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724AbaKDWeX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 17:34:23 -0500
Received: from ozlabs.org ([103.22.144.67]:52866 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752056AbaKDWeW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 17:34:22 -0500
Date: Wed, 5 Nov 2014 09:34:20 +1100
From: Anton Blanchard <anton@samba.org>
To: uobergfe@redhat.com, drjones@redhat.com, dzickus@redhat.com,
        akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: Confusing behaviour with /proc/sys/kernel/nmi_watchdog
Message-ID: <20141105093420.1c7500d8@kryten>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

commit 9919e39a1738 ("kvm: ensure hard lockup detection is disabled by
default") provided a way for the kernel to disable the hard lockup
detector at runtime.

I'm using it on ppc64 but notice some weird behaviour with the
nmi_watchdog procfs variable. At boot, that the hard lockup
detector appears to be enabled even when we disable it via
watchdog_enable_hardlockup_detector(false):

# cat /proc/sys/kernel/nmi_watchdog 
1

I have to echo 0 to it then echo 1 again to enable it.

Anton

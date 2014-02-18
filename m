Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316AbaBRUA2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 15:00:28 -0500
Received: from fourcot.fr ([217.70.191.14]:60086 "EHLO olfflo.fourcot.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750950AbaBRUA1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 15:00:27 -0500
X-Greylist: delayed 362 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Feb 2014 15:00:27 EST
Message-ID: <5303BA6F.9090704@enst-bretagne.fr>
Date: Tue, 18 Feb 2014 20:54:23 +0100
From: Florent Fourcot <florent.fourcot@enst-bretagne.fr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Crash by update of shared libraries
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

my system crash by libraries update. Some steps to reproduce the
bug (without crash of the all system):


 $ export LD_PRELOAD=./libfake.so.1
 $ cp libfake.so.1 /tmp/
 $ cp /tmp/libfake.so.1 .
 => Bus error

The cp crash, since the file of the loaded library changed (and the copy
failed of course, the new file is now empty).
All software with a library loaded (with ld) will crash as well (for
example by system updating of the libc: the pid 1 will crash).

Tested on a Linux kernel 3.14.0-rc3.

Regards,

-- 
Florent.

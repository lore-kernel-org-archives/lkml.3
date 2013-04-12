Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066Ab3DLSaQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 14:30:16 -0400
Received: from tex.lwn.net ([70.33.254.29]:48675 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752851Ab3DLSaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 14:30:13 -0400
X-Greylist: delayed 1300 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Apr 2013 14:30:13 EDT
Date: Fri, 12 Apr 2013 12:08:31 -0600
From: Jake Edge <jake@lwn.net>
To: hpa@linux.intel.com, rjw@sisk.pl, linux-kernel@vger.kernel.org
Subject: sleep/fan problem bisected to
 73201dbec64aebf6b0dca855b523f437972dc7bb
Message-ID: <20130412120831.1402b440@chukar.edge2.net>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.16; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Peter,

I have been having a problem on my laptop (HP Compaq 2510p) over the
last two months with >= 3.7 kernels.  After the first resume, it turns
on the fan and leaves it running at top speed no matter what the system
is doing.  I finally bisected it over the last two days and that points
the finger at your patch 73201dbec64aebf6b0dca855b523f437972dc7bb:

 x86, suspend: On wakeup always initialize cr4 and EFER
    
    We already have a flag word to indicate the existence of
 MISC_ENABLES, so use the same flag word to indicate existence of cr4
 and EFER, and always restore them if they exist.  That way if
 something passes a nonzero value when the value *should* be zero, we
 will still initialize it.

I should note that the bisection (between 3.6, which works, and 3.7,
which doesn't) did not exhibit the same symptoms as I see with any 3.7
or 3.8 kernel (either from Fedora or built myself), but would instead
refuse to come out of sleep (but still have the fan running at top
speed) ... so maybe I've really bisected the "fails to come out of
sleep" problem, rather than the "fan runs at top speed after resume"
problem, dunno ... but it would seem that code is still present in 3.7+
and I have no trouble resuming using those kernels (other than the damn
noisy fan :)

The output of "sensors" is interesting ... for "temp6" in
"acpitz-virtual-0" it sits at +100C (near the +110C critical level)
when things have gone bad (just in Fedora or my kernels >=3.7, not in
the bisect, cuz those don't come back from the sleep) ... in the "good"
case, it normally sits around 30, but goes as high as 50 (and sometimes
reports 0 for a try or two -- frozen motherboard! :) ...

thoughts on this?  Other info you need or things I should be trying?

thanks,

jake

-- 
Jake Edge - LWN - jake@lwn.net - http://lwn.net

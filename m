Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758443AbaJ1Ggv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 02:36:51 -0400
Received: from barracuda.supercp.com ([216.234.124.52]:38202 "EHLO
	barracuda.supercp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758410AbaJ1Ggt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 02:36:49 -0400
X-Greylist: delayed 974 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Oct 2014 02:36:48 EDT
X-ASG-Debug-ID: 1414477232-089ef75ee265f210001-xx1T2L
X-Barracuda-Envelope-From: list1@michaelshell.org
X-Barracuda-Apparent-Source-IP: 216.119.133.66
Date: Tue, 28 Oct 2014 02:32:08 -0400
From: Michael Shell <list1@michaelshell.org>
To: linux-kernel@vger.kernel.org
Subject: Standard VGA console with DRI/DRM under X?
Message-Id: <20141028023208.320b777b6ad97c7c9a815300@michaelshell.org>
X-ASG-Orig-Subj: Standard VGA console with DRI/DRM under X?
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.10; i586-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - a2s43.a2hosting.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - michaelshell.org
X-Get-Message-Sender-Via: a2s43.a2hosting.com: authenticated_id: list1@michaelshell.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Barracuda-Connect: a2s43.a2hosting.com[216.119.133.66]
X-Barracuda-Start-Time: 1414477232
X-Barracuda-URL: http://barracuda.supercp.com:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=4.0 KILL_LEVEL=5.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.10982
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



  Greetings,

Well, I want to be able to have my cake and eat it too. I want to be able to
have the standard VGA/"hardware" classic console (not the framebuffer) but
I still want the /dev/dri/cardX devices so that I can use DRI under Xorg.

Is this possible and if not, why not?


(I do hope I'm not bring up an issue with an obvious fix, but my searching
 has not yielded an answer yet. For the record, I'm running modern kernel
 (3.16.3) with much older x86 hardware [r100 Radeon video card].)


If I boot with the kernel nomodeset option I can get the classic
VGA/"hardware" console, but then I lose support for DRI/DRM:

Oct 27 15:11:09 X kernel: [drm] Initialized drm 1.1.0 20060810
Oct 27 15:11:09 X kernel: [drm] VGACON disable radeon kernel modesetting.
Oct 27 15:11:09 X kernel: [drm:radeon_init] *ERROR* No UMS support in radeon module

and glxgears et al. turns slow. In more modern Xorg releases, DRI is
required for all hardware acceleration, so having /dev/dri/cardX is very
important:

http://askubuntu.com/questions/463142/why-x-is-relying-on-software-instead-of-hardware-with-nomodeset-kernel-paramet


One reason I do not wish to use the framebuffer console is because of the
small font. 160 columns makes it difficult to tell which [OK] belongs with
which service. The selection of console fonts should always include a
set that gives us an 80 column screen and the docs should point this out.

And I dislike any blanking or video mode changes during boot.

Can't the kernel just declare that it is capable of setting the video mode,
provide the /dev/dri/cardX devices and leave the console alone, but still
allow Xorg to call for a new mode and use /dev/dri/cardX if/when it sees fit?

In an ideal world, there would be some kernel option such as fbcon=no.

In the kernel Documentation fbcon.txt it mentions "fbcon=map:1 tells fbcon not
to take over the console." But, IIRC, from my tests I wasn't able to use this
to get a VGA/"hardware" console and still be able to have /dev/dri/cardX devices.



    Cheers and thank you,

    Mike Shell

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758689Ab3ENWT1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 18:19:27 -0400
Received: from spanner.eng.cam.ac.uk ([129.169.8.89]:64871 "EHLO
	spanner.eng.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758059Ab3ENWT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 18:19:26 -0400
X-Greylist: delayed 1696 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 May 2013 18:19:25 EDT
Date: Tue, 14 May 2013 22:51:07 +0100
From: Patrick Gosling <jpmg@eng.cam.ac.uk>
To: linux-kernel@vger.kernel.org
Subject: bug in DH77EB spurious reboot quirk handling
 (drivers/usb/host/xhci.c)
Message-ID: <5192b1cb.LascK3gsSDL181fc%jpmg@eng.cam.ac.uk>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There is a known bios problem with Intel DH77EB motherboards, described
here: <http://lkml.indiana.edu/hypermail/linux/kernel/1209.2/00222.html>

I have such a board, and am running the 3.8.0-ish kernel distributed
in the ubuntu 13.04 linux-image-3.8.0-19-generic package.  I apologise
for not having (yet) tried a more vanilla kernel source;  I will do
so imminently.

However, the ubuntu kernel includes the patch described in the url above,
and I can see no obvious reason why it should fail to have effect.

Observably, the patch didn't work on my machine - attempts to power the
machine off, while wake-on-lan was supported, would result in a spurious
reboot.

In attempting to identify the problem, I added (among some debugging
prints), an msleep(1000) immediately after the usb_disable_xhci_ports()
call in drivers/usb/host/xhci.c .

This fixed the problem;  I am now running a kernel whose only change is
the insertion of that "msleep(1000);".  The machine now powers off 
correctly.

This leads me to suspect that (possibly because the machine is quite fast
at shutting down), there is a timing issue with this quirk fix.

I don't think that just adding a 1s sleep is very satisfactory, however.

I could try tweaking the duration of the sleep downwards until it
stopped working, but this would seem likely to result in finding that
"it _usually_ works", which isn't at all satisfactory. 

I wonder if anyone has any ideas as to what one might want to wait
for, to ensure that the disabling of the xhci ports has actually taken
effect, before continuing the shutdown ...

With best wishes,

-patrick.

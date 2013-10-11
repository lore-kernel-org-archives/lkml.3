Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717Ab3JKQp5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 12:45:57 -0400
Received: from 87-119-183-129.tll.elisa.ee ([87.119.183.129]:51243 "EHLO
	fatphil.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752510Ab3JKQpz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 12:45:55 -0400
X-Greylist: delayed 427 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Oct 2013 12:45:55 EDT
Date: Fri, 11 Oct 2013 19:38:44 +0300
From: Phil Carmody <pc+n900@asdf.org>
To: dmitry.torokhov@gmail.com
Cc: freemangordon@abv.bg, linux-input@vger.kernel.org, wfp5p@virginia.edu,
        broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        pc+n900@asdf.org
Subject: Disabling the tsc2005 driver at runtime
Message-ID: <20131011163844.GH30709@fatphil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings, Dmitry,

I'm looking for some advice regarding locally restoring a feature into
the tsc2005 driver that was removed back in:
  http://www.spinics.net/lists/linux-input/msg14575.html
  commit 5cb81d1: Input: tsc2005 - remove 'disable' sysfs attribute

Given the prior patch in the patchset:
  commit 0b950d3: Input: tsc2005 - add open/close
  "Introduce open and close methods for the input device 
   to keep the device powered down when it is not in use."
it seems you were expecting the device node to only have one reader, and
that reader would be the entity who decided when it was time to disable
and power down the device.

However, in the Nokia N900, the device node has at least 3 readers, 2 of
which I believe are closed source components, and therefore cannot be
modified to follow kernel changes. And even then, forcing 3 userspace
programs to now have to actively participate in the disabling of the
device seems excessively wasteful, compared with the ultimate simplicity
of the clients not even having to know about such things, which is how
it was before the change.

Back then you mentioned a generic interface that should replace this
device-specific one, but I can see no documentation for such an
interface in the kernel Documentation/ABI. Can you elaborate?

At the moment, as we can't break userspace, it seems that if we want to
run a more modern kernel on the N900 or another tsc2005-based device
running Fremantle, we should just locally revert that patch, and take 
the maintenance hit ourselves for the implications of that. (Here 'we'
= the volunteer community still supporting the device because of its
longevity.)

Cheers,
Phil
-- 
People generally seem to want software to be free as in speech and/or
free as in beer. Unfortunately rather too much of it is free as in jazz.
-- Janet McKnight, on a private newsgroup

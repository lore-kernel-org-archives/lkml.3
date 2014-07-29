Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138AbaG2MPm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 08:15:42 -0400
Received: from smtp.devoid-pointer.net ([31.31.77.140]:49980 "EHLO
	smtp.devoid-pointer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbaG2MPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 08:15:41 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Jul 2014 08:15:40 EDT
From: Michal =?ISO-8859-1?Q?Mal=FD?= <madcatxster@devoid-pointer.net>
To: "Murphy, Dan" <dmurphy@ti.com>
Cc: "simon@mungewell.org" <simon@mungewell.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Elias Vanderstuyft <elias.vds@gmail.com>
Subject: Re: [v2] input: drv260x: Add TI drv260x haptics driver
Date: Tue, 29 Jul 2014 14:08:59 +0200
Message-ID: <2696156.zc98nP9bBH@sigyn>
User-Agent: KMail/4.13.3 (Linux/3.15.0-1-my-rd; KDE/4.13.3; x86_64; ; )
In-Reply-To: <00FC9A978A94B7418C33AFAE8A35ED49DB1A79@DFLE09.ent.ti.com>
References: <1406566403-1436-1-git-send-email-dmurphy@ti.com> <5adf0339146a7b655a77053195aa892c.squirrel@mungewell.org> <00FC9A978A94B7418C33AFAE8A35ED49DB1A79@DFLE09.ent.ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 of July 2014 21:21:26 Murphy, Dan wrote:
> Dmitry
> 
> On 07/28/2014 12:59 PM, simon@mungewell.org wrote:
> >>> The initial driver supports the devices
> >>> real time playback mode.  But the device
> >>> has additional wave patterns in ROM.
> >> 
> >> As it presented the device appears to be a memoryless device, however
> >> you present it to the rest of the system as if it can support playback
> >> of multiple effects simultaneously, which is incorrect.
> >> 
> >> My guess that you need to engage the memoryless input library to schedule
> >> handling multiple effects for your device, including ramping up, ramping
> >> down, stopping playback when effects runs out, etc.
> > 
> > Hi Dan,
> > Elias and Michal (cc'ed) are working on a kernel/userland library to
> > handle sending multiple force feedback signals to 'simple' devices,
> > perhaps you should engage with them.
> > 
> > Simon

Hi Dan,

since I spent some time trying to improve the memoryless library I can 
hopefully provide you with some hints.

If I'm reading this right, your device cannot play more than one effect at once 
but it can operate eihter in RTP mode where the user controls the operation of 
the motors directly on in an automated mode where the device follows some pre-
programmed waveform. These two modes are mutually exclusive.

If my understanding of the problem is correct, you will struggle both with 
memoryless library and your own imlementation. The memoryless library is quite 
simplistic and it doesn't have any sort of "passthrough" mode so you would not 
be able to do anything besides RTP that way.

On the other hand if you decide to write your own implementation of effect 
handling you will end up duplicating a lot of code that already exists in the 
memoryless library and has been proven to work.

A possible solution for the problem would be to separate the functions that 
control effect timing from the memoryless library and make them globally 
accessible. I believe that this would simplify any customized haptic 
implementation considerably and it might be a decent interim solution before 
the project Simon mentioned is ready.

If there is anybody interested in such a solution I can probably whip up a 
patch for it quite quickly.

Regards,
Michal

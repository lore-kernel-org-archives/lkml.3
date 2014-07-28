Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751369AbaG1R3B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 13:29:01 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:63813 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825AbaG1R26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 13:28:58 -0400
Date: Mon, 28 Jul 2014 10:28:53 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Nick Dyer <nick.dyer@itdev.co.uk>, benson Leung <bleung@chromium.org>,
        Yufeng Shen <miletus@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>, Yufeng Shen <miletus@google.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>,
        Olof Johansson <olofj@chromium.org>, Sekhar Nori <nsekhar@ti.com>
Subject: Re: [PATCH 00/15] atmel_mxt_ts - device tree, bootloader, etc
Message-ID: <20140728172853.GB8982@core.coreip.homeip.net>
References: <1404399697-26484-1-git-send-email-nick.dyer@itdev.co.uk>
 <53CECAEC.8080905@wwwdotorg.org>
 <53CFD50C.4040509@itdev.co.uk>
 <53CFEF6E.2060905@wwwdotorg.org>
 <53D10E78.4010908@itdev.co.uk>
 <53D17845.4020507@wwwdotorg.org>
 <53D26572.3030404@itdev.co.uk>
 <53D2B8D0.5090000@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53D2B8D0.5090000@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2014 at 02:06:40PM -0600, Stephen Warren wrote:
> On 07/25/2014 08:10 AM, Nick Dyer wrote:
> >On 24/07/14 22:19, Stephen Warren wrote:
> ...
> >>I've uploaded 2 logs to:
> >>
> >>http://avon.wwwdotorg.org/downloads/mxt-logs/
> >>(note there's no directory indexing, so manually add the filenames below to
> >>the URL)
> >>
> >>mxt-save-no-movement.xml
> >>
> >>This is with the whole series applied. Neither mouse movement nor clicks
> >>works. I tried mxt-app --reset and it made no difference to the dump results.
> >>
> >>mxt-save-move-ok-no-clicking.xml
> >>
> >>This is with "Input: atmel_mxt_ts - use deep sleep mode when stopped"
> >>reverted; mouse movement works, but clicking doesn't.
> >
> >Great, this has identified the issue with mouse movement (touch).
> >
> >The config programmed into the NVRAM on your touch controller has the first
> >byte of the T9 touchscreen object set to zero. This is the CTRL byte which
> >enables/disables the touch object and what it reports. It is relying on
> >this to enable the touchscreen on resume:
> >
> >https://github.com/dtor/input/blob/9d8dc3e529/drivers/input/touchscreen/atmel_mxt_ts.c#L2005-L2006
> >
> >My "use deep sleep mode when stopped" patch stops the driver writing to the
> >T9.CTRL byte, so whatever config you have in NVRAM for that byte will be
> >used (ie zero, disabled). Going forward, deep sleep is more generic.
> >Indeed, newer chips do not have T9 at all, or they might be using other
> >touch objects. The deep sleep mode is a lower power state to be in, and is
> >what Atmel recommends.
> >
> >However, it does mean changing the maxtouch cfg - you can write the 0x83 to
> >the first byte of T9 and save it to NVRAM, by doing:
> >
> >mxt-app [device] -W -T9 83
> >mxt-app [device] --backup
> 
> If I do that, then both mouse movement and "touch" clicks work:-)
> 
> (Dmitry, I guess that means it's fine to go ahead and apply "Input:
> atmel_mxt_ts - use deep sleep mode when stopped".)

OK, I've applied it (but because it now last I had to resolve a few
conflicts so if somebody could take a peek at my next branch that would
be great).

Thanks.

-- 
Dmitry

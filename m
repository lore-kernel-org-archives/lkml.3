Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356Ab3BRUeN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 15:34:13 -0500
Received: from SMTP.ANDREW.CMU.EDU ([128.2.11.96]:56045 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754543Ab3BRUeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 15:34:12 -0500
MIME-Version: 1.0
In-Reply-To: <CACWwPit=xxeeCW1+jfxE8eww+P545B5xebh3YT2yE78zcsqSMg@mail.gmail.com>
References: <20130214153255.GA5033@rhlx01.hs-esslingen.de> <744357E9AAD1214791ACBA4B0B90926329ED72@SHSMSX101.ccr.corp.intel.com>
 <20130215154931.GA26213@rhlx01.hs-esslingen.de> <CACWwPisqpmLjiqEh+J2DjnEtNObmmA0w=qMQYTgBsb6Ntad7Pw@mail.gmail.com>
 <744357E9AAD1214791ACBA4B0B90926329F98E@SHSMSX101.ccr.corp.intel.com> <CACWwPit=xxeeCW1+jfxE8eww+P545B5xebh3YT2yE78zcsqSMg@mail.gmail.com>
From: Alexander Lam <azl@andrew.cmu.edu>
Date: Mon, 18 Feb 2013 15:33:50 -0500
Message-ID: <CACWwPisHd+kGMn_AfDpTFSwtxT6Xg3iJtARKeBcCE0Rf=NHB=g@mail.gmail.com>
Subject: Re: thermal governor: does it actually work??
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-PMX-Version: 5.5.9.388399, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2010.4.9.4220
X-SMTP-Spam-Clean: 8% (
 BODY_SIZE_2000_2999 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, TO_NO_NAME 0, WEBMAIL_SOURCE 0, __BOUNCE_CHALLENGE_SUBJ 0, __BOUNCE_NDR_SUBJ_EXEMPT 0, __CP_URI_IN_BODY 0, __CT 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __HELO_GMAIL 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __PHISH_SPEAR_HTTP_RECEIVED 0, __PHISH_SPEAR_STRUCTURE_1 0, __PHISH_SPEAR_STRUCTURE_2 0, __RDNS_GMAIL 0, __SANE_MSGID 0, __TO_MALFORMED_2 0)
X-SMTP-Spam-Score: 8%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 18, 2013 7:11 AM, "Zhang, Rui" <rui.zhang@intel.com> wrote:
>
> Sorry I missed that patch.
>
> So the problem happens when the acerhdf thermal zone is registered when the fan has already been spinning, right?

Correct, when the acerhdf driver is switched into kernel controlled
mode and the fan is spinning, it stays spinning until the temperature
goes above the fan-on trip point and then below the fan-off trip
point. then the fan shuts off.

I don't have an opinion on how this is fixed, so do whatever you want
with my patch. Maybe you should drop it entirely if we do end up
applying Peter's fix.

>
>
>
> Thanks,
>
> rui
>
>
>
> From: Alexander Lam [mailto:azl@andrew.cmu.edu]
> Sent: Sunday, February 17, 2013 4:56 AM
> To: Andreas Mohr
> Cc: Zhang, Rui; linux-kernel@vger.kernel.org; R, Durgadoss; peter@piie.net; lenb@kernel.org
> Subject: Re: thermal governor: does it actually work??
> Importance: High
>
>
>
> I wrote a patch to fix this:
>
>
> http://lkml.org/lkml/2012/12/30/47
>
> But nobody picked it up and since then I have been too busy to respin the patch for new -rc kernels.
>
> -Alexander Lam
>
> On Fri, Feb 15, 2013 at 10:49 AM, Andreas Mohr <andi@lisas.de> wrote:
>
> Hi,
>
>
> On Fri, Feb 15, 2013 at 09:47:07AM +0000, Zhang, Rui wrote:
> > Please attach the output of
> > "grep . /sys/class/thermal/thermal_zone*/cdev*/*"?
>
> # grep . /sys/class/thermal/thermal_zone*/cdev*/*
> /sys/class/thermal/thermal_zone0/cdev0/cur_state:1
> /sys/class/thermal/thermal_zone0/cdev0/max_state:1
> grep: /sys/class/thermal/thermal_zone0/cdev0/power: Is a directory
> grep: /sys/class/thermal/thermal_zone0/cdev0/subsystem: Is a directory
> /sys/class/thermal/thermal_zone0/cdev0/type:acerhdf-fan
>
>
> > The question is that if we can also call it "throttle" when reducing the device performance to generate less heat.
>
> I won't continue to elaborate on this separate issue now, given that my time
> currently is very limited ;)
>
>
> Andreas Mohr
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>

-Alexander Lam

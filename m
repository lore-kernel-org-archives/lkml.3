Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400Ab3FWUaK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 16:30:10 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:55783 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100Ab3FWUaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 16:30:08 -0400
MIME-Version: 1.0
In-Reply-To: <51C75465.9060007@zytor.com>
References: <51C3DDFA.7050204@zytor.com>
	<51C69732.1010906@gmail.com>
	<b8bfa877-5663-4a93-94b4-6ea313e4d563@email.android.com>
	<20130623192936.GA28655@khazad-dum.debian.net>
	<51C75465.9060007@zytor.com>
Date: Mon, 24 Jun 2013 06:30:05 +1000
Message-ID: <CAPM=9tzkJTf4d=HfBUs3VwmNG1+Zo5J-JURYd4mYcJ82yXZOKg@mail.gmail.com>
Subject: Re: MTRR use in drivers
From: Dave Airlie <airlied@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Brice Goglin <brice.goglin@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        Andy Lutomirski <luto@amacapital.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Why do you care about performance when PAT is disabled?

breaking old boxes just because, is just going to get reverted when I
get the first regression report that you broke old boxes.

Andy Lutomirski just submitted a bunch of patches to clean up the DRM
usage of mtrrs, they are in drm-next, afaik we no longer add them on
PAT systems.

Dave.

>>
>> It will regress already slow boxes.  We blacklist a LOT of P4s, PMs, etc and
>> nobody ever took the pain to track down which ones of those actually have
>> PAT+MTRR aliasing bugs.
>>
>> These boxes have boards like the Radeon X300, which needs either PAT or MTRR
>> to not become unusable...
>>
>
> We're talking hardware which is now many years old, but this is causing
> very serious problems on real, modern hardware.  As far as I understand
> it, too, the blacklisting was precautionary (the only bug that I
> personally know about is a performance bug, where WC would be
> incorrectly converted to UC.)
>
> We need a way forward here.  If it is the only way I think we would have
> to sacrifice the old machines, but perhaps something can be worked out
> (e.g. if PAT is disabled, fall back to MTRRs if available for ioremap_wc()).
>
>         -hpa
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

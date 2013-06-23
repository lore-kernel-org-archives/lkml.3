Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752373Ab3FWUjF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 16:39:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42857 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751880Ab3FWUjD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 16:39:03 -0400
Message-ID: <51C75CD6.5010206@zytor.com>
Date: Sun, 23 Jun 2013 13:38:46 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Dave Airlie <airlied@gmail.com>
CC: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Brice Goglin <brice.goglin@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        Andy Lutomirski <luto@amacapital.net>
Subject: Re: MTRR use in drivers
References: <51C3DDFA.7050204@zytor.com> <51C69732.1010906@gmail.com> <b8bfa877-5663-4a93-94b4-6ea313e4d563@email.android.com> <20130623192936.GA28655@khazad-dum.debian.net> <51C75465.9060007@zytor.com> <CAPM=9tzkJTf4d=HfBUs3VwmNG1+Zo5J-JURYd4mYcJ82yXZOKg@mail.gmail.com>
In-Reply-To: <CAPM=9tzkJTf4d=HfBUs3VwmNG1+Zo5J-JURYd4mYcJ82yXZOKg@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2013 01:30 PM, Dave Airlie wrote:
>>>> Why do you care about performance when PAT is disabled?
> 
> breaking old boxes just because, is just going to get reverted when I
> get the first regression report that you broke old boxes.
> 

Not "just because", but *if* the choice is between breaking old boxes
and breaking new boxes I'll take the latter.

> Andy Lutomirski just submitted a bunch of patches to clean up the DRM
> usage of mtrrs, they are in drm-next, afaik we no longer add them on
> PAT systems.

Fantastic news.  No issue, then, and no need to break anything.

The only problem I see with having ioremap_wc() installing an MTRR on
non-PAT, rather than pushing that into the drivers which is clearly not
the right thing, is that we will need a hook to uninstall it when the
mapping is destroyed.

	-hpa




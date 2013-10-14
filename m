Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757332Ab3JNTJW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 15:09:22 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:49999 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757173Ab3JNTJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 15:09:21 -0400
Message-ID: <525C415A.2020505@gmail.com>
Date: Mon, 14 Oct 2013 21:09:14 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
To: Jason Cooper <jason@lakedaemon.net>
CC: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Roel Kluin <roel.kluin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] unset twsi option3 for gconfig as well
References: <1381706847-32762-1-git-send-email-roel.kluin@gmail.com> <CACRpkdb8ibOm61D_iGkOkbas1475n4k5jptnRH7VFk=9+pipHQ@mail.gmail.com> <20131014091230.65047d00@skate> <525C3B65.30501@gmail.com> <20131014190247.GN5402@titan.lakedaemon.net>
In-Reply-To: <20131014190247.GN5402@titan.lakedaemon.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2013 09:02 PM, Jason Cooper wrote:
> On Mon, Oct 14, 2013 at 08:43:49PM +0200, Sebastian Hesselbarth wrote:
> ...
>> You know a good way to determine how far it should go back to -stable?
>
> $ git blame -L 338,338 drivers/pinctrl/mvebu/pinctrl-dove.c
> c9f95ced drivers/pinctrl/pinctrl-dove.c (Sebastian Hesselbarth
> 2012-09-13 17:41:44 +0200 338)   gcfg2 &= ~(DOVE_TWSI_ENABLE_OPTION2 |
> DOVE_TWSI_ENABLE_OPTION2);
>
> $ git tag --contains c9f95ced | grep '^v[23]\.[0-9][0-9]*' | sed -r -e
> 's/^(v[23]\.[0-9][0-9]*).*$/\1.x/' | sort -uV
> v3.7.x
> v3.8.x
> v3.9.x
> v3.10.x
> v3.11.x
> v3.12.x
>
> so it should get flagged for v3.7 and newer.
>
> Watch out for really old stuff, the regex above doesn't properly handle
> v2.6.XX.x...

Ok, it is not in pre-v3.0, so the regex is fine. Thanks for the above -
and I also see git magic to resolve the rename of pinctrl-dove.c :)

If it originates from before the rename, I guess we need two different
-stable patches, one for pre-rename, one for post-rename?

Sebastian

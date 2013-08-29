Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286Ab3H2RUW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 13:20:22 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:42030 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753870Ab3H2RUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 13:20:20 -0400
MIME-Version: 1.0
In-Reply-To: <051069C10411E24D9749790C498526FA1BDE034D@SJEXCHMB12.corp.ad.broadcom.com>
References: <20130829171704.7a7630dd19d19ccdb9aaf384@canb.auug.org.au>
	<CACRpkdbHtjvY_VypnCQZNU2N1YqWtUv_grTK30A+tgEP3a0uwQ@mail.gmail.com>
	<051069C10411E24D9749790C498526FA1BDE034D@SJEXCHMB12.corp.ad.broadcom.com>
Date: Thu, 29 Aug 2013 19:20:19 +0200
Message-ID: <CACRpkdY-4+CJpCwGsbpb7mo0zRevEmpmoyirxeB9FbU0sS=GsQ@mail.gmail.com>
Subject: Re: linux-next: manual merge of the pinctrl tree with Linus' tree
From: Linus Walleij <linus.walleij@linaro.org>
To: Sherman Yin <syin@broadcom.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 29, 2013 at 5:24 PM, Sherman Yin <syin@broadcom.com> wrote:

> Hmm, I fixed this the first time I ported over to LinusW's devel tree,
> but when I rebased on Sunday, the spin lock commit seemed to be
> reverted or gone.

My pinctrl devel branch was branched off of v3.11-rc1, and the
spinlock changes were in some later -rc and I didn't merge
them in until now, because I thought they were orthogonal.

How wrong I was. So merged in -rc7 now and pushed, please
check the end result or linux-next.

> Note the following return in between the locking and unlocking -
> need an unlock there?
>
>> +              case PIN_CONFIG_DRIVE_STRENGTH:
>> +                      strength = pinconf_to_config_argument(configs[i]);
>> +                      if (strength > 40)
>> +                              return -EINVAL;

Argh. Send a patch with your reported-by tag...

Yours,
Linus Walleij

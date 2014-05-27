Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752242AbaE0QZ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 12:25:27 -0400
Received: from cluster-g.mailcontrol.com ([208.87.233.190]:60178 "EHLO
	cluster-g.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbaE0QZY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 12:25:24 -0400
X-Greylist: delayed 4448 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 May 2014 12:25:24 EDT
X-PGP-Universal: processed;
	by shaapppus01.asia.root.pri on Tue, 27 May 2014 23:10:44 +0800
From: Barry Song <Barry.Song@csr.com>
To: Linus Walleij <linus.walleij@linaro.org>, Barry Song <baohua@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        Linux GPIO List <linux-gpio@vger.kernel.org>,
        DL-SHA-WorkGroupLinux <DL-SHA-WorkGroupLinux@internal.csr.com>
Subject: RE: [PATCH 1/2] RFT: pinctrl: sirf: switch to using allocated state
 container
Thread-Topic: [PATCH 1/2] RFT: pinctrl: sirf: switch to using allocated
 state container
Thread-Index: AQHPXzlcp65ZtUBeBUusitoQUTIPSZsrLWqAgAyIgwCAGOutgIADeK8AgACijdM=
Date: Tue, 27 May 2014 15:10:38 +0000
Message-ID: <5EB3BFCD089AD643B9BB63439F5FD5E9012BF02A09@SHAASIEXM01.ASIA.ROOT.PRI>
References: <1398287792-19831-1-git-send-email-linus.walleij@linaro.org>
	<1398287792-19831-2-git-send-email-linus.walleij@linaro.org>
	<CAGsJ_4wOdD53Fkf+_CtDqSg5Yvz-1kwaWzMJb357uq5BL9_-7Q@mail.gmail.com>
	<CACRpkdbieXh8iHSCqai03vNbBZ2_2zV1SscXLY+4T9ZprWJEvQ@mail.gmail.com>
	<CAGsJ_4ygjo_cUFR8bUoWsGrZYHSubam4WWcb-TjQJNjgy9rvKQ@mail.gmail.com>,<CACRpkdbQeJwoP7oOzbuhJeuFWxbB5RjFvzqqp8E_1x3=6p-hnQ@mail.gmail.com>
In-Reply-To: <CACRpkdbQeJwoP7oOzbuhJeuFWxbB5RjFvzqqp8E_1x3=6p-hnQ@mail.gmail.com>
Accept-Language: en-US, zh-CN, en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.125.1.254]
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij [linus.walleij@linaro.org]
Sent: Tuesday, May 27, 2014 21:27
To: Barry Song
Cc: LKML; Barry Song; Linux GPIO List; DL-SHA-WorkGroupLinux
Subject: Re: [PATCH 1/2] RFT: pinctrl: sirf: switch to using allocated state container

On Sun, May 25, 2014 at 10:26 AM, Barry Song <baohua@kernel.org> wrote:
> 2014-05-09 19:53 GMT+08:00 Linus Walleij <linus.walleij@linaro.org>:
>> On Thu, May 1, 2014 at 2:29 PM, Barry Song <baohua@kernel.org> wrote:
>>> 2014-04-24 5:16 GMT+08:00 Linus Walleij <linus.walleij@linaro.org>:
>>
>>>> This rewrites the SIRF pinctrl driver to allocate a state container
>>>> for the GPIO chip, just as is done for the pin controller, and
>>>> use the gpiochip_add_pin_range() to add the range from the gpiochip
>>>> side rather than adding the range from the pinctrl side.
>>>>
>>>> All resulting changes are done in order to pass around a state
>>>> container rather than refer to a static global object.
>>>>
>>>> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
>>>
>>> Linus, thanks! but this breaks prima2 pinctrl subsystem, do you have an idea?
>>> otherwise i will do a debug to find the reason.
>>
>> Unfortunately no :-(
>>
>> This is the downside of dry-coding ... I rely on others to help out.
>>
>> See it as a suggestion to what I think should be refactored and how,
>> I'll keep it on a branch as some "TODO" item for the moment.
>>
>
>> after moving pinctrl name from sirfsoc-gpio* to dev_name(&pdev->dev) as below:
>> - err = gpiochip_add_pin_range(&sgpio->chip.gc, "sirfsoc-gpio*",
>> + err = gpiochip_add_pin_range(&sgpio->chip.gc, dev_name(&pdev->dev),
>>
>> Acked-by: Barry Song <Baohua.Song@csr.com>

>Does this mean it works with that change so it's a Tested-by?

yes. with the above change.

>I don't want to apply it if something breaks...

>Yours,
>Linus Walleij

-barry

Member of the CSR plc group of companies. CSR plc registered in England and Wales, registered number 4187346, registered office Churchill House, Cambridge Business Park, Cowley Road, Cambridge, CB4 0WZ, United Kingdom
More information can be found at www.csr.com. Keep up to date with CSR on our technical blog, www.csr.com/blog, CSR people blog, www.csr.com/people, YouTube, www.youtube.com/user/CSRplc, Facebook, www.facebook.com/pages/CSR/191038434253534, or follow us on Twitter at www.twitter.com/CSR_plc.
New for 2014, you can now access the wide range of products powered by aptX at www.aptx.com.

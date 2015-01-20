Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772AbbATCIU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 21:08:20 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:47697 "EHLO
	rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672AbbATCHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 21:07:44 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.52 with qID t0K27SOs027426, This message is accepted by code: ctloc85258
From: =?utf-8?B?5pWs6ZSQ?= <micky_ching@realsil.com.cn>
To: Lee Jones <lee.jones@linaro.org>
CC: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "rogerable@realtek.com" <rogerable@realtek.com>,
        =?utf-8?B?546L54Kc?= <wei_wang@realsil.com.cn>
Subject: Re: [PATCH 06/10] mfd: rtsx: update phy register
Thread-Topic: [PATCH 06/10] mfd: rtsx: update phy register
Thread-Index: AQHQMxp6FjKtWIsBHka3fJmxZldZbpzGKcgAgABiL4CAATNmAA==
Date: Tue, 20 Jan 2015 02:07:26 +0000
Message-ID: <54BDB860.9080704@realsil.com.cn>
References: <cover.1421320541.git.micky_ching@realsil.com.cn>
 <38141c346f29fcf48b4dc168c1841c8732c70b4c.1421320541.git.micky_ching@realsil.com.cn>
 <20150118122947.GM3574@x1> <54BC6426.40902@realsil.com.cn>
 <20150119074715.GO3574@x1>
In-Reply-To: <20150119074715.GO3574@x1>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.29.41.103]
Content-Type: text/plain; charset="utf-8"
Content-ID: <A3E57549AFCF5841BA0555B408700220@realsil.com.cn>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0K28Uog007678


On 01/19/2015 03:47 PM, Lee Jones wrote:
> On Mon, 19 Jan 2015, æ•¬é” wrote:
>> >On 01/18/2015 08:29 PM, Lee Jones wrote:
>>> > >On Thu, 15 Jan 2015,micky_ching@realsil.com.cn  wrote:
>>> > >
>>>> > >>From: Micky Ching<micky_ching@realsil.com.cn>
>>>> > >>
>>>> > >>update phy register value and using direct value instead of macros.
>>>> > >>It is much easier to debug using constant value than a lot of macros.
>>>> > >>We usually need compare the value directly to check the configure.
>>> > >NACK.  This is the opposite of what I would like to see.
>>> > >
>> >When we debug, we usually need to compare the value provided from hardware,
>> >of course we can compare by print them to kernel log. but I think it more
>> >convenient from source code. And we only set phy register when
>> >initialize chip,
>> >so the value will not scattered everywhere, we will not benefit from macros.
>> >
>> >if we want to know the meaning of setting, we can look at the register
>> >define.
> This is not acceptable and is the complete opposite of what we're
> trying to achieve.  I promote readability (by humans) as one of the
> highest priorities when writing code.  0xFE6C is far from readable.
>
Because the truly thing we concerned is the address and value, not
a lot of macros. 0xFE6C is a magic number, but a lot of macros
even hide the magic number we curious. To verify if the source
code is right, we only need to compare the value, if too much macros
joined together, the work is boring and easy to inject errors.
I hate magic number too, but in this case using magic number
is deserved for correctness.

Two method can help enhance readability.
(1). define register address and values
If we want to know what the bit field means, we can jump to the register
define. This is very easy by tag system.
eg.
rtsx_pci_write_phy_register(pcr, PHY_BPCR, 0x05C0);
we can jump to PHY_BPCR to see bit-field define.

(2). add comment for magic number.
I don't like comment.

If you still like macro list, I will update the register next patch.

regards.
micky.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

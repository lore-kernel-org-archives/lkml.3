Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839AbaLHJuE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 04:50:04 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:58010 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754492AbaLHJt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 04:49:59 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.49 with qID sB89nSFQ024429, This message is accepted by code: ctloc85258
From: =?utf-8?B?5pWs6ZSQ?= <micky_ching@realsil.com.cn>
To: Lee Jones <lee.jones@linaro.org>
CC: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "chris@printf.net" <chris@printf.net>,
        "ulf.hansson@linaro.org" <ulf.hansson@linaro.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "dan.carpenter@oracle.com" <dan.carpenter@oracle.com>,
        "rogerable@realtek.com" <rogerable@realtek.com>,
        =?utf-8?B?546L54Kc?= <wei_wang@realsil.com.cn>
Subject: Re: [PATCH v4 1/6] mfd: rtsx: add func to split u32 into register
Thread-Topic: [PATCH v4 1/6] mfd: rtsx: add func to split u32 into register
Thread-Index: AQHQEE+fRoR/oTBMgUiwD+7H/IHqKZyE4RSAgAAQtYA=
Date: Mon, 8 Dec 2014 09:49:29 +0000
Message-ID: <54857429.5060108@realsil.com.cn>
References: <cover.1417758564.git.micky_ching@realsil.com.cn>
 <17ba65f4bdf4707bdf038e407ecf5dc012bca281.1417758564.git.micky_ching@realsil.com.cn>
 <20141208084941.GC3951@x1>
In-Reply-To: <20141208084941.GC3951@x1>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.29.41.103]
Content-Type: text/plain; charset="utf-8"
Content-ID: <B729F5F28621554F831E05B742781600@realsil.com.cn>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sB89oGVn024166


On 12/08/2014 04:49 PM, Lee Jones wrote:
>> diff --git a/include/linux/mfd/rtsx_pci.h b/include/linux/mfd/rtsx_pci.h
>> >index 74346d5..9234449 100644
>> >--- a/include/linux/mfd/rtsx_pci.h
>> >+++ b/include/linux/mfd/rtsx_pci.h
>> >@@ -558,6 +558,7 @@
>> >  #define SD_SAMPLE_POINT_CTL		0xFDA7
>> >  #define SD_PUSH_POINT_CTL		0xFDA8
>> >  #define SD_CMD0				0xFDA9
>> >+#define   SD_CMD_START			0x40
> This is a different format at the others in the group on two counts;
> firstly you have 3 whitespace characters after the #define and
> secondly all of the other hex digits in the set are 4 a breast.
> Please add the leading zeros to conform to this format.
>
Hi lee,

This format is more readable, add 2 space means this value is
in groups under register SD_CMD0, and each register value is u8 type,
so use 2 hex digits is right.

The original file make register address and its related value separated,
and group register together.

But I like to write register address and value together,
add 2 space for value to indicate this value is related to above register.

If we add new address/value, I recommend write register define format as 
below:

#define REGISTER        addr
#define   REG_VAL1      val1
#define   REG_VAL2      val2

regards.
micky.ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

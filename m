Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751291AbaK1CLP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 21:11:15 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:38502 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035AbaK1CLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 21:11:13 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.49 with qID sAS2Ab05024480, This message is accepted by code: ctloc85258
From: =?gb2312?B?vrTI8Q==?= <micky_ching@realsil.com.cn>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>,
        "chris@printf.net" <chris@printf.net>,
        "ulf.hansson@linaro.org" <ulf.hansson@linaro.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?gb2312?B?zfXsvw==?= <wei_wang@realsil.com.cn>,
        "rogerable@realtek.com" <rogerable@realtek.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: Re: [PATCH 1/2] mfd: rtsx: add func to split u32 into register
Thread-Topic: [PATCH 1/2] mfd: rtsx: add func to split u32 into register
Thread-Index: AQHQCe14eJjs+qSYFEq1JMJqIBseQJx0EkkAgAC0vgA=
Date: Fri, 28 Nov 2014 02:10:36 +0000
Message-ID: <5477D99C.3050903@realsil.com.cn>
References: <cover.1417056337.git.micky_ching@realsil.com.cn>
 <51dde5250305623c420e78fa555800ef8fef0a09.1417056337.git.micky_ching@realsil.com.cn>
 <20141127152342.GA4860@mwanda>
In-Reply-To: <20141127152342.GA4860@mwanda>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.29.41.103]
Content-Type: text/plain; charset="gb2312"
Content-ID: <63CA8A83D9765F4584626F69C3CFC288@realsil.com.cn>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sAS2BNcb028591


On 11/27/2014 11:23 PM, Dan Carpenter wrote:
>> +static inline void rtsx_pci_write_be32(struct rtsx_pcr *pcr, u16 reg, u32 val)
>> >+{
>> >+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, reg,     0xFF, val >> 24);
>> >+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, reg + 1, 0xFF, val >> 16);
>> >+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, reg + 2, 0xFF, val >> 8);
>> >+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, reg + 3, 0xFF, val);
> This assumes the cpu is little endian.  First convert to big endian
> using cpu_to_be32() and then write it out.
>
> 	__be32 be_val = cpu_to_be32()
>
> 	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, reg,     0xFF, be_val);
> 	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, reg + 1, 0xFF, be_val >> 8);
> 	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, reg + 2, 0xFF, be_val >> 16);
> 	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, reg + 3, 0xFF, be_val >> 24);
>
> (Written hurredly in my mail client.  May be wrong).
>
I think we better not use cpu_to_be32() here, leave the work to caller
may be better.

eg, in sd_ops.c the cmd.arg is constructed bit by bit, we can put the right
byte to the right register by shift, so the endian check is not need.ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

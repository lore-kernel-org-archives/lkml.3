Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756831Ab3LWCDr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Dec 2013 21:03:47 -0500
Received: from mailout.micron.com ([137.201.242.129]:35440 "EHLO
	mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756369Ab3LWCDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Dec 2013 21:03:46 -0500
From: =?utf-8?B?UWkgV2FuZyDnjovotbcgKHFpd2FuZyk=?= <qiwang@micron.com>
To: "dedekind1@gmail.com" <dedekind1@gmail.com>
CC: "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "Adrian Hunter" <adrian.hunter@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/1]  MTD: UBI:  try to avoid program data to NOR flash
 after erasure interrupted
Thread-Topic: [PATCH 1/1]  MTD: UBI:  try to avoid program data to NOR flash
 after erasure interrupted
Thread-Index: AQHO1LohJ4btsOLy+UGZvSz+R+JMF5oOJsqAgAFqmACAUcpQkA==
Date: Mon, 23 Dec 2013 02:03:16 +0000
Message-ID: <71CF8D7F32C5C24C9CD1D0E02D52498A770B943C@NTXXIAMBX02.xacn.micron.com>
References: <71CF8D7F32C5C24C9CD1D0E02D52498A77082AC5@NTXXIAMBX02.xacn.micron.com>
	 <71CF8D7F32C5C24C9CD1D0E02D52498A77082DDB@NTXXIAMBX02.xacn.micron.com>
	 <71CF8D7F32C5C24C9CD1D0E02D52498A770AED11@NTXXIAMBX02.xacn.micron.com>
	 <71CF8D7F32C5C24C9CD1D0E02D52498A770AED44@NTXXIAMBX02.xacn.micron.com>
	 <71CF8D7F32C5C24C9CD1D0E02D52498A770AED67@NTXXIAMBX02.xacn.micron.com>
	 <1382779164.5901.1.camel@karhu.quadriga.com>
	 <71CF8D7F32C5C24C9CD1D0E02D52498A770B1B97@NTXXIAMBX02.xacn.micron.com>
	 <1383059901.29619.52.camel@sauron.fi.intel.com>
	 <71CF8D7F32C5C24C9CD1D0E02D52498A770B220C@NTXXIAMBX02.xacn.micron.com>
 <1383296284.2722.73.camel@sauron.fi.intel.com>
In-Reply-To: <1383296284.2722.73.camel@sauron.fi.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.167.84.5]
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-7.000.1014-20378.003
X-TM-AS-Result: No--32.693700-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
x-mt-checkinternalsenderrule: True
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rBN24OST023091

Hi Artem:
Sorry to interrupt your busy life. 
As you said in previous mail, I send my patch separately without quoting this e-mail. And I have send to you, but I never get  your reply. I am very confuse, no sure if is there anything wrong at the patch I send to you.
Can you help explain to me?
Thanks

-----Original Message-----
From: Artem Bityutskiy [mailto:dedekind1@gmail.com] 
Sent: Friday, November 01, 2013 4:58 PM
To: Qi Wang ç‹èµ· (qiwang)
Cc: linux-mtd@lists.infradead.org; Adrian Hunter; linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] MTD: UBI: try to avoid program data to NOR flash after erasure interrupted

Hi,

could you please re-send your patch separately, without quoting any
parts of this conversation, so that I could use 'git am'.

Your patch also contains trailing white-spaces, please, get rid of them
in the next submission.

Also, could you please clearly state whether you have tested this patch
on a real NOR flash or not. If yes, then could you share the chip
vendor/type information?

On Thu, 2013-10-31 at 04:07 +0000, Qi Wang ç‹èµ· (qiwang) wrote:

> --- a/drivers/mtd/ubi/io.c
> +++ b/drivers/mtd/ubi/io.c
> @@ -499,59 +499,44 @@ static int nor_erase_prepare(struct ubi_device *ubi, int pnum)
>  	size_t written;
>  	loff_t addr;
>  	uint32_t data = 0;
> -	/*
> -	 * Note, we cannot generally define VID header buffers on stack,
> -	 * because of the way we deal with these buffers (see the header
> -	 * comment in this file). But we know this is a NOR-specific piece of
> -	 * code, so we can do this. But yes, this is error-prone and we should
> -	 * (pre-)allocate VID header buffer instead.
> -	 */

Please, do not remove this comment.

>  	struct ubi_vid_hdr vid_hdr;
> +	struct ubi_ec_hdr ec_hdr;

To make it obvious what the above big comment talks about, could you
please define 'struct ubi_ec_hdr ec_hdr' above that big comment.

Otherwise looks good to me, thank you!


> My Comments for above changing:
> 1. 
> 	-	/*
> 	-	 * Note, we cannot generally define VID header buffers on stack,
> 	-	 * because of the way we deal with these buffers (see the header
> 	-	 * comment in this file). But we know this is a NOR-specific piece of
> 	-	 * code, so we can do this. But yes, this is error-prone and we should
> 	-	 * (pre-)allocate VID header buffer instead.
> 	-	 */
> 	I remove above comment, because I pre-allocate VID header and EC header together. 
> 	So I think no need to emphasize VID header buffers cannot be on stack.
> 	(Maybe my understanding about this comment is error, if so, please correct me)

The problem is that some functions in io.c can read or write _beyond_
sizeof(struct ubi_vid_hdr), but this is only relevant to NAND, not for
NOR, and the code you change is NOR-only. This is why that comment is
there, and I'd like to keep it.

> 2.
> 	why use
> 	"if (err != UBI_IO_BAD_HDR_EBADMSG && err != UBI_IO_BAD_HDR && err != UBI_IO_FF)"
> 	but not 
> 	"if (!err)" 
> 	to judge if need to program '0' to invalid this block.
> 
> 	In case err == UBI_IO_FF_BITFLIPS, err == UBI_IO_BITFLIPS or unexpected value return
> 	from read function, I think UBI still need to invalid this block for above mentioned 
> 	condition. So I use
> 	"if (err != UBI_IO_BAD_HDR_EBADMSG && err != UBI_IO_BAD_HDR && err != UBI_IO_FF)"
> 	to judge. 

In case of UBI_IO_FF (all FFs) UBI will erase the eraseblock before
using it anyway, so invalidation is not necessary.

Thanks!

-- 
Best Regards,
Artem Bityutskiy

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

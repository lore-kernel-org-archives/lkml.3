Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450Ab3DZPGJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 11:06:09 -0400
Received: from usindpps05.hds.com ([207.126.252.18]:52309 "EHLO
	usindpps05.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943Ab3DZPGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 11:06:07 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Matt Fleming <matt.fleming@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "mjg59@srcf.ucam.org" <mjg59@srcf.ucam.org>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "jk@ozlabs.org" <jk@ozlabs.org>, "teg@jklm.no" <teg@jklm.no>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mikew@google.com" <mikew@google.com>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: RE: [tip:x86/efi2] efivars: efivar_entry API
Thread-Topic: [tip:x86/efi2] efivars: efivar_entry API
Thread-Index: AQHOPHFEzrlus8pItEq77hQ4E6Icb5jkge3AgAQQugCAAAb/4IAATJsA//+/wOA=
Date: Fri, 26 Apr 2013 15:05:46 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D41AFD1FAD@USINDEM103.corp.hds.com>
References: <tip-e14ab23dde12b80db4c94b684a2e485b72b16af3@git.kernel.org>
 <A5ED84D3BB3A384992CBB9C77DEDA4D41AFCC9D0@USINDEM103.corp.hds.com>
 <517A4F2A.4080906@intel.com>
 <A5ED84D3BB3A384992CBB9C77DEDA4D41AFD1E2B@USINDEM103.corp.hds.com>
 <517A954C.7060505@intel.com>
In-Reply-To: <517A954C.7060505@intel.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.73.11]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx ip4:207.126.244.0/26 ip4:207.126.252.0/25 include:mktomail.com
 ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8626,1.0.431,0.0.0000
 definitions=2013-04-26_05:2013-04-26,2013-04-26,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1211240000
 definitions=main-1304260116
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r3QF6GV4004268

It worked with this fix.
Thanks!

Seiji

> -----Original Message-----
> From: Matt Fleming [mailto:matt.fleming@intel.com]
> Sent: Friday, April 26, 2013 10:55 AM
> To: Seiji Aguchi
> Cc: linux-kernel@vger.kernel.org; mingo@kernel.org; hpa@zytor.com; mjg59@srcf.ucam.org; tony.luck@intel.com; jk@ozlabs.org;
> teg@jklm.no; tglx@linutronix.de; mikew@google.com; linux-tip-commits@vger.kernel.org
> Subject: Re: [tip:x86/efi2] efivars: efivar_entry API
> 
> On 26/04/13 15:25, Seiji Aguchi wrote:
> > Matt,
> >
> > Thanks.
> > With your patch, It works in case each entry is erased one by one as below.
> > # rm dmesg-efi-1
> > #rm dmesg-efi-2
> 
> How about if you add this to efi_pstore_erase_func()?
> 
> ---
> 
> diff --git a/drivers/firmware/efi/efi-pstore.c b/drivers/firmware/efi/efi-pstore.c
> index b820593..393d63a 100644
> --- a/drivers/firmware/efi/efi-pstore.c
> +++ b/drivers/firmware/efi/efi-pstore.c
> @@ -166,6 +166,7 @@ static int efi_pstore_erase_func(struct efivar_entry *entry, void *data)
> 
>  	/* found */
>  	__efivar_entry_delete(entry);
> +	list_del(&entry->list);
>  	return 1;
>  }
> 
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

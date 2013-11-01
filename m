Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837Ab3KATWj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 15:22:39 -0400
Received: from usindpps05.hds.com ([207.126.252.18]:47251 "EHLO
	usindpps05.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457Ab3KATWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 15:22:37 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Tony Luck <tony.luck@gmail.com>,
        Richard Weinberger <richard.weinberger@gmail.com>
CC: Madper Xie <cxie@redhat.com>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Linux EFI" <linux-efi@vger.kernel.org>,
        =?gb2312?B?0Luzyb+l?= <bbboson@gmail.com>
Subject: RE: [PATCH] Make efi-pstore return a unique id
Thread-Topic: [PATCH] Make efi-pstore return a unique id
Thread-Index: AQHO1x11Ng/G6VnJcECFaGjfqkQ0X5oQ08KAgAApt4D//8FFUA==
Date: Fri, 1 Nov 2013 19:22:12 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D47F9DD941@USINDEM103.corp.hds.com>
References: <87ppqk6qvx.fsf@redhat.com>
	<CAFLxGvz3pCevxE43zGnrbX4MxPmwyb=9MVNpzFRpELt1+AmtrA@mail.gmail.com>
 <CA+8MBbJefz7L-C-LnhAAXB5zf-8XoMPhESPU4yd0wnuZ_YqO1w@mail.gmail.com>
In-Reply-To: <CA+8MBbJefz7L-C-LnhAAXB5zf-8XoMPhESPU4yd0wnuZ_YqO1w@mail.gmail.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.73.11]
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx ip4:207.126.244.0/26 ip4:207.126.252.0/25 include:mktomail.com
 include:cloud.hds.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-11-01_05:2013-11-01,2013-11-01,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=outbound_policy score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1311010157
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rA1JMghl001829

> >> +{
> >> +       char id_str[64];
> >> +       u64 id = 0;
> >> +
> >> +       sprintf(id_str, "%lu%u%d", timestamp, part, count);
> >> +       if (kstrtoull(id_str, 10, &id))
> >> +               pr_warn("efi-pstore: failed to generate id\n");
> >> +       return id;
> >> +}
> >
> > This is just odd. You make a string from three ints and then a parse
> > it to a int again.
> 
> Agreed.  I liked your ((timestamp * 100 + part) * 100 + count function much
> more than this.

I was worried that the part and count could be more than 100.
If it happens, the id may not be unique...

But, currently, size of nvram storage is limited, so it is a corner case.
I respect your opinion.

> @@ -125,9 +137,11 @@ static int efi_pstore_write(enum pstore_type_id type,
>  	efi_char16_t efi_name[DUMP_NAME_LEN];
>  	efi_guid_t vendor = LINUX_EFI_CRASH_GUID;
>  	int i, ret = 0;
> +	unsigned long timestamp;
> 
> +	timestamp = get_seconds();
>  	sprintf(name, "dump-type%u-%u-%d-%lu-%c", type, part, count,
> -		get_seconds(), compressed ? 'C' : 'D');
> +		timestamp, compressed ? 'C' : 'D');
> 

I don't think you need to change efi_pstore_write().
It is just add a local timestamp variable.

Seiji

>  	for (i = 0; i < DUMP_NAME_LEN; i++)
>  		efi_name[i] = name[i];
> --
> 1.8.4.2
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

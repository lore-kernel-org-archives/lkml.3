Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752182Ab3KBM2z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Nov 2013 08:28:55 -0400
Received: from usindpps05.hds.com ([207.126.252.18]:51657 "EHLO
	usindpps05.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982Ab3KBM2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Nov 2013 08:28:53 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Tony Luck <tony.luck@gmail.com>
CC: Richard Weinberger <richard@nod.at>, Madper Xie <cxie@redhat.com>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linux EFI <linux-efi@vger.kernel.org>,
        =?gb2312?B?0Luzyb+l?= <bbboson@gmail.com>
Subject: RE: [PATCH] Make efi-pstore return a unique id
Thread-Topic: [PATCH] Make efi-pstore return a unique id
Thread-Index: AQHO1x11Ng/G6VnJcECFaGjfqkQ0X5oQ08KAgAApt4D//8FFUIAAUlQA///ElKCAAIDfAIAAh0fw
Date: Sat, 2 Nov 2013 12:28:19 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D47F9DE083@USINDEM103.corp.hds.com>
References: <87ppqk6qvx.fsf@redhat.com>
	<CAFLxGvz3pCevxE43zGnrbX4MxPmwyb=9MVNpzFRpELt1+AmtrA@mail.gmail.com>
	<CA+8MBbJefz7L-C-LnhAAXB5zf-8XoMPhESPU4yd0wnuZ_YqO1w@mail.gmail.com>
	<A5ED84D3BB3A384992CBB9C77DEDA4D47F9DD941@USINDEM103.corp.hds.com>
	<52740A3A.70202@nod.at>
	<A5ED84D3BB3A384992CBB9C77DEDA4D47F9DDA4D@USINDEM103.corp.hds.com>
 <CA+8MBbKMRw28Ubr5F8U=5SKuaeutR+KEVDgJC70Xebj4O5BzpA@mail.gmail.com>
In-Reply-To: <CA+8MBbKMRw28Ubr5F8U=5SKuaeutR+KEVDgJC70Xebj4O5BzpA@mail.gmail.com>
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
 definitions=2013-11-02_01:2013-11-02,2013-11-02,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=outbound_policy score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1311020074
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rA2CTRtV005146

> How does efivars backend handle "unlink(2)" in the pstore file system.
> pstore will call the backend->erase function passing the "id".  The
> backend should then erase the right record from persistent storage.
> 
> With the  ((timestamp * 100 + part) * 100 + count function - you can
> easily reverse it to find timestamp, part and count - would that make life
> easier for the backend to find the record to be erased?  If you use a
> hash function you will need to check each record and compute the
> hash to see if it matches (probably not a big deal because the backend
> will generally only hold a handful of records).

By generating the id in  efi_pstore_write(), and using it to a variable name,
It works at an erasing time as well.

The root cause of this problem is that efivars used "part" as id.
It was a wrong way. So, we should not keep it.

Seiji


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

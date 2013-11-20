Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926Ab3KTPSW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 10:18:22 -0500
Received: from usindpps06.hds.com ([207.126.252.19]:43988 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608Ab3KTPST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 10:18:19 -0500
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Madper Xie <cxie@redhat.com>, Richard Weinberger <richard@nod.at>
CC: Tony Luck <tony.luck@gmail.com>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Linux EFI" <linux-efi@vger.kernel.org>,
        =?gb2312?B?0Luzyb+l?= <bbboson@gmail.com>
Subject: RE: [PATCH] Make efi-pstore return a unique id
Thread-Topic: [PATCH] Make efi-pstore return a unique id
Thread-Index: AQHO1x11Ng/G6VnJcECFaGjfqkQ0X5oQ08KAgAApt4D//8FFUIAAUlQAgB06dgCAAAom8A==
Date: Wed, 20 Nov 2013 15:17:55 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D47FA0B6EF@USINDEM103.corp.hds.com>
References: <87ppqk6qvx.fsf@redhat.com>
 <CAFLxGvz3pCevxE43zGnrbX4MxPmwyb=9MVNpzFRpELt1+AmtrA@mail.gmail.com>
 <CA+8MBbJefz7L-C-LnhAAXB5zf-8XoMPhESPU4yd0wnuZ_YqO1w@mail.gmail.com>
 <A5ED84D3BB3A384992CBB9C77DEDA4D47F9DD941@USINDEM103.corp.hds.com>
 <52740A3A.70202@nod.at> <87r4abmnfb.fsf@redhat.com>
In-Reply-To: <87r4abmnfb.fsf@redhat.com>
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
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.14,0.0.0000
 definitions=2013-11-20_06:2013-11-20,2013-11-20,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=outbound_policy score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1311200096
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rAKFIStH010229


> Then will lost the sequence of our log. We will get lots of entries like
> "dmesg-efi-`unique but meaningless number here`" in pstore fs. Who will
> know which file is the latest record?

Ah, that's good point.

> And another side, the combin of timestamp, count and part is unique. Why
> we generate a unique number from a unique number?
> if you think "making a string from three ints and then a parse it to a
> int again" is odd, i'd like to use ((timestamp * 100 + part) * 100 +
> count.

How about calculating the number of digit of part /count, instead of using fixed "100"?
We can ensure the uniqueness of each id by doing it.

digit_num = log2(part)/log2(10) + 1
timestamp * 10^(digit_num + 1)

Seiji
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

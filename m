Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647Ab3HVXr1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 19:47:27 -0400
Received: from usindpps03.hds.com ([207.126.252.16]:59293 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754081Ab3HVXr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 19:47:26 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: "Luck, Tony" <tony.luck@intel.com>,
        Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>,
        "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "keescook@chromium.org" <keescook@chromium.org>
CC: "jkenisto@linux.vnet.ibm.com" <jkenisto@linux.vnet.ibm.com>,
        "ananth@in.ibm.com" <ananth@in.ibm.com>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "cbouatmailru@gmail.com" <cbouatmailru@gmail.com>,
        "mahesh@linux.vnet.ibm.com" <mahesh@linux.vnet.ibm.com>,
        "ccross@android.com" <ccross@android.com>
Subject: RE: [RFC PATCH v2 04/11] pstore: Add compression support to pstore
Thread-Topic: [RFC PATCH v2 04/11] pstore: Add compression support to pstore
Thread-Index: AQHOmoMcsKHK3fNXLUCcb5sKdMjJG5mhyInAgABg8gD//7/iMA==
Date: Thu, 22 Aug 2013 23:47:02 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D443E8F1E2@USINDEM103.corp.hds.com>
References: <20130816131403.3338.82330.stgit@aruna-ThinkPad-T420>
 <20130816131805.3338.68767.stgit@aruna-ThinkPad-T420>
 <A5ED84D3BB3A384992CBB9C77DEDA4D443E8F0D7@USINDEM103.corp.hds.com>
 <3908561D78D1C84285E8C5FCA982C28F31CC7AC0@ORSMSX106.amr.corp.intel.com>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F31CC7AC0@ORSMSX106.amr.corp.intel.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.73.11]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx ip4:207.126.244.0/26 ip4:207.126.252.0/25 include:mktomail.com
 include:cloud.hds.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-08-22_09:2013-08-22,2013-08-22,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=outbound_policy score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1308220179
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r7MNlXCW002402



> -----Original Message-----
> From: Luck, Tony [mailto:tony.luck@intel.com]
> Sent: Thursday, August 22, 2013 7:17 PM
> To: Seiji Aguchi; Aruna Balakrishnaiah; linuxppc-dev@ozlabs.org; linux-kernel@vger.kernel.org; keescook@chromium.org
> Cc: jkenisto@linux.vnet.ibm.com; ananth@in.ibm.com; benh@kernel.crashing.org; cbouatmailru@gmail.com;
> mahesh@linux.vnet.ibm.com; ccross@android.com
> Subject: RE: [RFC PATCH v2 04/11] pstore: Add compression support to pstore
> 
> <1>[  383.209057] RIP  [<ffffffff813d3946>] sysrq_handle_crash+0x16/0x20
> <4>[  383.209057]  RSP <ffff88006f551e80>
> <4>[  383.209057] CR2: 0000000000000000
> <4>[  383.209057] ---[ end trace 04a1cddad37b4b33 ]---
> <3>[  383.209057] pstore: compression failed for Part 2 returned -5
> <3>[  383.209057] pstore: Capture uncompressed oops/panic report of Part 2
> <3>[  383.209057] pstore: compression failed for Part 5 returned -5
> 
> Interesting.  With ERST backend I didn't see these messages.  Traces in
> pstore recovered files go as far as the line before the "---[ end trace 04a1cddad37b4b33 ]---"
> 
> Why the difference depending on which back end is in use?

I think the difference doesn't depend on the back end.
Rather it depends on the environment.

I tested on a kvm guest with OVMF.

Seiji


> 
> But I agree that we shouldn't have these messages.  They use up space
> in the persistent store that could be better used saving some more lines
> from earlier in the console log.
> 
> -Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

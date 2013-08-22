Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136Ab3HVXEn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 19:04:43 -0400
Received: from usindpps04.hds.com ([207.126.252.17]:39295 "EHLO
	usindpps04.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068Ab3HVXEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 19:04:41 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>,
        "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "keescook@chromium.org" <keescook@chromium.org>
CC: "jkenisto@linux.vnet.ibm.com" <jkenisto@linux.vnet.ibm.com>,
        "ananth@in.ibm.com" <ananth@in.ibm.com>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "cbouatmailru@gmail.com" <cbouatmailru@gmail.com>,
        "mahesh@linux.vnet.ibm.com" <mahesh@linux.vnet.ibm.com>,
        "ccross@android.com" <ccross@android.com>
Subject: RE: [RFC PATCH v2 06/11] pstore: Add decompression support to pstore
Thread-Topic: [RFC PATCH v2 06/11] pstore: Add decompression support to
 pstore
Thread-Index: AQHOmoNxQimmUonsVk6v6r9hmA2ZHJmh2H5Q
Date: Thu, 22 Aug 2013 23:04:11 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D443E8F0B8@USINDEM103.corp.hds.com>
References: <20130816131403.3338.82330.stgit@aruna-ThinkPad-T420>
 <20130816131821.3338.27923.stgit@aruna-ThinkPad-T420>
In-Reply-To: <20130816131821.3338.27923.stgit@aruna-ThinkPad-T420>
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
 scancount=1 engine=7.0.1-1305240000 definitions=main-1308220171
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r7MN4m8g002200



> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Aruna Balakrishnaiah
> Sent: Friday, August 16, 2013 9:18 AM
> To: linuxppc-dev@ozlabs.org; tony.luck@intel.com; linux-kernel@vger.kernel.org; keescook@chromium.org
> Cc: jkenisto@linux.vnet.ibm.com; ananth@in.ibm.com; benh@kernel.crashing.org; cbouatmailru@gmail.com;
> mahesh@linux.vnet.ibm.com; ccross@android.com
> Subject: [RFC PATCH v2 06/11] pstore: Add decompression support to pstore
> 
> Based on the flag 'compressed' set or not, pstore will decompress the
> data returning a plain text file. If decompression fails for a particular
> record it will have the compressed data in the file which can be
> decompressed with 'openssl' command line tool.

If the decompression fails and openssl doesn't work, the worst case is that users can't read the entry.
In that case, pstore is meaningless at all.

Also, for users who want to get a single panic message, a compression is not needed.

So, I think we still have to support non-compression mode.
(IMO, pstore can take kdump as a model. Kdump supports both compression and non-compression mode.)

But, if you think my comment is outside this patchset, it's OK.
We can make it with a separate patch.

Seiji
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

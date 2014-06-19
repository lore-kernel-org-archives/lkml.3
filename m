Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966315AbaFSXnE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 19:43:04 -0400
Received: from mga11.intel.com ([192.55.52.93]:5841 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965771AbaFSXnC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 19:43:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,510,1400050800"; 
   d="scan'208";a="558242525"
From: "Luck, Tony" <tony.luck@intel.com>
To: Liu hua <sdu.liu@huawei.com>, "anton@enomsg.org" <anton@enomsg.org>,
        "ccross@android.com" <ccross@android.com>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Wang Nan <wangnan0@huawei.com>,
        "peifeiyue@huawei.com" <peifeiyue@huawei.com>
Subject: RE: Should Pstore(ramoops) records customized information?
Thread-Topic: Should Pstore(ramoops) records customized information?
Thread-Index: AQHPit0xXiBMDXiyt0+2L787Aem+Tpt3IwvAgAGugYCAAEbPsA==
Date: Thu, 19 Jun 2014 23:42:56 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F3283A5E3@ORSMSX114.amr.corp.intel.com>
References: <539E6D4D.5000802@huawei.com> <53A164DB.1020305@huawei.com>
 <3908561D78D1C84285E8C5FCA982C28F32838E10@ORSMSX114.amr.corp.intel.com>
 <53A2D5BB.5040500@huawei.com>
In-Reply-To: <53A2D5BB.5040500@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s5JNh9vX030073

> BTW, I note that "extern struct pstore_info *psinfo" locates in
> fs/pstore/internal.h. So users out of directory "fs/pstore/" can not use pstore to
> record messages. We do not want other kernel users to use pstore, right?  And can we
> break this?

Yes we can make some interface visible to the rest of the kernel ... probably
not the raw "*psinfo" though. Perhaps the pstore_alloc_ring_buffer() and
pstore_write_ring_buffer() functions should be the ones exported to the
rest of the kernel.

> ditoo.. Since other backends like efi and erst may can not privide such ring buffer.
> So pstore_alloc_ring_buffer should be a funciton pointer of pstore_info struct.

Yes - that allows less capable backend like ERST and efivars to not provide the
service.  Since it becomes internal, you can drop the "pstore_" prefix.  E.g.
something like:

int pstore_alloc_ring_buffer(char *name, int size)
{
	return psinfo->alloc_ring_buffer(name, size);
}
EXPORT_SYMBOL_GPL(pstore_alloc_ring_buffer);

... and you have to find/make some global header for the "extern" declaration.

-Tony


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

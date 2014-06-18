Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009AbaFRRus (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 13:50:48 -0400
Received: from mga02.intel.com ([134.134.136.20]:30178 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752429AbaFRRur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 13:50:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,501,1400050800"; 
   d="scan'208";a="530569162"
From: "Luck, Tony" <tony.luck@intel.com>
To: Liu hua <sdu.liu@huawei.com>, "anton@enomsg.org" <anton@enomsg.org>,
        "ccross@android.com" <ccross@android.com>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Wang Nan <wangnan0@huawei.com>,
        "peifeiyue@huawei.com" <peifeiyue@huawei.com>
Subject: RE: Should Pstore(ramoops) records customized information?
Thread-Topic: Should Pstore(ramoops) records customized information?
Thread-Index: AQHPit0xXiBMDXiyt0+2L787Aem+Tpt3IwvA
Date: Wed, 18 Jun 2014 17:50:45 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F32838E10@ORSMSX114.amr.corp.intel.com>
References: <539E6D4D.5000802@huawei.com> <53A164DB.1020305@huawei.com>
In-Reply-To: <53A164DB.1020305@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s5IHor9I020447

> (1) The backend (ramoops) provides servel memory regions staticly. Each region
>  is a ring buffer, which does not connect with certain PSTORE_TYPE_ID. So no one
>  can modify or use it before allocation.
>
> (2) A pstore user allocs a memory region, pstore will return a pstore_type_id.
>
>        pstore_type_id = alloc_pstroe_region()
>
> (3) This user record certain message to this region.
>
>        psinfo->write(pstore_type_id, ...)

Don't you need to match up the number of back-end ring buffer regions
with the number of users in the kernel that call alloc_pstore_region()?

Or do you envision that the backend can create these regions on demand?

Would different users need different sized regions? I think logging of
console messages might be able to work with a smaller ring buffer
than the ftrace logger. So perhaps we need a "size" argument when allocating?

Since these "regions" are in fact "ring buffers", the name of the allocation
routine should make that clear.  So call it "pstore_alloc_ring_buffer()"

After the system hangs/crashes ... how would you like pstore to
name these objects in /sys/fs/pstore/ for applications to pick them
up for analysis?  Maybe pstore_alloc_ring_buffer() needs a "char *name"
argument as well as a size?

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

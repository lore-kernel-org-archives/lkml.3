Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752021Ab3KDBGJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 20:06:09 -0500
Received: from mga01.intel.com ([192.55.52.88]:45349 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751226Ab3KDBGH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 20:06:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,628,1378882800"; 
   d="scan'208";a="427373420"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: "Wang, Xiaoming" <xiaoming.wang@intel.com>,
        "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        "cw00.choi@samsung.com" <cw00.choi@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "Zhang, Dongxing" <dongxing.zhang@intel.com>
Subject: RE: [PATCH] [extcon]:remove freed groups caused the panic or
 warning in unregister flow
Thread-Topic: [PATCH] [extcon]:remove freed groups caused the panic or
 warning in unregister flow
Thread-Index: AQHO1t8UTcP4Wb4mP0iVjPvLliUUEpoURcug
Date: Mon, 4 Nov 2013 01:06:01 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A01B8036B@SHSMSX101.ccr.corp.intel.com>
References: <1383346094.2702.16.camel@wxm-ubuntu>
In-Reply-To: <1383346094.2702.16.camel@wxm-ubuntu>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rA416JCv008768



> -----Original Message-----
> From: Wang, Xiaoming
> Sent: Saturday, November 02, 2013 6:48 AM
> To: myungjoo.ham@samsung.com; cw00.choi@samsung.com;
> linux-kernel@vger.kernel.org
> Cc: Liu, Chuansheng; Zhang, Dongxing; Wang, Xiaoming
> Subject: [PATCH] [extcon]:remove freed groups caused the panic or warning in
> unregister flow
> 
> (edev->extcon_dev_type.groups) has been freed before device_unregister.
> extcon_dev_unregister -> kfree(edev->extcon_dev_type.groups)
> then device_unregister -> device_del -> device_remove_attrs
> -> device_remove_groups(dev, type->groups);
> panic because type->groups has been freed.
> 
This patch fix the panic that using the freed memory.

Tested-by: Liu, Chuansheng <chuansheng.liu@intel.com>
Reviewed-by: Liu, Chuansheng <chuansheng.liu@intel.com>


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

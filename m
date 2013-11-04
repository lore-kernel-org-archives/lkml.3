Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609Ab3KDDrs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 22:47:48 -0500
Received: from mga09.intel.com ([134.134.136.24]:51819 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751556Ab3KDDrs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 22:47:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="429275711"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Chanwoo Choi <cw00.choi@samsung.com>,
        "Wang, Xiaoming" <xiaoming.wang@intel.com>
CC: "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Zhang, Dongxing" <dongxing.zhang@intel.com>
Subject: RE: [PATCH] [extcon]:remove freed groups caused the panic or
 warning in unregister flow
Thread-Topic: [PATCH] [extcon]:remove freed groups caused the panic or
 warning in unregister flow
Thread-Index: AQHO2Qa/FC79w5BC9EuJcTvsrXRjPJoUbjFg
Date: Mon, 4 Nov 2013 03:47:39 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A01B806F5@SHSMSX101.ccr.corp.intel.com>
References: <1383346094.2702.16.camel@wxm-ubuntu>
 <5276FBB5.1020506@samsung.com>
 <FA47D36D6EC9FE4CB463299737C09B9901B6467C@SHSMSX102.ccr.corp.intel.com>
 <52770837.5000901@samsung.com>
In-Reply-To: <52770837.5000901@samsung.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rA43ltvb009224



> -----Original Message-----
> From: Chanwoo Choi [mailto:cw00.choi@samsung.com]
> Sent: Monday, November 04, 2013 10:37 AM
> To: Wang, Xiaoming
> Cc: myungjoo.ham@samsung.com; linux-kernel@vger.kernel.org; Liu,
> Chuansheng; Zhang, Dongxing
> Subject: Re: [PATCH] [extcon]:remove freed groups caused the panic or warning
> in unregister flow


> As you comment, my opinion has memory leak problem. My mistake.
> But, I prefer to call 'device_unregister' at the end of extcon_dev_unregister().
> To resolve kernel panic, I think we could use 'devm_kzalloc' instead of
> kzalloc/kfree.
> What is your opinion about my approach?
> 
That sounds good.
But in function extcon_dev_register(), the device attributes are allocated before device_register(),
and before device_register(), the function devm_kzalloc() can not be used.


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933343Ab3GQSH1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 14:07:27 -0400
Received: from mga14.intel.com ([143.182.124.37]:62710 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932160Ab3GQSHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 14:07:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,686,1367996400"; 
   d="scan'208";a="269625896"
From: "Hefty, Sean" <sean.hefty@intel.com>
To: Paul Bolle <pebolle@tiscali.nl>, Roland Dreier <roland@kernel.org>,
        "Hal Rosenstock" <hal.rosenstock@gmail.com>
CC: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] RDMA/cma: silence GCC warning
Thread-Topic: [PATCH v2] RDMA/cma: silence GCC warning
Thread-Index: AQHOgslwu4T8fMVfOUWFnu6cSwwiSZlpJv8A
Date: Wed, 17 Jul 2013 18:07:17 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373805B8318@ORSMSX109.amr.corp.intel.com>
References: <1373886239.2591.26.camel@x61.thuisdomein>
	 <1828884A29C6694DAF28B7E6B8A82373805A65C0@ORSMSX110.amr.corp.intel.com>
 <1374050453.26384.41.camel@x61.thuisdomein>
In-Reply-To: <1374050453.26384.41.camel@x61.thuisdomein>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r6HI7YLl028918

> Building cma.o triggers this GCC warning:
>     drivers/infiniband/core/cma.c: In function â€˜rdma_resolve_addrâ€™:
>     drivers/infiniband/core/cma.c:465:23: warning: â€˜portâ€™ may be used
> uninitialized in this function [-Wmaybe-uninitialized]
>     drivers/infiniband/core/cma.c:426:5: note: â€˜portâ€™ was declared here
> 
> This is a false positive, as "port" will always be initialized if we're
> at "found". But if we assign to "id_priv->id.port_num" directly, we can
> drop "port". That will, obviously, silence GCC.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Acked-by: Sean Hefty <sean.hefty@intel.com>

> ---
> 0) v2: assign to "id_priv->id.port_num" directly, instead of
> initializing "port" to 0, as discussed with Sean.
> 
> 1) Still only compile tested.

tested - thanks
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

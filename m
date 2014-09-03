Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932365AbaICJ6I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 05:58:08 -0400
Received: from cnbjrel02.sonyericsson.com ([219.141.167.166]:4762 "EHLO
	cnbjrel02.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932347AbaICJ6E convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 05:58:04 -0400
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
To: "'linux@arm.linux.org.uk'" <linux@arm.linux.org.uk>,
        "'santosh.shilimkar@ti.com'" <santosh.shilimkar@ti.com>,
        "'grant.likely@linaro.org'" <grant.likely@linaro.org>,
        "'robh@kernel.org'" <robh@kernel.org>,
        "'akpm@linux-foundation.org'" <akpm@linux-foundation.org>,
        "'m.szyprowski@samsung.com'" <m.szyprowski@samsung.com>,
        "'lauraa@codeaurora.org'" <lauraa@codeaurora.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'m.szyprowski@samsung.com'" <m.szyprowski@samsung.com>,
        "'akpm@linux-foundation.org'" <akpm@linux-foundation.org>,
        "'iamjoonsoo.kim@lge.com'" <iamjoonsoo.kim@lge.com>,
        "'mina86@mina86.com'" <mina86@mina86.com>,
        "'aneesh.kumar@linux.vnet.ibm.com'" <aneesh.kumar@linux.vnet.ibm.com>,
        "'lauraa@codeaurora.org'" <lauraa@codeaurora.org>,
        "'gioh.kim@lge.com'" <gioh.kim@lge.com>,
        "'michael.opdenacker@free-electrons.com'" 
	<michael.opdenacker@free-electrons.com>,
        "'akinobu.mita@gmail.com'" <akinobu.mita@gmail.com>,
        "'linux-mm@kvack.org'" <linux-mm@kvack.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Date: Wed, 3 Sep 2014 17:57:57 +0800
Subject: free initrd / cma pages problems with memblock
Thread-Topic: free initrd / cma pages problems with memblock
Thread-Index: Ac/HXYoIBMd4ncK5R8G5Q+V4maVpeA==
Message-ID: <35FD53F367049845BC99AC72306C23D103CDBFBFB00B@CNBJMBX05.corpusers.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi 


I found the freed reserved memory by free_initrd_mem( ) and  cma_activate_area( )
Are still marked as reserved in /sys/kernel/debug/memblock/reserved .

I think This is not correct and not suitable for memory debug,
Why not also call memblock_free during these functions?
So that /sys/kernel/debug/memblock/reserved only mark really reserved memory as reserved .




Thanks.


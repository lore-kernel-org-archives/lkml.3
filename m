Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110AbaLSHzF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 02:55:05 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:59312 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbaLSHzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 02:55:03 -0500
X-Original-SENDERIP: 10.186.123.76
X-Original-MAILFROM: gioh.kim@lge.com
Message-ID: <5493D9CE.5040001@lge.com>
Date: Fri, 19 Dec 2014 16:54:54 +0900
From: Gioh Kim <gioh.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        =?EUC-KR?B?wMywx8ij?= <gunho.lee@lge.com>,
        Minchan Kim <minchan@kernel.org>,
        =?EUC-KR?B?J7Howdg=?= =?EUC-KR?B?vPYn?= <iamjoonsoo.kim@lge.com>
Subject: [RFC] background zero-set page for device
Content-Type: text/plain; charset=euc-kr
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There was some discussion to create zero-set pages in background like this:
https://lkml.org/lkml/2004/10/30/73

I'm understand that it is not good for performance.

But I think it can help for a device in my platform.
I'm sorry I can't tell what it is.
But the device needs many zero-set pages, up to several MB,
so that device driver has a loop to calls alloc_page, memset(p, 0, PAGE_SIZE) and cache flush&invalidate.
And the device uses the pages and returns it to kernel. Kernel reads data in the page.

In this case, memset(0) must be done.
I think, if memset(0) is done at idle time, it can remove memset calling of ddk.

Is there any device that needs many zero-set pages?
Can backgound zero-setting page be good for the device?

-- 
Thanks,
Gioh Kim

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758213Ab3BMALg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 19:11:36 -0500
Received: from mail-ve0-f172.google.com ([209.85.128.172]:64342 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968Ab3BMALe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 19:11:34 -0500
MIME-Version: 1.0
In-Reply-To: <5113450C.1080109@huawei.com>
References: <51074786.5030007@huawei.com>
	<1359995565.7515.178.camel@mfleming-mobl1.ger.corp.intel.com>
	<51131248.3080203@huawei.com>
	<5113450C.1080109@huawei.com>
Date: Tue, 12 Feb 2013 16:11:33 -0800
Message-ID: <CA+8MBb+3_xWv1wMWv0+gwWm9exPCNTZWG3mXQnBsUbc5fJnuiA@mail.gmail.com>
Subject: Re: [PATCH V3] ia64/mm: fix a bad_page bug when crash kernel booting
From: Tony Luck <tony.luck@gmail.com>
To: Xishi Qiu <qiuxishi@huawei.com>
Cc: Matt Fleming <matt.fleming@intel.com>, fenghua.yu@intel.com,
        Liujiang <jiang.liu@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-mm@kvack.org, Hanjun Guo <guohanjun@huawei.com>,
        WuJianguo <wujianguo@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Building linux-next today (tag next-20130212) I get the following errors when
building arch/ia64/configs/{tiger_defconfig, zx1_defconfig, bigsur_defconfig,
sim_defconfig}

arch/ia64/mm/init.c: In function 'free_initrd_mem':
arch/ia64/mm/init.c:215: error: 'max_addr' undeclared (first use in
this function)
arch/ia64/mm/init.c:215: error: (Each undeclared identifier is
reported only once
arch/ia64/mm/init.c:215: error: for each function it appears in.)
arch/ia64/mm/init.c:216: error: implicit declaration of function
'GRANULEROUNDDOWN'

with "git blame" saying that these lines in init.c were added/changed by

commit 5a54b4fb8f554b15c6113e30ca8412b7fe11c62e
Author: Xishi Qiu <qiuxishi@huawei.com>
Date:   Thu Feb 7 12:25:59 2013 +1100

    ia64/mm: fix a bad_page bug when crash kernel booting

-Tony

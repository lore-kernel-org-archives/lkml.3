Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759402Ab3BMAW0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 19:22:26 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55328 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754460Ab3BMAWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 19:22:24 -0500
Date: Tue, 12 Feb 2013 16:22:22 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tony Luck <tony.luck@gmail.com>
Cc: Xishi Qiu <qiuxishi@huawei.com>, Matt Fleming <matt.fleming@intel.com>,
        fenghua.yu@intel.com, Liujiang <jiang.liu@huawei.com>,
        linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org, linux-mm@kvack.org,
        Hanjun Guo <guohanjun@huawei.com>, WuJianguo <wujianguo@huawei.com>
Subject: Re: [PATCH V3] ia64/mm: fix a bad_page bug when crash kernel
 booting
Message-Id: <20130212162222.e4103ddb.akpm@linux-foundation.org>
In-Reply-To: <CA+8MBb+3_xWv1wMWv0+gwWm9exPCNTZWG3mXQnBsUbc5fJnuiA@mail.gmail.com>
References: <51074786.5030007@huawei.com>
	<1359995565.7515.178.camel@mfleming-mobl1.ger.corp.intel.com>
	<51131248.3080203@huawei.com>
	<5113450C.1080109@huawei.com>
	<CA+8MBb+3_xWv1wMWv0+gwWm9exPCNTZWG3mXQnBsUbc5fJnuiA@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Feb 2013 16:11:33 -0800
Tony Luck <tony.luck@gmail.com> wrote:

> Building linux-next today (tag next-20130212) I get the following errors when
> building arch/ia64/configs/{tiger_defconfig, zx1_defconfig, bigsur_defconfig,
> sim_defconfig}
> 
> arch/ia64/mm/init.c: In function 'free_initrd_mem':
> arch/ia64/mm/init.c:215: error: 'max_addr' undeclared (first use in
> this function)
> arch/ia64/mm/init.c:215: error: (Each undeclared identifier is
> reported only once
> arch/ia64/mm/init.c:215: error: for each function it appears in.)
> arch/ia64/mm/init.c:216: error: implicit declaration of function
> 'GRANULEROUNDDOWN'
> 

`max_addr' is an awesomely bad name for a global identifier, btw.

And this:

-static u64 mem_limit = ~0UL, max_addr = ~0UL, min_addr = 0UL;
+u64 mem_limit = ~0UL, max_addr = ~0UL, min_addr = 0UL;

needlessly exported `mem_limit' and `min_addr' as well.  These too are
very poor global identifiers.

Also, Matt suggested an alternative implementation which afaik hasn't
been responded to.


I think I'll just drop the patch.

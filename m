Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752284AbaAQSJI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 13:09:08 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:39415 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752225AbaAQSJB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 13:09:01 -0500
From: "Strashko, Grygorii" <grygorii.strashko@ti.com>
To: Philipp Hachtmann <phacht@linux.vnet.ibm.com>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "qiuxishi@huawei.com" <qiuxishi@huawei.com>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "daeseok.youn@gmail.com" <daeseok.youn@gmail.com>,
        "liuj97@gmail.com" <liuj97@gmail.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "zhangyanfei@cn.fujitsu.com" <zhangyanfei@cn.fujitsu.com>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        "tangchen@cn.fujitsu.com" <tangchen@cn.fujitsu.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH V3 2/2] mm/memblock: Add support for excluded memory
 areas
Thread-Topic: [PATCH V3 2/2] mm/memblock: Add support for excluded memory
 areas
Thread-Index: AQHPEVnDyj/4xy35V0GkAeLJ+6JixJqJNgfd
Date: Fri, 17 Jan 2014 18:08:13 +0000
Message-ID: <902E09E6452B0E43903E4F2D568737AB0B9852BA@DFRE01.ent.ti.com>
References: <1389618217-48166-1-git-send-email-phacht@linux.vnet.ibm.com>
	<1389618217-48166-3-git-send-email-phacht@linux.vnet.ibm.com>
	<52D538FD.8010907@ti.com>,<20140114195225.078f810a@lilie>
In-Reply-To: <20140114195225.078f810a@lilie>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.167.188.43]
x-exclaimer-md-config: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Philipp,

On 01/14/2014 08:52 PM, Philipp Hachtmann wrote:
> Hello Grygorii,
> 
> thank you for your comments.
> 
> To clarify we have the following requirements for memblock:
> 
> (1) Reserved areas can be declared before memory is added.
> (2) The physical memory is detected once only.
> (3) The free memory (i.e. not reserved) memory can be iterated to add
> it to the buddy allocator.
> (4) Memory designated to be mapped into the kernel address space can be
> iterated.
> (5) Kdump on s390 requires knowledge about the full system memory
> layout.
> 
> The s390 kdump implementation works a bit different from the
> implementation on other architectures: The layout is not taken from the
> production system and saved for the kdump kernel. Instead the kdump
> kernel needs to gather information about the whole memory without
> respect to locked out areas (like mem= and OLDMEM etc.).
> 
> Without kdump's requirement it would of course be suitable and easy
> just to remove memory from memblock.memory. But then this information
> is lost for later use by kdump.
> 
> The patch does not change any behaviour of the current API - whether it
> is enabled or not.

Sorry, for the delayed reply.

My main concern here was that you are introducing new *generic* API,
but in fact it is not generic, because it can't be re-used without huge rework
of existing code.
(at least as of wide usage of for_each_memblock(memory,...),
because (if ARCH_MEMBLOCK_NOMAP=y) the meaning of "memory"
ranges will be changed form "mapped memory" to "real phys memory").

And therefore, I've proposed to keep things as is and introduce phys_memory
ranges instead, to store real phys memory configuration.

> 
> The current patch seems to be overly complicated.
> The following patch contains only the nomap functionality without any
> cleanup and refactoring. I will post a V4 patch set which will contain
> this patch.

Regards,
-grygorii

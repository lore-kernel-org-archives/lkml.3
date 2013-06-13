Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932360Ab3FMB67 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 21:58:59 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:54825 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756951Ab3FMB66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 21:58:58 -0400
Date: Thu, 13 Jun 2013 09:58:27 +0800
From: Wang YanQing <udknight@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Tang Chen <tangchen@cn.fujitsu.com>, Tejun Heo <tj@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH]memblock: Fix potential section mismatch problem
Message-ID: <20130613015827.GA2667@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>,
	Yinghai Lu <yinghai@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Wanpeng Li <liwanp@linux.vnet.ibm.com>,
	Tang Chen <tangchen@cn.fujitsu.com>, Tejun Heo <tj@kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux MM <linux-mm@kvack.org>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	David Miller <davem@davemloft.net>, Sam Ravnborg <sam@ravnborg.org>
References: <20130612160816.GA13813@udknight>
 <CAE9FiQUTwwRUuFicCFvdZZ1_9ytkaexK939zKmYyM31BMaiuZw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQUTwwRUuFicCFvdZZ1_9ytkaexK939zKmYyM31BMaiuZw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 12, 2013 at 10:29:17AM -0700, Yinghai Lu wrote:
> On Wed, Jun 12, 2013 at 9:08 AM, Wang YanQing <udknight@gmail.com> wrote:
> >
> > This patch convert __init to __init_memblock
> > for functions which make reference to memblock variable
> > with attribute __meminitdata.
> 
> for which arch?

I just think different arch could have different
meaning about __init and __init_memblock, but
if a function call another function with __init_memblock
annotation or has reference to variable with  __initdata_memblock,
then we have better to give it __init_memblock annotation.


> for x86: __init_memblock is __init, so that is not problem.

Thanks for point out this, then I know why I haven't get
compile warning.

> for other arches like powerpc and sparc etc, __init_memblock is " "
> 
> so you need cc  powerpc, and sparc ...

My first motivation to propose this patch was I found below 
two functions have different annotation which I think they 
should have the same annotation:

"
int __init memblock_is_reserved(phys_addr_t addr)
{
        return memblock_search(&memblock.reserved, addr) != -1;
}

int __init_memblock memblock_is_memory(phys_addr_t addr)
{
        return memblock_search(&memblock.memory, addr) != -1;
}
"


Thanks

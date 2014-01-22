Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845AbaAVUlK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 15:41:10 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55445 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788AbaAVUlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 15:41:08 -0500
Date: Wed, 22 Jan 2014 12:41:07 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Philipp Hachtmann <phacht@linux.vnet.ibm.com>
Cc: hannes@cmpxchg.org, liuj97@gmail.com, santosh.shilimkar@ti.com,
        grygorii.strashko@ti.com, iamjoonsoo.kim@lge.com,
        robin.m.holt@gmail.com, tangchen@cn.fujitsu.com, yinghai@kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V5 2/3] mm/memblock: Add support for excluded memory
 areas
Message-Id: <20140122124107.ef0ceac16be17c165de56308@linux-foundation.org>
In-Reply-To: <20140122121821.6da53a02@lilie>
References: <1390217559-14691-1-git-send-email-phacht@linux.vnet.ibm.com>
	<1390217559-14691-3-git-send-email-phacht@linux.vnet.ibm.com>
	<20140122121821.6da53a02@lilie>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jan 2014 12:18:21 +0100 Philipp Hachtmann <phacht@linux.vnet.ibm.com> wrote:

> Hi again,
> 
> I'd like to remind that the s390 development relies on this patch
> (and the next one, for cleanliness, of course) being added. It would be
> very good to see it being added to the -mm tree resp. linux-next.
> 

Once the patch has passed review (hopefully by yinghai, who reviews
very well) I'd ask you to include it in the s390 tree which actually
uses it.

Patch 2/3 would benefit from a more complete changelog.  Why does s390
need CONFIG_ARCH_MEMBLOCK_NOMAP?  How is it used and how does it work? 
Do we expect other architectures to use it?  If so, how?  etcetera.

btw, you have a "#ifdef ARCH_MEMBLOCK_NOMAP" in there which should be
CONFIG_ARCH_MEMBLOCK_NOMAP.  I don't see how the code could have
compiled as-is - __next_mapped_mem_range() will be omitted?


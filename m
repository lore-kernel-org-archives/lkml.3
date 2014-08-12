Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382AbaHLWDI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 18:03:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50589 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540AbaHLWDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 18:03:06 -0400
Date: Tue, 12 Aug 2014 15:03:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: <santosh.shilimkar@ti.com>, <grygorii.strashko@ti.com>,
        <phacht@linux.vnet.ibm.com>, <yinghai@kernel.org>, <fabf@skynet.be>,
        <Emilian.Medve@freescale.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] memblock, memhotplug: Fix wrong type in
 memblock_find_in_range_node().
Message-Id: <20140812150304.74a7da3f2491f3d8f8a30107@linux-foundation.org>
In-Reply-To: <1407651123-10994-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1407651123-10994-1-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Aug 2014 14:12:03 +0800 Tang Chen <tangchen@cn.fujitsu.com> wrote:

> In memblock_find_in_range_node(), we defeind ret as int. But it shoule
> be phys_addr_t because it is used to store the return value from
> __memblock_find_range_bottom_up().
> 
> The bug has not been triggered because when allocating low memory near
> the kernel end, the "int ret" won't turn out to be minus. When we started
> to allocate memory on other nodes, and the "int ret" could be minus.
> Then the kernel will panic.
> 
> A simple way to reproduce this: comment out the following code in numa_init(),
> 
>         memblock_set_bottom_up(false);
> 
> and the kernel won't boot.

Which kernel versions need this fix?

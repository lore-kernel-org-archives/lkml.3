Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187AbaI2Va0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 17:30:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41756 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbaI2VaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 17:30:25 -0400
Date: Mon, 29 Sep 2014 14:30:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: linux-next: build warning after merge of the akpm-current tree
Message-Id: <20140929143024.55ef9b2c3b6bf54d7d6e1758@linux-foundation.org>
In-Reply-To: <20140926204200.3e2175cc@canb.auug.org.au>
References: <20140926204200.3e2175cc@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Sep 2014 20:42:00 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Andrew,
> 
> After merging the akpm tree, today's linux-next build (powerpc
> ppc64_defconfig) produced this warning:
> 
> drivers/of/of_reserved_mem.c: In function 'of_reserved_mem_device_init':
> drivers/of/of_reserved_mem.c:253:3: warning: 'return' with no value, in function returning non-void [-Wreturn-type]
>    return;
>    ^
> drivers/of/of_reserved_mem.c:259:3: warning: 'return' with no value, in function returning non-void [-Wreturn-type]
>    return;
>    ^
> 
> Caused by commit 1a29544cc8c9 ("drivers: of: add return value to
> of_reserved_mem_device_init").  This patch changed the return type of a
> function but did not update any or the return statements in that
> function.

OK, thanks, I dropped it.  I could have fixed it but it doesn't appear
to be well tested.


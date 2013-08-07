Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933424Ab3HGV0u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 17:26:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40123 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933289Ab3HGV0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 17:26:48 -0400
Date: Wed, 7 Aug 2013 14:26:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ed Cashin <ecashin@coraid.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] aoe: adjust ref of head for compound page tails
Message-Id: <20130807142647.6614d3ec88a7af12cba4505a@linux-foundation.org>
In-Reply-To: <EB4C2185-3868-42A3-A88D-F9642962D336@coraid.com>
References: <cover.1375320764.git.ecashin@coraid.com>
	<0c8aff39249c1da6b9cc3356650149d065c3ebd2.1375320764.git.ecashin@coraid.com>
	<20130807140021.57a40fb31807f16b525f6ff3@linux-foundation.org>
	<EB4C2185-3868-42A3-A88D-F9642962D336@coraid.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Aug 2013 17:21:32 -0400 Ed Cashin <ecashin@coraid.com> wrote:

> > What are the end-user-visible effects of the problem which is being
> > fixed?  Please always include this info when fixing bugs so that others
> > can work out what kernel version(s) need the patch.
> 
> 
> Sorry.  I tried to cover that but maybe should have separated it more clearly from the running text.
> 
> The patch changes the current behavior encountered with direct I/O and aoe:
> 
>   aoe can BUG when direct I/O used
> 
> ... to a new behavior:
> 
>   aoe does not BUG when direct I/O is used
> 
> And the user will never know that instead aoe is manipulating the _count of the head page, even though that's what's happening with this patch applied.
> 
> (The user-visible effects that motivated the older patch that added the BUG to aoe when page tails are used for block I/O was a VM_BUG_ON that occurred when the aoe driver manipulated the _count of a compound page tail.)

OK, I added "Fix a BUG which can trigger when direct-IO is used with
AOE".  Which kernel versions are affected?


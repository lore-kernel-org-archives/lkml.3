Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933286Ab3HGVAY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 17:00:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39980 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932387Ab3HGVAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 17:00:22 -0400
Date: Wed, 7 Aug 2013 14:00:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ed Cashin <ecashin@coraid.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] aoe: adjust ref of head for compound page tails
Message-Id: <20130807140021.57a40fb31807f16b525f6ff3@linux-foundation.org>
In-Reply-To: <0c8aff39249c1da6b9cc3356650149d065c3ebd2.1375320764.git.ecashin@coraid.com>
References: <cover.1375320764.git.ecashin@coraid.com>
	<0c8aff39249c1da6b9cc3356650149d065c3ebd2.1375320764.git.ecashin@coraid.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Aug 2013 21:29:59 -0400 Ed Cashin <ecashin@coraid.com> wrote:

> As discussed previously, the fact that some users of the block
> layer provide bios that point to pages with a zero _count means
> that it is not OK for the network layer to do a put_page on the
> skb frags during an skb_linearize, so the aoe driver gets a
> reference to pages in bios and puts the reference before ending
> the bio.  And because it cannot use get_page on a page with a
> zero _count, it manipulates the value directly.
> 
> It is not OK to increment the _count of a compound page tail,
> though, since the VM layer will VM_BUG_ON a non-zero _count.
> Block users that do direct I/O can result in the aoe driver
> seeing compound page tails in bios.  In that case, the same logic
> works as long as the head of the compound page is used instead of
> the tails.  This patch handles compound pages and does not BUG.
> 
> It relies on the block layer user leaving the relationship
> between the page tail and its head alone for the duration between
> the submission of the bio and its completion, whether successful
> or not.

What are the end-user-visible effects of the problem which is being
fixed?  Please always include this info when fixing bugs so that others
can work out what kernel version(s) need the patch.



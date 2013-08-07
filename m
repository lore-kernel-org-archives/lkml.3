Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933271Ab3HGU6H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 16:58:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39976 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932387Ab3HGU6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 16:58:05 -0400
Date: Wed, 7 Aug 2013 13:58:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ed Cashin <ecashin@coraid.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] aoe: adjust ref of head for compound page tails
Message-Id: <20130807135804.e62b75f6986e9568ab787562@linux-foundation.org>
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

> As discussed previously,

I think I missed that.

> the fact that some users of the block
> layer provide bios that point to pages with a zero _count means
> that it is not OK for the network layer to do a put_page on the
> skb frags during an skb_linearize, so the aoe driver gets a
> reference to pages in bios and puts the reference before ending
> the bio.  And because it cannot use get_page on a page with a
> zero _count, it manipulates the value directly.

Eh?  What code is putting count==0 pages into bios?  That sounds very
weird and broken.



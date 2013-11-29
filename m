Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229Ab3K2TyX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 14:54:23 -0500
Received: from one.firstfloor.org ([193.170.194.197]:38061 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994Ab3K2TyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 14:54:22 -0500
Date: Fri, 29 Nov 2013 20:54:19 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH] Add a text_poke syscall v2
Message-ID: <20131129195419.GB17656@two.firstfloor.org>
References: <1385426236-14960-1-git-send-email-andi@firstfloor.org>
 <20131129183558.GA9803@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131129183558.GA9803@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oleg,

Thanks for finding all these problems.

> We are going to change this user page, it seems that we need
> set_page_dirty() ?

That's true. Will add it next rev.

> 
> Andi, et al. I am going to discuss the things I do not really
> understand, probably this can't make any sense, but...

I think it's enough to set the dirty bit in the underlying
struct page, no need to play games with the PTE.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

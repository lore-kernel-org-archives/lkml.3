Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757860Ab3CGAQW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 19:16:22 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:49269 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753914Ab3CGAQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 19:16:21 -0500
Date: Wed, 6 Mar 2013 16:16:19 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Vineet.Gupta1@synopsys.com,
        liwanp@linux.vnet.ibm.com, mingo@kernel.org, tj@kernel.org,
        vgupta@synopsys.com
Subject: Re: + memblock-add-assertion-for-zero-allocation-alignment.patch
 added to -mm tree
Message-Id: <20130306161619.0b8e3674d91bc3b5f1927813@linux-foundation.org>
In-Reply-To: <CAE9FiQVAnR08U=ywUzk_4fkSh_mz6sZqtwWg02YzzF_cbN45rQ@mail.gmail.com>
References: <20130306224405.8160D5A4082@corp2gmr1-2.hot.corp.google.com>
	<CAE9FiQVAnR08U=ywUzk_4fkSh_mz6sZqtwWg02YzzF_cbN45rQ@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Mar 2013 16:07:20 -0800 Yinghai Lu <yinghai@kernel.org> wrote:

> > --- a/mm/memblock.c~memblock-add-assertion-for-zero-allocation-alignment
> > +++ a/mm/memblock.c
> > @@ -771,6 +771,9 @@ static phys_addr_t __init memblock_alloc
> >  {
> >         phys_addr_t found;
> >
> > +       if (WARN_ON(!align))
> > +               align = __alignof__(long long);
> > +
> >         /* align @size to avoid excessive fragmentation on reserved array */
> >         size = round_up(size, align);
> 
> Hi, Peter,
> 
> Do you agree that we should check align in round_up()?

As you don't describe your reasoning it is hard to say.

But no, I don't think so.  Checking for zero would add a pile of
basically useless code to the 100+ round_up() callsites, and
round_up(x, 0) is kinda meaningful, in a strange way.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976Ab3H2Oqe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 10:46:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47355 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754580Ab3H2Oqd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 10:46:33 -0400
Date: Thu, 29 Aug 2013 10:45:25 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Akira Hayakawa <ruby.wktk@gmail.com>
cc: Alasdair G Kergon <agk@redhat.com>, Greg KH <gregkh@linuxfoundation.org>,
        dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        kernelnewbies@kernelnewbies.org
Subject: Re: [dm-devel] [RFC] dm-lc: plan to go to staging
In-Reply-To: <20130829033023.GH4872@agk-dp.fab.redhat.com>
Message-ID: <alpine.LRH.2.02.1308291043410.20142@file01.intranet.prod.int.rdu2.redhat.com>
References: <521EA567.1070801@gmail.com> <20130829020555.GA26206@kroah.com> <20130829033023.GH4872@agk-dp.fab.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another idea:

Make the interface of dm-lc (the arguments to constructor, messages and 
the status line) the same as dm-cache, so that they can be driven by the 
same userspace code.

Mikulas


On Thu, 29 Aug 2013, Alasdair G Kergon wrote:

> On Wed, Aug 28, 2013 at 07:05:55PM -0700, Greg KH wrote:
> > For staging drivers, I need a TODO file that lists
> > what needs to be done to the code to get it into a mergable state for
> > the "real" part of the kernel,
> 
> Two simple requirements before putting your proof-of-concept into staging
> if you want to work that way:
> 
> 1) Drop the major version number to 0.  Version 1 is reserved for
> supported modules.
> 
> 2) Agree a new and meaningful target name with us so you don't have to
> change it later.  "lc" means nothing, I'm afraid.
> 
> Then in general terms, you should continue to compare your device-mapper
> target with the existing targets and where there are differences, either
> change your target to be like something that already exists, or be ready
> to explain why that can't or shouldn't be done.
> 
> In particular, the interface and architecture will need substantial
> changes and working these out should be your highest priority.
> 
> For example, you write:
> 
>   Be careful, you MUST create all the LVs as the destinations of
>   the dirty blocks on the cache device before this operation.  Otherwise,
>   the kernel may crash.
> 
> I read a statement like that as an indication of an interface or
> architectural problem.  The device-mapper approach is to 'design out'
> problems, rather than relying on users not doing bad things.
> Study the existing interfaces used by other targets to understand
> some approaches that proved successful, then decide which ones
> come closest to your needs.
> 
> (Your code also needs many more comments inline to explain what it does
> and how it works.)
> 
> The documentation file will eventually need rewriting to follow the same
> format as the other targets recently added to the kernel.  We document
> the kernel interface rather than any particular userspace tools, which
> just have the status of convenient examples.
> 
> Another little thing I noticed: look into using something like
> __dm_bless_for_disk() for your metadata and clearly segregate your
> on-disk structures and document the layout.
> 
> Alasdair
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
> 

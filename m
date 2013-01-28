Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757732Ab3A1SJe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 13:09:34 -0500
Received: from mail-qe0-f52.google.com ([209.85.128.52]:47076 "EHLO
	mail-qe0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626Ab3A1SJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 13:09:32 -0500
X-Greylist: delayed 305 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Jan 2013 13:09:32 EST
Date: Mon, 28 Jan 2013 13:04:24 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Will Deacon <will.deacon@arm.com>
cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Russell King <linux@arm.linux.org.uk>,
        "js1304@gmail.com" <js1304@gmail.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 0/3] introduce static_vm for ARM-specific static mapped
 area
In-Reply-To: <20130128175106.GI23470@mudshark.cambridge.arm.com>
Message-ID: <alpine.LFD.2.02.1301281300250.6300@xanadu.home>
References: <1358990934-4893-1-git-send-email-iamjoonsoo.kim@lge.com> <20130128175106.GI23470@mudshark.cambridge.arm.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jan 2013, Will Deacon wrote:

> Hello,
> 
> On Thu, Jan 24, 2013 at 01:28:51AM +0000, Joonsoo Kim wrote:
> > In current implementation, we used ARM-specific flag, that is,
> > VM_ARM_STATIC_MAPPING, for distinguishing ARM specific static mapped area.
> > The purpose of static mapped area is to re-use static mapped area when
> > entire physical address range of the ioremap request can be covered
> > by this area.
> > 
> > This implementation causes needless overhead for some cases.
> > For example, assume that there is only one static mapped area and
> > vmlist has 300 areas. Every time we call ioremap, we check 300 areas for
> > deciding whether it is matched or not. Moreover, even if there is
> > no static mapped area and vmlist has 300 areas, every time we call
> > ioremap, we check 300 areas in now.
> > 
> > If we construct a extra list for static mapped area, we can eliminate
> > above mentioned overhead.
> > With a extra list, if there is one static mapped area,
> > we just check only one area and proceed next operation quickly.
> > 
> > In fact, it is not a critical problem, because ioremap is not frequently
> > used. But reducing overhead is better idea.
> > 
> > Another reason for doing this work is for removing vm_struct list management,
> > entirely. For more information, look at the following link.
> > http://lkml.org/lkml/2012/12/6/184
> 
> First patch looks good (removing the unused vmregion stuff) but I'm not so
> sure about the rest of it. If you really care about ioremap performance,
> perhaps it would be better to have a container struct around the vm_struct
> for static mappings and then stick them in an augmented rbtree so you can
> efficiently find the mapping encompassing a particular physical address?

How can ioremap performance be a problem is the question I had since the 
beginning.

Firstly, ioremap is _not_ meant to be used in performance critical 
paths.

Secondly, there shouldn't be _that_ many entries on the vmlist such as 
300.  That sounds a bit excessive.

So please, can we discuss the reasons that motivated those patches in 
the first place?  Maybe that's where the actual problem is.


Nicolas

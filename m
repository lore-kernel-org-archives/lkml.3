Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178Ab3HJF5D (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 01:57:03 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:55934 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754117Ab3HJF5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 01:57:01 -0400
Message-ID: <1376114128.5332.17.camel@marge.simpson.net>
Subject: Re: Re-tune x86 uaccess code for PREEMPT_VOLUNTARY
From: Mike Galbraith <bitbucket@online.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, mingo@kernel.org, torvalds@linux-foundation.org
Date: Sat, 10 Aug 2013 07:55:28 +0200
In-Reply-To: <5205C4BB.6020003@zytor.com>
References: <1376089460-5459-1-git-send-email-andi@firstfloor.org>
	 <5205C4BB.6020003@zytor.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:uinwRAjPOuXniefbs2TcIcN6FU12gayUJf51HcaYaSI
 MTKgHiv8/ecNR0ClB1hvnrCNfSFEDeC26E4EkW5YSzVMFZyq6z
 Z0VxzT5LdNIr6HYHhb3/YioQRbUy8w8yKABZxGYqrp86n5XDdr
 MvBufjsupdlgIhvYdy9sGmSl58wZTkkMw2i+zT9wLFTyLF3POH
 S5Bpvp59TbGJTMkofprx4omSX4LOWDQhQm2ZL967D3oO2mAlq4
 HEh05DafA2VZeDmFBLwUoYWvIt40A5+dGy4b95CjDsBaIvjBHO
 aqdOh+pstERF3J0SDOO9BpgdH3yL2aHkncvSbRiaVLgMvdmLbk
 j+8usGwnxA7KVjrlXn9H0Ahgd2yrB0XEvkGh4EK3a8fWXRHjCD
 n2Jqzg9/h2apQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-08-09 at 21:42 -0700, H. Peter Anvin wrote: 
> On 08/09/2013 04:04 PM, Andi Kleen wrote:
> > 
> > This patch kit is an attempt to get us back to sane code, 
> > mostly by doing proper inlining and doing sleep checks in the right
> > place. Unfortunately I had to add one tree sweep to avoid an nasty
> > include loop.
> > 
> > It costs a bit of text space, but I think it's worth it
> > (if only to keep my blood pressure down while reading ftrace logs...)
> > 
> 
> Looks nice at first glance.
> 
> Now, here is a bigger question: shouldn't we be deprecating/getting rid
> of PREEMPT_VOUNTARY in favor of PREEMPT?

I sure hope not, PREEMPT munches throughput.  If you need PREEMPT, seems
to me what you _really_ need is PREEMPT_RT (the real deal), so
eventually depreciating PREEMPT makes more sense to me.

-Mike


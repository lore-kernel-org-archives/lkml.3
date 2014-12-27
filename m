Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751604AbaL0RVZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2014 12:21:25 -0500
Received: from mail-vc0-f170.google.com ([209.85.220.170]:48992 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072AbaL0RVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2014 12:21:21 -0500
MIME-Version: 1.0
In-Reply-To: <CAJhHMCCErUVzD_9mYZOVo=Z_FuBQVV53XWMX_SMEfVUZmBEcRQ@mail.gmail.com>
References: <20141226185120.402d392f@canb.auug.org.au> <20141226165401.GH11609@linux.vnet.ibm.com>
 <CAJhHMCCErUVzD_9mYZOVo=Z_FuBQVV53XWMX_SMEfVUZmBEcRQ@mail.gmail.com>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Sat, 27 Dec 2014 12:20:50 -0500
Message-ID: <CAJhHMCBzF3ZgEP7SyLKzBTHxUmkn27fq7JyxyKe1nktiELXZPA@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the rcu tree
To: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 27, 2014 at 11:24 AM, Pranith Kumar <bobby.prani@gmail.com> wrote:
> On Fri, Dec 26, 2014 at 11:54 AM, Paul E. McKenney wrote:
>> Pranith, if Stephen has CONFIG_KVM=n, it might be best to move the
>> "select SRCU" to "config PPC" in arch/powerpc/Kconfig.  Are you able
>> to cross-build powerpc?
>>
>
> ppc 32 seems fine without selecting srcu unconditionally. So I added
> this select to PPC 64 which should fix this build failure.
>

On looking at this further, I was able to figure out the parts on
ppc64 utilizing KVM and enabled them dependent on CONFIG_KVM being
enabled. I tested this with a ppc64 allnoconfig and it built
succesfully (depending on a unrelated patch to enable printk for
powernv).

I've sent the patch but it still seems that we will be playing
whack-a-mole for now with code which uses KVM indepedent of
CONFIG_KVM. May be fixing it incrementally is a better option than
lumping all these together?

-- 
Pranith

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490Ab3JYL2c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 07:28:32 -0400
Received: from mail.lang.hm ([64.81.33.126]:38450 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752305Ab3JYL2b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 07:28:31 -0400
Date: Fri, 25 Oct 2013 04:28:27 -0700 (PDT)
From: David Lang <david@lang.hm>
X-X-Sender: dlang@asgard.lang.hm
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: "Artem S. Tashkinov" <t.artem@lycos.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Disabling in-memory write cache for x86-64 in Linux II
In-Reply-To: <CA+55aFxhJUrqdvw1To=9KLdxhYAOVwZLLeJT5yMRY5BT1weuHA@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1310250426510.22538@nftneq.ynat.uz>
References: <160824051.3072.1382685914055.JavaMail.mail@webmail07> <CA+55aFxj81TRhe1+FJWqER7VVH_z_Sk0+hwtHvniA0ATsF_eKw@mail.gmail.com> <1814253454.3449.1382689853825.JavaMail.mail@webmail07>
 <CA+55aFxhJUrqdvw1To=9KLdxhYAOVwZLLeJT5yMRY5BT1weuHA@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Oct 2013, Linus Torvalds wrote:

> On Fri, Oct 25, 2013 at 9:30 AM, Artem S. Tashkinov <t.artem@lycos.com> wrote:
>>
>> My feeling is that vm.dirty_ratio/vm.dirty_background_ratio should _not_ be
>> percentage based, 'cause for PCs/servers with a lot of memory (say 64GB or
>> more) this value becomes unrealistic (13GB) and I've already had some
>> unpleasant effects due to it.
>
> Right. The percentage notion really goes back to the days when we
> typically had 8-64 *megabytes* of memory So if you had a 8MB machine
> you wouldn't want to have more than one megabyte of dirty data, but if
> you were "Mr Moneybags" and could afford 64MB, you might want to have
> up to 8MB dirty!!
>
> Things have changed.
>
> So I would suggest we change the defaults. Or pwehaps make the rule be
> that "the ratio numbers are 'ratio of memory up to 1GB'", to make the
> semantics similar across 32-bit HIGHMEM machines and 64-bit machines.

If you go this direction, allow ratios larger than 100%, some people may be 
willing to have huge amounts of dirty data on large memory machines (if the load 
is extremely bursty, they don't have other needs for I/O, or they have a very 
fast storage system, as a few examples)

David Lang

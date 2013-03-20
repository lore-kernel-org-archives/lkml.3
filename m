Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933633Ab3CTQnL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 12:43:11 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:34565 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933184Ab3CTQnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 12:43:08 -0400
MIME-Version: 1.0
In-Reply-To: <20130320154814.GY3042@htj.dyndns.org>
References: <1363737629-16745-1-git-send-email-tj@kernel.org>
	<1363737629-16745-2-git-send-email-tj@kernel.org>
	<CACvQF53ssw_o4Hbjnp9Z2MZieBO=WhL0Po80jR6NGEjMNGENGA@mail.gmail.com>
	<20130320154814.GY3042@htj.dyndns.org>
Date: Thu, 21 Mar 2013 00:43:08 +0800
Message-ID: <CACvQF52uoi0eX0x0mjHn0+q38nQbeMmh+NBamxpF3edGkK9zAQ@mail.gmail.com>
Subject: Re: [PATCH 01/10] workqueue: add wq_numa_tbl_len and wq_numa_possible_cpumask[]
From: Lai Jiangshan <eag0628@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: laijs@cn.fujitsu.com, axboe@kernel.dk, jack@suse.cz,
        fengguang.wu@intel.com, jmoyer@redhat.com, zab@redhat.com,
        linux-kernel@vger.kernel.org, herbert@gondor.hengli.com.au,
        davem@davemloft.net, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 11:48 PM, Tejun Heo <tj@kernel.org> wrote:
> On Wed, Mar 20, 2013 at 11:43:30PM +0800, Lai Jiangshan wrote:
>> > +       for_each_node(node)
>> > +               BUG_ON(!alloc_cpumask_var_node(&wq_numa_possible_cpumask[node],
>> > +                                              GFP_KERNEL, node));
>> > +       for_each_possible_cpu(cpu) {
>> > +               node = cpu_to_node(cpu);
>> > +               if (WARN_ON(node == NUMA_NO_NODE)) {
>> > +                       pr_err("workqueue: NUMA node mapping not available for cpu%d, disabling NUMA support\n", cpu);
>>
>> since you used WARN_ON(), not BUG_ON(), I think you need to free
>> allocated memory here.
>
> I don't know.  Is it necessary?  It shouldn't happen sans bugs in arch
> code and we're vomiting warning message with full stack trace.  The
> system will function but something is seriously screwed.  I don't
> think it matters whether we free the puny number of bytes there or
> not and I don't wanna nest deeper there. :P


I agree with you, but many people use semantic analysis tools to do
hunting in the kernel. they may interrupt you again.

>
> --
> tejun

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733Ab3CTPcX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 11:32:23 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:58181 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902Ab3CTPcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 11:32:20 -0400
MIME-Version: 1.0
In-Reply-To: <CACvQF531UAJVBr1XtT2aZYOt6XATOC383jM=rfiOR-SB3Hj62w@mail.gmail.com>
References: <1363737629-16745-1-git-send-email-tj@kernel.org>
	<1363737629-16745-10-git-send-email-tj@kernel.org>
	<CACvQF51hz_H72zVTt4R=P84RDxat+WTe-Ehw8Zbj0cjifNt4ag@mail.gmail.com>
	<20130320150554.GX3042@htj.dyndns.org>
	<CACvQF531UAJVBr1XtT2aZYOt6XATOC383jM=rfiOR-SB3Hj62w@mail.gmail.com>
Date: Wed, 20 Mar 2013 08:32:19 -0700
X-Google-Sender-Auth: lR7u3njt_V6vpDoIrlcjIZ8K9Ac
Message-ID: <CAOS58YPSRyabrk9Oh=uqWMzZ06ZayGrMgjcbf584T9dsYwaeDA@mail.gmail.com>
Subject: Re: [PATCH 09/10] workqueue: implement NUMA affinity for unbound workqueues
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <eag0628@gmail.com>
Cc: laijs@cn.fujitsu.com, axboe@kernel.dk, jack@suse.cz,
        fengguang.wu@intel.com, jmoyer@redhat.com, zab@redhat.com,
        linux-kernel@vger.kernel.org, herbert@gondor.hengli.com.au,
        davem@davemloft.net, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 8:26 AM, Lai Jiangshan <eag0628@gmail.com> wrote:
>>         for_eahc_node(node)
>>                 if (pwq_tbl[node] != dfl_pwq)
>>                         kfree(pwq_tbl[node]);
>>         kfree(dfl_pwq);
>
> I also missed.
> we still need to put_unbound_pool() before free(pwq)

Yeap, we do.  Wonder whether we can just use put_pwq() there. I'll see if I can.

-- 
tejun

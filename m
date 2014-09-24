Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487AbaIXIPF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 04:15:05 -0400
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:35220 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753354AbaIXIPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 04:15:00 -0400
Message-ID: <54227D7D.6020909@codethink.co.uk>
Date: Wed, 24 Sep 2014 09:14:53 +0100
From: Rob Jones <rob.jones@codethink.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.7.0
MIME-Version: 1.0
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
CC: davem@davemloft.net, coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@codethink.co.uk, linux-kernel@vger.kernel.org,
        netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [Linux-kernel] [PATCH v2] net/netfilter/x_tables.c: use __seq_open_private()
References: <1411491955-9131-1-git-send-email-rob.jones@codethink.co.uk> <1411494387.32579.138.camel@xylophone> <20140923214021.GA4206@salvia>
In-Reply-To: <20140923214021.GA4206@salvia>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 23/09/14 22:40, Pablo Neira Ayuso wrote:
> On Tue, Sep 23, 2014 at 06:46:27PM +0100, Ben Hutchings wrote:
>> On Tue, 2014-09-23 at 18:05 +0100, Rob Jones wrote:
>>> Reduce boilerplate code by using __seq_open_private() instead of seq_open()
>>> in xt_match_open() and xt_target_open().
>>>
>>> Signed-off-by: Rob Jones <rob.jones@codethink.co.uk>
>>> ---
>>>
>>> This patch uses an existing variant of seq_open() to reduce the kernel code
>>> size.
>>>
>>> The only significant variation from the pre-existing code is the fact that
>>> __seq_open_private() calls kzalloc() rather than kmalloc(), which could
>>> conceivably have an impact on timing.
>>>
>>> This version 2 incorporates a minor initialisation simplification (resulting
>>> from kzalloc() being used) requested by netfilter-devel@vger.kernel.org
>> [...]
>>> --- a/net/netfilter/x_tables.c
>>> +++ b/net/netfilter/x_tables.c
>>> @@ -1080,7 +1080,6 @@ static void *xt_mttg_seq_start(struct seq_file *seq, loff_t *pos,
>>>          struct nf_mttg_trav *trav = seq->private;
>>>          unsigned int j;
>>>
>>> -       trav->class = MTTG_TRAV_INIT;
>>>          for (j = 0; j < *pos; ++j)
>>>                  if (xt_mttg_seq_next(seq, NULL, NULL, is_target) == NULL)
>>>                          return NULL;
>> [...]
>>
>> I'm fairly sure this simplification is wrong, as xt_mttg_seq_start() is
>> potentially called multiple times on the same file handle.

Well spotted Ben.

>
> Right. I'm going to take v1 of this patch instead, sorry for the
> inconvenience Rob.

No problem at all. It gave me something to do on the train home last
night :-)

-- 
Rob Jones
Codethink Ltd
mailto:rob.jones@codethink.co.uk
tel:+44 161 236 5575

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758411Ab3G2RdX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 13:33:23 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:47745 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222Ab3G2RdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 13:33:21 -0400
Message-ID: <51F6A74B.1060008@linux.vnet.ibm.com>
Date: Mon, 29 Jul 2013 10:32:59 -0700
From: Cody P Schafer <cody@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Rik van Riel <riel@redhat.com>, Michel Lespinasse <walken@google.com>
Subject: Re: [PATCH 1/5] rbtree: add postorder iteration functions
References: <1374873223-25557-1-git-send-email-cody@linux.vnet.ibm.com> <1374873223-25557-2-git-send-email-cody@linux.vnet.ibm.com> <20130729150147.GA4381@variantweb.net>
In-Reply-To: <20130729150147.GA4381@variantweb.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072917-5406-0000-0000-00000AE04D37
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2013 08:01 AM, Seth Jennings wrote:
> On Fri, Jul 26, 2013 at 02:13:39PM -0700, Cody P Schafer wrote:
>> diff --git a/lib/rbtree.c b/lib/rbtree.c
>> index c0e31fe..65f4eff 100644
>> --- a/lib/rbtree.c
>> +++ b/lib/rbtree.c
>> @@ -518,3 +518,43 @@ void rb_replace_node(struct rb_node *victim, struct rb_node *new,
>>   	*new = *victim;
>>   }
>>   EXPORT_SYMBOL(rb_replace_node);
>> +
>> +static struct rb_node *rb_left_deepest_node(const struct rb_node *node)
>> +{
>> +	for (;;) {
>> +		if (node->rb_left)
>> +			node = node->rb_left;
>
> Assigning to an argument passed as const seems weird to me.  I would
> think it shouldn't compile but it does.  I guess my understanding of
> const is incomplete.
>

Ya, that is due to const's binding:
	const struct rb_node *node1; // the thing pointed to is const
	const struct rb_node node2;  // node is const
	struct rb_node *const node3; // node is const
	const struct rb_node *const node4; // both node and the thing
					   // pointed too are const

And so ends up being perfectly legal (I use the first case listed here).

>> +		else if (node->rb_right)
>> +			node = node->rb_right;
>> +		else
>> +			return (struct rb_node *)node;
>> +	}
>> +}
>> +
>> +struct rb_node *rb_next_postorder(const struct rb_node *node)
>> +{
>> +	const struct rb_node *parent;
>> +	if (!node)
>> +		return NULL;
>> +	parent = rb_parent(node);
>
> Again here.
>
> Seth
>


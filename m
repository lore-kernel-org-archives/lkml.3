Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756716AbaFZPwL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 11:52:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14515 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754076AbaFZPwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 11:52:09 -0400
Message-ID: <53AC4182.3020504@redhat.com>
Date: Thu, 26 Jun 2014 11:51:30 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Luiz Capitulino <lcapitulino@redhat.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        isimatu.yasuaki@jp.fujitsu.com, yinghai@kernel.org,
        andi@firstfloor.org, akpm@linux-foundation.org, rientjes@google.com
Subject: Re: [PATCH] x86: numa: setup_node_data(): drop dead code and rename
 function
References: <20140619222019.3db6ad7e@redhat.com>	<53AC335F.4010308@redhat.com> <20140626110501.78bb611d@redhat.com>
In-Reply-To: <20140626110501.78bb611d@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2014 11:05 AM, Luiz Capitulino wrote:
> On Thu, 26 Jun 2014 10:51:11 -0400
> Rik van Riel <riel@redhat.com> wrote:
> 
> On 06/19/2014 10:20 PM, Luiz Capitulino wrote:
> 
>>>> @@ -523,8 +508,17 @@ static int __init numa_register_memblks(struct
>>>> numa_meminfo *mi) end = max(mi->blk[i].end, end); }
>>>>
>>>> -		if (start < end) -			setup_node_data(nid, start, end); +		if
>>>> (start >= end) +			continue; + +		/* +		 * Don't confuse VM with a
>>>> node that doesn't have the +		 * minimum amount of memory: +		 */ +
>>>> if (end && (end - start) < NODE_MIN_SIZE) +			continue; + +
>>>> alloc_node_data(nid); }
> 
> Minor nit.  If we skip a too-small node, should we remember that we
> did so, and add its memory to another node, assuming it is physically
> contiguous memory?
> 
>> Interesting point. Honest question, please disregard if this doesn't
>> make sense: but won't this affect automatic numa performance? Because
>> the kernel won't know that that extra memory actually pertains to another
>> node and hence that extra memory will have a difference distance of the
>> node that's making use it of it.

If there is so little memory the kernel is unwilling to turn
it into its own zone or node, it should not be enough to
affect placement policy at all.

Whether or not we use that last little bit of memory is probably
not very important, either :)


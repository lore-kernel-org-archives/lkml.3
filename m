Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328AbaBSV7C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 16:59:02 -0500
Received: from shelob.surriel.com ([74.92.59.67]:46245 "EHLO
	shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655AbaBSV7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 16:59:00 -0500
X-Greylist: delayed 1145 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Feb 2014 16:59:00 EST
Message-ID: <530524A3.6090700@surriel.com>
Date: Wed, 19 Feb 2014 16:39:47 -0500
From: Rik van Riel <riel@surriel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        Kelley Nielsen <kelleynnn@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        opw-kernel@googlegroups.com, jamieliu@google.com,
        sjenning@linux.vnet.ibm.com, Hugh Dickins <hughd@google.com>
Subject: Re: [RFC] mm:prototype for the updated swapoff implementation
References: <20140219003522.GA8887@kelleynnn-virtual-machine> <20140219132757.58b61f07bad914b3848275e9@linux-foundation.org>
In-Reply-To: <20140219132757.58b61f07bad914b3848275e9@linux-foundation.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2014 04:27 PM, Andrew Morton wrote:
> On Tue, 18 Feb 2014 16:35:22 -0800 Kelley Nielsen <kelleynnn@gmail.com> wrote:
> 
>> The function try_to_unuse() is of quadratic complexity, with a lot of
>> wasted effort. It unuses swap entries one by one, potentially iterating
>> over all the page tables for all the processes in the system for each
>> one.
>>
>> This new proposed implementation of try_to_unuse simplifies its
>> complexity to linear. It iterates over the system's mms once, unusing
>> all the affected entries as it walks each set of page tables. It also
>> makes similar changes to shmem_unuse.
>>
>> Improvement
>>
>> swapoff was called on a swap partition containing about 50M of data,
>> and calls to the function unuse_pte_range were counted.
>>
>> Present implementation....about 22.5M calls.
>> Prototype.................about  7.0K   calls.
> 
> Do you have situations in which swapoff is taking an unacceptable
> amount of time?  If so, please update the changelog to provide full
> details on this, with before-and-after timing measurements.

I have seen plenty of that.  With just a few GB in swap space in
use, on a system with 24GB of RAM, and about a dozen GB in use
by various processes, I have seen swapoff take several hours of
CPU time.

-- 
All rights reversed.

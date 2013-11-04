Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186Ab3KDIth (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 03:49:37 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:34203 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752967Ab3KDItg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 03:49:36 -0500
Message-ID: <52775F91.5070305@linux.vnet.ibm.com>
Date: Mon, 04 Nov 2013 00:49:21 -0800
From: Cody P Schafer <cody@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] trace/trace_stat: use rbtree postorder iteration
 helper instead of opencoding
References: <1383345566-25087-1-git-send-email-cody@linux.vnet.ibm.com> <1383345566-25087-2-git-send-email-cody@linux.vnet.ibm.com> <20131101224538.7fe04ba8@gandalf.local.home>
In-Reply-To: <20131101224538.7fe04ba8@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13110408-0320-0000-0000-0000019CBD4D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/2013 07:45 PM, Steven Rostedt wrote:
> On Fri,  1 Nov 2013 15:38:46 -0700
> Cody P Schafer <cody@linux.vnet.ibm.com> wrote:
>
>> Use rbtree_postorder_for_each_entry_safe() to destroy the rbtree instead
>> of opencoding an alternate postorder iteration that modifies the tree
>>
>> Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
>> ---
>>   kernel/trace/trace_stat.c | 42 ++++++------------------------------------
>>   1 file changed, 6 insertions(+), 36 deletions(-)
>>

>> +	rbtree_postorder_for_each_entry_safe(snode, n, &session->stat_root,
>> +			node) {
>
> This is one of those cases that a line break is uglier than keeping it
> on the same line. Heck, it's only 4 characters over the 80 char limit.
>

I'm fine with that being tweaked.

> Other than that, I'm fine with this patch. Want me to take this
> separately?
>

The patches in this patchset are all independent (they just happen to be 
making nearly identical changes throughout the tree), so feel free.



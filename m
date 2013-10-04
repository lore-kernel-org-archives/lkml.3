Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755105Ab3JDPQP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 11:16:15 -0400
Received: from prod-mail-xrelay02.akamai.com ([72.246.2.14]:59496 "EHLO
	prod-mail-xrelay02.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754804Ab3JDPQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 11:16:14 -0400
Message-ID: <524EDBBC.2060305@akamai.com>
Date: Fri, 04 Oct 2013 11:16:12 -0400
From: Jason Baron <jbaron@akamai.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "normalperson@yhbt.net" <normalperson@yhbt.net>,
        "nzimmer@sgi.com" <nzimmer@sgi.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "nelhage@nelhage.com" <nelhage@nelhage.com>,
        "davidel@xmailserver.org" <davidel@xmailserver.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 2/2 v2] epoll: Do not take global 'epmutex' for simple
 topologies
References: <cover.1380645717.git.jbaron@akamai.com>	<355cdd8dc79b7bcca59509999a972cc9d6b4b673.1380645717.git.jbaron@akamai.com> <20131003145054.efcf3f4ffc64abcc7e09a87f@linux-foundation.org>
In-Reply-To: <20131003145054.efcf3f4ffc64abcc7e09a87f@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2013 05:50 PM, Andrew Morton wrote:
> On Tue,  1 Oct 2013 17:08:14 +0000 (GMT) Jason Baron <jbaron@akamai.com> wrote:
>
>> When calling EPOLL_CTL_ADD for an epoll file descriptor that is attached
>> directly to a wakeup source, we do not need to take the global 'epmutex',
>> unless the epoll file descriptor is nested. The purpose of taking
>> the 'epmutex' on add is to prevent complex topologies such as loops and
>> deep wakeup paths from forming in parallel through multiple EPOLL_CTL_ADD
>> operations. However, for the simple case of an epoll file descriptor
>> attached directly to a wakeup source (with no nesting), we do not need
>> to hold the 'epmutex'.
>>
>> This patch along with 'epoll: optimize EPOLL_CTL_DEL using rcu' improves
>> scalability on larger systems. Quoting Nathan Zimmer's mail on SPECjbb
>> performance:
>>
>> "
>> On the 16 socket run the performance went from 35k jOPS to 125k jOPS.
>> In addition the benchmark when from scaling well on 10 sockets to scaling well
>> on just over 40 sockets.
>>
>> ...
>>
>> Currently the benchmark stops scaling at around 40-44 sockets but it seems like
>> I found a second unrelated bottleneck.
>> "
> I couldn't resist fiddling.  Please review
>
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: epoll-do-not-take-global-epmutex-for-simple-topologies-fix
>
> - use `bool' for boolean variables
> - remove unneeded/undesirable cast of void*
> - add missed ep_scan_ready_list() kerneldoc 

Hi Andrew,

Looks good to me. Feel free to add:

Reviewed-by: Jason Baron <jbaron@akamai.com>

Thanks,

-Jason

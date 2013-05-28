Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933683Ab3E1Vcj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 17:32:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21270 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757394Ab3E1Vcf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 17:32:35 -0400
Message-ID: <51A52257.4060905@redhat.com>
Date: Tue, 28 May 2013 17:32:07 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Rafael Aquini <aquini@redhat.com>, Ben Greear <greearb@candelatech.com>,
        Francois Romieu <romieu@fr.zoreil.com>, atomlin@redhat.com,
        netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pshelar@nicira.com, mst@redhat.com, alexander.h.duyck@intel.com,
        sergei.shtylyov@cogentembedded.com, linux-kernel@vger.kernel.org
Subject: Re: [Patch v2] skbuff: Hide GFP_ATOMIC page allocation failures for
 dropped packets
References: <1369601101-23057-1-git-send-email-atomlin@redhat.com>  <20130527224149.GA4384@electric-eye.fr.zoreil.com>  <51A4D4AD.2010507@candelatech.com>  <20130528161518.GC11614@optiplex.redhat.com> <1369758577.3301.543.camel@edumazet-glaptop>
In-Reply-To: <1369758577.3301.543.camel@edumazet-glaptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2013 12:29 PM, Eric Dumazet wrote:
> On Tue, 2013-05-28 at 13:15 -0300, Rafael Aquini wrote:
>
>> The real problem seems to be that more and more the network stack (drivers, perhaps)
>> is relying on chunks of contiguous page-blocks without a fallback mechanism to
>> order-0 page allocations. When memory gets fragmented, these alloc failures
>> start to pop up more often and they scare ordinary sysadmins out of their paints.
>>
>
> Where do you see that ?
>
> I see exactly the opposite trend.
>
> We have less and less buggy drivers, and we want to catch last
> offenders.

These backtraces would still get printed out for drivers
that DO do the right thing and fall back to smaller
allocations.

The initial failed large allocation would cause a backtrace.


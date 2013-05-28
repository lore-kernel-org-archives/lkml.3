Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933877Ab3E1Vaf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 17:30:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47171 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933578Ab3E1Vac (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 17:30:32 -0400
Message-ID: <51A521DA.2080206@redhat.com>
Date: Tue, 28 May 2013 17:30:02 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Francois Romieu <romieu@fr.zoreil.com>
CC: atomlin@redhat.com, netdev@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, pshelar@nicira.com, mst@redhat.com,
        alexander.h.duyck@intel.com, aquini@redhat.com,
        sergei.shtylyov@cogentembedded.com, linux-kernel@vger.kernel.org
Subject: Re: [Patch v2] skbuff: Hide GFP_ATOMIC page allocation failures for
 dropped packets
References: <1369601101-23057-1-git-send-email-atomlin@redhat.com> <20130527224149.GA4384@electric-eye.fr.zoreil.com>
In-Reply-To: <20130527224149.GA4384@electric-eye.fr.zoreil.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/2013 06:41 PM, Francois Romieu wrote:
> atomlin@redhat.com <atomlin@redhat.com> :
> [...]
>> Failed GFP_ATOMIC allocations by the network stack result in dropped
>> packets, which will be received on a subsequent retransmit, and an
>> unnecessary, noisy warning with a kernel backtrace.
>>
>> These warnings are harmless, but they still cause users to panic and
>> file bug reports over dropped packets. It would be better to hide the
>> failed allocation warnings and backtraces, and let retransmits handle
>> dropped packets quietly.
>
> Linux VM may be perfect but device drivers do stupid things.
>
> Please don't paper over it just because some shit ends in your backyard.

It is impossible to free memory at the speed at which
10Gbit network packets can come in.

Dropped packets are a reality.

The network stack already has statistics counters to
keep track of dropped packets. There is absolutely
no reason to print out an entire kernel backtrace
for dropped network packets.

All that achieves is get people to file bug reports,
which nothing can be done about. Oh, and distract
them from whatever issue as causing their actual
problem, and delay them fixing what was going on.


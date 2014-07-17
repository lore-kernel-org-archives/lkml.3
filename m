Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933945AbaGQOsw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 10:48:52 -0400
Received: from mail-yh0-f47.google.com ([209.85.213.47]:60952 "EHLO
	mail-yh0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933342AbaGQOry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 10:47:54 -0400
Message-ID: <53C7E234.3020503@gmail.com>
Date: Thu, 17 Jul 2014 10:48:20 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Christoph Lameter <cl@gentwo.org>
CC: rdunlap@infradead.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] doc: Add remote CPU access details and others
 to this_cpu_ops.txt
References: <1405552141-8506-1-git-send-email-bobby.prani@gmail.com> <alpine.DEB.2.11.1407170848490.27584@gentwo.org> <53C7D93B.4090006@gmail.com> <alpine.DEB.2.11.1407170934220.28121@gentwo.org>
In-Reply-To: <alpine.DEB.2.11.1407170934220.28121@gentwo.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2014 10:39 AM, Christoph Lameter wrote:
> On Thu, 17 Jul 2014, Pranith Kumar wrote:
> 
>>> The use of atomic_t implies a remote write operation to a percpu area.
>>>
>>> atomic_t needs to be avoided. If data needs to be modified from multiple
>>> cpus then it usually does not belong into a percpu area.
>>>
>>
>> Yes, I think I made it pretty clear that remote accesses need to be avoided
>> unless absolutely necessary. But, there will be scenarios where mostly local
>> data will need to be have remote accesses. In such scenarios, isn't using
>> atomic_t better? FYI, that is how RCU code currently works. It uses atomic_t in
>> per cpu areas to ensure atomicity for remote accesses.
> 
> The RCU code has .... ummmm... some issues with percpu usage and should
> not be taken as a good example. If you look at the RCU code it looks
> horrible with numerous barriers around remote percpu read/wrirte
> accesses and one wonders if that code is actually ok.

Well, it is running in all our kernels with not many reported issues, isn't it ;)
And yes, that is one of the extra-ordinary situations where we use per-cpu data.
Once you've extracted a pointer to the per-cpu area -and- ensure that concurrent
accesses do not happen(or happen with enough guarantees using barriers), what is
the case against remote accesses? I am asking from a correctness and a
performance point of view, not style/aesthetics.

> 
>> If data needs to be modified from multiple cpus only very rarely, doesn't it
>> make sense to use per-cpu areas?
> 
> I would suggest that this should not occur. You can always "modify" remote
> percpu areas by generating an IPI on that cpu to make that processor
> update its own per cpu data.
> 

The case against doing that is not to wake up CPUs which are in idle/sleep
states. I think mentioning it here that remote accesses are strongly discouraged
with a reasonable explanation of the implications should be enough. There might
always be rare situations where remote accesses might be necessary.

--
Pranith

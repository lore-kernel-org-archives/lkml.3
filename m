Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758654AbaGQXnp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 19:43:45 -0400
Received: from mail-yh0-f53.google.com ([209.85.213.53]:45242 "EHLO
	mail-yh0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754542AbaGQXnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 19:43:43 -0400
Message-ID: <53C85FCA.6080107@gmail.com>
Date: Thu, 17 Jul 2014 19:44:10 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Christoph Lameter <cl@gentwo.org>
CC: rdunlap@infradead.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] doc: Add remote CPU access details and others
 to this_cpu_ops.txt
References: <1405552141-8506-1-git-send-email-bobby.prani@gmail.com> <alpine.DEB.2.11.1407170848490.27584@gentwo.org> <53C7D93B.4090006@gmail.com> <alpine.DEB.2.11.1407170934220.28121@gentwo.org> <53C7E234.3020503@gmail.com> <alpine.DEB.2.11.1407170953070.28248@gentwo.org> <53C7E5C8.9070400@gmail.com> <alpine.DEB.2.11.1407171023150.28248@gentwo.org>
In-Reply-To: <alpine.DEB.2.11.1407171023150.28248@gentwo.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2014 11:26 AM, Christoph Lameter wrote:
> On Thu, 17 Jul 2014, Pranith Kumar wrote:
> 
>> I can mention that IPI is preferable. What is that you don't want mentioned? atomic_t?
> 
> Definitely not as an example. atomic_t in per cpu areas is self
> contradicting. The per cpu area is exclusively for that processor whereas
> an atomic_t is supposed to be accessed from multiple processors.
> 
>>> Remote percpu updates are extremely rare events. If the cpu is idle/asleep
>>> then usually no updates are needed because no activity is occurring on
>>> that cpu.
>>>
>>
>> Yes, -usually- that is the case. But we are talking about the extreme rare event
>> where we need to update some remote CPU`s per-cpu data without waking it up from
>> sleep/idle. How do you suggest we handle this? I don't think suggesting not to
>> use per-cpu areas because of this is a good idea, since we lose a lot of
>> performance in the most common cases.
> 
> If you modify a percpu area then that is usually done because that cpu
> needs to take some action. An IPI is fine.
> 
> Otherwise yes I would suggest not use a percpu area but a separate data
> structure for synchronization.
> 

Yes, I will add this information to the doc. Thanks!

--
Pranith

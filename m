Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138AbaJFKFg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 06:05:36 -0400
Received: from outbound-smtp01.blacknight.com ([81.17.249.7]:37827 "EHLO
	outbound-smtp01.blacknight.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751660AbaJFKFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 06:05:31 -0400
Message-ID: <54326968.10100@nexus-software.ie>
Date: Mon, 06 Oct 2014 11:05:28 +0100
From: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: mingo@redhat.com, hpa@zytor.com, davej@redhat.com, hmh@hmh.eng.br,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] x86: Add cpu_detect_cache_sizes() to init_intel(),
 add Quark to legacy_cache()
References: <1412459037-26089-1-git-send-email-pure.logic@nexus-software.ie> <1412459037-26089-2-git-send-email-pure.logic@nexus-software.ie> <alpine.DEB.2.11.1410061121470.4383@nanos>
In-Reply-To: <alpine.DEB.2.11.1410061121470.4383@nanos>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/14 10:55, Thomas Gleixner wrote:
>> +	 */
>> +	if (c->x86_cache_size == 0)
>> +		l2 = init_intel_cacheinfo(c);
>> +	else
>> +		l2 = c->x86_cache_size;
>
> Looking a bit deeper. This wont work because cpu_detect_cache_sizes()
> will set c->x86_cache_size for all cpus with extended_cpuid_level >=
> 0x80000005, which is the case for everything modern. So this results
> in init_intel_cacheinfo() not being called anymore.

True.

Missed that one.

> So we might need the following conditional:
>
> 	l2 = init_intel_cacheinfo(c);
> +	if (!c->x86_cache_size) {
> +		cpu_detect_cache_sizes(c);
> +		l2 = c->x86_cache_size;
> +	}

Yes - that'll work better.

Also - it only forces a conditional branch - so fewer extra cycles for 
everybody !Quark and !Tualatin - which is preferential. Will incorporate.


Best,
Bryan

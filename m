Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276AbaI3IpP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 04:45:15 -0400
Received: from outbound-smtp04.blacknight.com ([81.17.249.35]:60248 "EHLO
	outbound-smtp04.blacknight.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751712AbaI3IpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 04:45:12 -0400
Message-ID: <542A6D96.7090207@nexus-software.ie>
Date: Tue, 30 Sep 2014 09:45:10 +0100
From: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, mingo@redhat.com, hpa@zytor.com,
        tglx@linutronix.de, hmh@hmh.eng.br, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] x86: Bugfix bit-rot in the calling of legacy_cache_size
References: <1412046710-2686-1-git-send-email-pure.logic@nexus-software.ie> <1412046710-2686-2-git-send-email-pure.logic@nexus-software.ie> <20140930034129.GB14558@redhat.com>
In-Reply-To: <20140930034129.GB14558@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/09/14 04:41, Dave Jones wrote:
> Shouldn't this patch be more like..
>
> -#ifdef CONFIG_X86_64
>    	cpu_detect_cache_sizes(c);
> -#else
> +
> +#ifdef CONFIG_X86_32
>
>   ?

Hmm, maybe but you have code in cpu_detect_cache_sizes that's X86_64 only..

void cpu_detect_cache_sizes(struct cpuinfo_x86 *c)
{
         unsigned int n, dummy, ebx, ecx, edx, l2size;

         n = c->extended_cpuid_level;

         if (n >= 0x80000005) {
                 cpuid(0x80000005, &dummy, &ebx, &ecx, &edx);
                 c->x86_cache_size = (ecx>>24) + (edx>>24);
#ifdef CONFIG_X86_64
                 /* On K8 L1 TLB is inclusive, so don't count it */
                 c->x86_tlbsize = 0;
#endif


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219AbaBZQqi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 11:46:38 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43014 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751720AbaBZQqh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 11:46:37 -0500
Message-ID: <530E1A56.6060802@zytor.com>
Date: Wed, 26 Feb 2014 08:46:14 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>,
        Chris Bainbridge <chris.bainbridge@gmail.com>
CC: davej@redhat.com, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: set Pentium M as PAE capable
References: <20140225060146.GA4339@debian.local> <530C7465.2080600@zytor.com> <20140225162611.GA31902@redhat.com> <530CCFD2.3050007@zytor.com> <20140226121256.GA8494@debian.local> <20140226131852.GA22690@pd.tnic>
In-Reply-To: <20140226131852.GA22690@pd.tnic>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26/2014 05:18 AM, Borislav Petkov wrote:
> On Wed, Feb 26, 2014 at 07:12:59PM +0700, Chris Bainbridge wrote:
>> @@ -226,6 +234,15 @@ static void intel_workarounds(struct cpuinfo_x86 *c)
>>  		clear_cpu_cap(c, X86_FEATURE_SEP);
>>  
>>  	/*
>> +	 * PAE CPUID bug: Pentium M reports no PAE but has PAE
>> +	 */
>> +	if (forcepae) {
>> +		printk(KERN_WARNING "PAE forced!\n");
>> +		set_cpu_cap(c, X86_FEATURE_PAE);
>> +		add_taint(TAINT_MACHINE_CHECK, LOCKDEP_NOW_UNRELIABLE);
> 
> This is certainly the wrong taint flag. We'd need a new one or to
> repurpose another one as I suggested in a previous mail.
> 

I liked your proposal:

> Right, I was about to say that. And since there's no special bit for
> running "out-of-spec", we could probably repurpose
> 
> TAINT_UNSAFE_SMP - 'S' - SMP with CPUs not designed for SMP.
> 
> to
> 
> TAINT_UNSAFE_OUT_OF_SPEC (the letter S fits still) and add that taint
> everytime we're enforcing functionality against doctor's orders, so to
> speak. 

	-hpa


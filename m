Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756764AbaAITfF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 14:35:05 -0500
Received: from service87.mimecast.com ([91.220.42.44]:39086 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543AbaAITe6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 14:34:58 -0500
Message-ID: <52CEF9E7.4070706@arm.com>
Date: Thu, 09 Jan 2014 19:35:03 +0000
From: Sudeep Holla <Sudeep.Holla@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Sudeep.Holla@arm.com, "x86@kernel.org" <x86@kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Rob Herring <robh@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ashok Raj <ashok.raj@intel.com>
Subject: Re: [PATCH RFC 2/3] ARM: kernel: add support for cpu cache information
References: <1389209168-17189-1-git-send-email-sudeep.holla@arm.com> <1389209168-17189-3-git-send-email-sudeep.holla@arm.com> <20140108205754.GN27432@n2100.arm.linux.org.uk>
In-Reply-To: <20140108205754.GN27432@n2100.arm.linux.org.uk>
X-OriginalArrivalTime: 09 Jan 2014 19:34:55.0845 (UTC) FILETIME=[E00D0950:01CF0D71]
X-MC-Unique: 114010919345600201
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/14 20:57, Russell King - ARM Linux wrote:
> On Wed, Jan 08, 2014 at 07:26:07PM +0000, Sudeep Holla wrote:
>> +#if __LINUX_ARM_ARCH__ < 7 /* pre ARMv7 */
>> +
>> +#define MAX_CACHE_LEVEL		1	/* Only 1 level supported */
>> +#define CTR_CTYPE_SHIFT		24
>> +#define CTR_CTYPE_MASK		(1 << CTR_CTYPE_SHIFT)
>> +
>> +static inline unsigned int get_ctr(void)
>> +{
>> +	unsigned int ctr;
>> +	asm volatile ("mrc p15, 0, %0, c0, c0, 1" : "=r" (ctr));
>> +	return ctr;
>> +}
>> +
>> +static enum cache_type get_cache_type(int level)
>> +{
>> +	if (level > MAX_CACHE_LEVEL)
>> +		return CACHE_TYPE_NOCACHE;
>> +	return get_ctr() & CTR_CTYPE_MASK ?
>> +		CACHE_TYPE_SEPARATE : CACHE_TYPE_UNIFIED;
> 
> So, what do we do for CPUs that don't implement the CTR?  Just return
> random rubbish based on decoding the CPU Identity register as if it
> were the cache type register?
> 

I assume you referring to some particular CPUs which don't implement this.
I could not find it as optional or IMPLEMENTATION defined in ARM ARM.
I might be missing to find it or there may be exceptions.
Can you please provide more information on that ?

Regards,
Sudeep


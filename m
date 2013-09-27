Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732Ab3I0UNT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 16:13:19 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:60011 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141Ab3I0UNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 16:13:18 -0400
Message-ID: <5245E6DB.4000401@tilera.com>
Date: Fri, 27 Sep 2013 16:13:15 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Nicolas Pitre <nico@linaro.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] tile: use a more conservative __my_cpu_offset in CONFIG_PREEMPT
References: <201309261738.r8QHcGZX007708@farm-0012.internal.tilera.com> <20130926175754.GD7146@mudshark.cambridge.arm.com>
In-Reply-To: <20130926175754.GD7146@mudshark.cambridge.arm.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/26/2013 1:57 PM, Will Deacon wrote:
> Hi Chris,
>
> On Thu, Sep 26, 2013 at 06:24:53PM +0100, Chris Metcalf wrote:
>> [...]
>> +static inline unsigned long __my_cpu_offset(void)
>> +{
>> +	unsigned long tp;
>> +	register unsigned long *sp asm("sp");
>> +	asm("move %0, tp" : "=r" (tp) : "m" (*sp));
>> +	return tp;
>> +}
> Hehe, nice to see this hack working out for you too. One thing to check is
> whether you have any funky addressing modes (things like writeback or
> post-increment), since the "m" constraint can bite you if you don't actually
> use it in the asm.

Well, we do have post increments, though I don't see why this is a problem here.
We define a target specific constraint "U" that excludes post-increments, but
again I don't see why "m" would cause trouble here.  What was your experience?

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com


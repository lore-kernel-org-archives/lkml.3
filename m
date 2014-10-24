Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756355AbaJXML0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 08:11:26 -0400
Received: from down.free-electrons.com ([37.187.137.238]:39110 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756140AbaJXMLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 08:11:23 -0400
Message-ID: <544A41E5.2090802@free-electrons.com>
Date: Fri, 24 Oct 2014 14:11:17 +0200
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
CC: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] ARM: mvebu: Move SCU power up in a function
References: <1414088070-12510-1-git-send-email-gregory.clement@free-electrons.com>	<1414088070-12510-3-git-send-email-gregory.clement@free-electrons.com> <20141024140551.0890f204@free-electrons.com>
In-Reply-To: <20141024140551.0890f204@free-electrons.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On 24/10/2014 14:05, Thomas Petazzoni wrote:
> Dear Gregory CLEMENT,
> 
> On Thu, 23 Oct 2014 20:14:28 +0200, Gregory CLEMENT wrote:
> 
>> +ENTRY(power_up_scu)
>> +	mrc     p15, 4, r1, c15, c0	@ get SCU base address
>> +	orr	r1, r1, #0x8		@ SCU CPU Power Status Register
>> +	mrc	15, 0, r0, cr0, cr0, 5	@ get the CPU ID
>> +	and	r0, r0, #15
>> +	add	r1, r1, r0
>> +	mov	r0, #0x0
>> +	strb	r0, [r1]		@ switch SCU power state to Normal mode
>> +	ret	lr
>> +ENDPROC(power_up_scu)
> 
> Since this function is not static, I think it might be a good idea to
> use a prefix that makes it more specific to the platform in order to
> not pollute the global namespace. Maybe something like
> 'armada_38x_scu_power_up', or something like that.

Yes given the fact that this function is declared in the mach-mveu folder
it is sensible to use a more specific name. However the function itself
is not specific at all to an SoC. This function could be used for any Cortex A9
using the SCU.


Thanks,

Gregory



-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com

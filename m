Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932544Ab3DZBH0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 21:07:26 -0400
Received: from intranet.asianux.com ([58.214.24.6]:19163 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932409Ab3DZBHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 21:07:25 -0400
X-Spam-Score: -100.8
Message-ID: <5179D302.9060203@asianux.com>
Date: Fri, 26 Apr 2013 09:06:10 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Michael Neuling <mikey@neuling.org>
CC: Mike Qiu <qiudayu@linux.vnet.ibm.com>, Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org, sfr@canb.auug.org.au, matt@ozlabs.org,
        linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH v2] PowerPC: kernel: compiling issue, make additional
 room in exception vector area
References: <5177965D.9090406@linux.vnet.ibm.com> <20130424083142.GB26834@concordia> <51779941.8080403@linux.vnet.ibm.com> <30651.1366799858@ale.ozlabs.ibm.com> <1366807638.5911.2.camel@localhost> <5178816D.3000309@asianux.com> <5178ABA2.4030109@linux.vnet.ibm.com> <20130425062539.GA421@iris.ozlabs.ibm.com> <517918AB.4020508@asianux.com> <30269.1366931768@ale.ozlabs.ibm.com>
In-Reply-To: <30269.1366931768@ale.ozlabs.ibm.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013Äê04ÔÂ26ÈÕ 07:16, Michael Neuling wrote:
>> > diff --git a/arch/powerpc/kernel/exceptions-64s.S b/arch/powerpc/kernel/exceptions-64s.S
>> > index e789ee7..8997de2 100644
>> > --- a/arch/powerpc/kernel/exceptions-64s.S
>> > +++ b/arch/powerpc/kernel/exceptions-64s.S
>> > @@ -254,7 +254,11 @@ hardware_interrupt_hv:
>> >  	STD_EXCEPTION_PSERIES(0x800, 0x800, fp_unavailable)
>> >  	KVM_HANDLER_PR(PACA_EXGEN, EXC_STD, 0x800)
>> >  
>> > -	MASKABLE_EXCEPTION_PSERIES(0x900, 0x900, decrementer)
>> > +	. = 0x900
>> > +	.globl decrementer_pSeries
>> > +decrementer_pSeries:
>> > +	b	decrementer_pSeries_0
>> > +
> Unfortunately you can't do this ether as we need to save the CFAR[1]
> before it's overwritten by any branch. MASKABLE_EXCEPTION_PSERIES does
> this.
> 

Thanks for your checking.

> CFAR is the Come From Register.  It saves the location of the last
> branch and is hence overwritten by any branch.
> 

Do we process it just like others done (e.g. 0x300, 0xe00, 0xe20 ...) ?
	. = 0x900
	.globl decrementer_pSeries
decrementer_pSeries:
 	HMT_MEDIUM_PPR_DISCARD
	SET_SCRATCH0(r13)
	b decrementer_pSeries_0

	...


> Thanks for trying.
> 

Not at all, before get fixed by other members, I should continue trying.

-- 
Chen Gang

Asianux Corporation

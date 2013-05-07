Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758932Ab3EGQR6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 12:17:58 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:10028 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756222Ab3EGQR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 12:17:57 -0400
X-IronPort-AV: E=Sophos;i="4.87,629,1363158000"; 
   d="scan'208";a="44905191"
Message-ID: <51892933.7090405@codeaurora.org>
Date: Tue, 07 May 2013 12:17:55 -0400
From: Christopher Covington <cov@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "marc.zyngier@arm.com" <marc.zyngier@arm.com>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Xen-devel] [PATCH 1/3] arm_arch_timer: introduce arch_timer_stolen_ticks
References: <alpine.DEB.2.02.1305011939180.5398@kaball.uk.xensource.com> <1367436460-10183-1-git-send-email-stefano.stabellini@eu.citrix.com> <51817CBE.4050003@codeaurora.org> <1367482772.21869.26.camel@zakaz.uk.xensource.com> <5182DBA9.9080609@codeaurora.org> <20130506143533.GF15278@phenom.dumpdata.com>
In-Reply-To: <20130506143533.GF15278@phenom.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Konrad,

On 05/06/2013 10:35 AM, Konrad Rzeszutek Wilk wrote:
>>> e.g. if a VCPU sets a timer for NOW+5, but 3 are stolen in the middle it
>>> would not make sense (from the guests PoV) for NOW'==NOW+2 at the point
>>> where the timer goes off. Nor does it make sense to require that the
>>> guest actually be running for 5 before injecting the timer because that
>>> would mean real time elapsed time for the timer would be 5+3 in the case
>>> where 3 are stolen.
>>
>> This is a bit of an aside, but I think that hiding time spent at higher
>> privilege levels can be a quite sensible approach to timekeeping in a
>> virtualized environment, but I understand that it's not the approach taken
>> with Xen, and as you pointed out above, adjusting the Virtual Offset Register
>> by itself isn't enough to implement that approach.
> 
> This is the approach taken by Xen and KVM. Look in CONFIG_PARAVIRT_CLOCK for
> implementation. In the user-space, the entry in 'top' of "stolen" (%st)
> is for this exact value.

I may have been unclear with my terms, sorry. When I refer to time being
"hidden", I mean that kernel level software (supervisor mode, EL1) cannot
detect the passage of that time at all. I don't know whether this would really
work, but I imagine one might be able to get close with the current
virtualization facilities for ARM.

Am I correct in interpreting that what you're referring to is the deployment
of paravirtualization code that ensures (observable) "stolen" time is factored
into kernel decision-making?

Thanks,
Christopher

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by the Linux Foundation.

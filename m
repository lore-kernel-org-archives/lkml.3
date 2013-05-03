Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763128Ab3ECKyl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 06:54:41 -0400
Received: from service87.mimecast.com ([91.220.42.44]:58881 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756528Ab3ECKyj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 06:54:39 -0400
Message-ID: <5183976A.6000703@arm.com>
Date: Fri, 03 May 2013 11:54:34 +0100
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: Christopher Covington <cov@codeaurora.org>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Xen-devel] [PATCH 1/3] arm_arch_timer: introduce arch_timer_stolen_ticks
References: <alpine.DEB.2.02.1305011939180.5398@kaball.uk.xensource.com> <1367436460-10183-1-git-send-email-stefano.stabellini@eu.citrix.com> <51817CBE.4050003@codeaurora.org> <1367482772.21869.26.camel@zakaz.uk.xensource.com> <5182DBA9.9080609@codeaurora.org> <alpine.DEB.2.02.1305031130210.5398@kaball.uk.xensource.com>
In-Reply-To: <alpine.DEB.2.02.1305031130210.5398@kaball.uk.xensource.com>
X-Enigmail-Version: 1.4.6
X-OriginalArrivalTime: 03 May 2013 10:54:34.0962 (UTC) FILETIME=[99451B20:01CE47EC]
X-MC-Unique: 113050311543501601
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/13 11:43, Stefano Stabellini wrote:
> On Thu, 2 May 2013, Christopher Covington wrote:
>>> So the virtual timer should appear to have been running even while time
>>> is being stolen and therefore stolen time needs to be accounted via some
>>> other means.
>>
>> Something that's not currently obvious to me is that given that the stolen
>> cycle accounting should be done, what makes the architected timer interrupt
>> handler the ideal place to do it?
> 
> That is a good question and I would appreciate suggestions to improve
> the patch.
> 
> Given that Xen x86 and ia64 does stolen time accounting from the timer
> interrupt handler:
> 
> arch/x86/xen/time.c:xen_timer_interrupt
> arch/ia64/kernel/time.c:timer_interrupt
> 
> and given that the arch_timer is the only timer used by Xen on ARM and
> that it includes a virt_timer that is made on purpose to be used by
> virtual machines, I thought that it might be a good place for it.
> 
> I also thought that doing it this way, KVM should be able to reuse the
> same hook.

Indeed. I just need to understand how time stealing works there ;-).

Now, KVM is not necessarily limited to arch_timers, and we've run KVM
using a QEMU-provided timer in the past. Can you think of a more generic
location for this hook? Possibly something that would satisfy the
requirements of other architectures while we're at it?

	M.
-- 
Jazz is not dead. It just smells funny...


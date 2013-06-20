Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030204Ab3FTKB2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 06:01:28 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:3053 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965240Ab3FTKB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 06:01:26 -0400
X-IronPort-AV: E=Sophos;i="4.87,903,1363132800"; 
   d="scan'208";a="30787771"
Message-ID: <51C2D2F3.5030906@citrix.com>
Date: Thu, 20 Jun 2013 11:01:23 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120428 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <xen-devel@lists.xen.org>, <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/4] xen: disable non-boot VCPUs during suspend
References: <1371655523-15609-1-git-send-email-david.vrabel@citrix.com> <1371655523-15609-2-git-send-email-david.vrabel@citrix.com> <20130619171103.GD13046@phenom.dumpdata.com>
In-Reply-To: <20130619171103.GD13046@phenom.dumpdata.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/06/13 18:11, Konrad Rzeszutek Wilk wrote:
> On Wed, Jun 19, 2013 at 04:25:20PM +0100, David Vrabel wrote:
>> From: David Vrabel <david.vrabel@citrix.com>
>>
>> syscore_suspend() and syscore_resume() expect there to be only one
>> online CPU.  e.g., hrtimers_resume() only triggers events for the
>> current CPU.  Xen's suspend path was leaving all VCPUs online and then
>> attempting to fixup problems afterwards (e.g., with an explicit call
>> to clock_was_set() to trigger pending high resolution timers).
>>
>> Instead, disable non-boot CPUs before calling stop_machine() and
>> reenable them afterwards.
>>
>> This is then similar to what the kexec code does before and after a
>> kexec jump (see kernel_kexec() in kernel/kexec.c).
>>
>> Signed-off-by: David Vrabel <david.vrabel@citrix.com>
> 
> Looks like a bug-fix. But considering that the VCPU hotplug code
> in PVHVM had bugs in until v3.10 it probably shouldn't even hit
> stable tree.

I don't think actually fixes any bugs so it doesn't need to go to stable.

David

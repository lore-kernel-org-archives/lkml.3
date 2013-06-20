Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965390Ab3FTLqv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 07:46:51 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:13780 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965016Ab3FTLqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 07:46:50 -0400
X-IronPort-AV: E=Sophos;i="4.87,904,1363132800"; 
   d="scan'208";a="30804287"
Message-ID: <51C2EBA7.9060208@citrix.com>
Date: Thu, 20 Jun 2013 12:46:47 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120428 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        <xen-devel@lists.xen.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 1/4] xen: disable non-boot VCPUs during suspend
References: <1371655523-15609-1-git-send-email-david.vrabel@citrix.com> <1371655523-15609-2-git-send-email-david.vrabel@citrix.com> <51C2F7C102000078000DF504@nat28.tlf.novell.com>
In-Reply-To: <51C2F7C102000078000DF504@nat28.tlf.novell.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/06/13 11:38, Jan Beulich wrote:
>>>> On 19.06.13 at 17:25, David Vrabel <david.vrabel@citrix.com> wrote:
>> syscore_suspend() and syscore_resume() expect there to be only one
>> online CPU.  e.g., hrtimers_resume() only triggers events for the
>> current CPU.  Xen's suspend path was leaving all VCPUs online and then
>> attempting to fixup problems afterwards (e.g., with an explicit call
>> to clock_was_set() to trigger pending high resolution timers).
>>
>> Instead, disable non-boot CPUs before calling stop_machine() and
>> reenable them afterwards.
> 
> In XenoLinux the so called "fast suspend" mode was specifically
> added for performance reasons, and it looks like to date pv-ops
> only ever supported that mode. So one question is whether
> there's going to be any bad performance effect from this.

Yes :(

On a VM with 4 VCPUs, disable_boot_cpus() took > 200 ms.

I'll have to rethink this.

David

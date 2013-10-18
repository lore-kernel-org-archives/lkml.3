Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751718Ab3JRHhb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 03:37:31 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:49610 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073Ab3JRHha convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Fri, 18 Oct 2013 03:37:30 -0400
Message-Id: <5261015702000078000FBFA1@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Fri, 18 Oct 2013 08:37:26 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Ingo Molnar" <mingo@kernel.org>
Cc: <mingo@elte.hu>, "John Stultz" <john.stultz@linaro.org>,
        <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [PATCH] x86: honor ACPI FADT flag indicating absence of a
 CMOS RTC
References: <525E969E02000078000FB710@nat28.tlf.novell.com>
 <20131018062908.GD14264@gmail.com>
In-Reply-To: <20131018062908.GD14264@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 18.10.13 at 08:29, Ingo Molnar <mingo@kernel.org> wrote:
> * Jan Beulich <JBeulich@suse.com> wrote:
> 
>> We shouldn't be creating a corresponding platform device in that case.
> 
> There's a sad lack of context in the changelog, how was it found, does 
> this address any problem/bug observed in practice, etc?

This was a result from code review in Xen hypervisor code in
the context of ACPI 5 work there, which lead me to check whether
Linux would honor that flag. No known issue in practice so far.
Once the below got clarified, I can certainly extend the description
in an eventual resubmission (albeit I would have though that fixing
the not honoring of a firmware flag should speak for itself).

>> +#ifdef CONFIG_ACPI
>> +	if (acpi_gbl_FADT.boot_flags & ACPI_FADT_NO_CMOS_RTC)
>> +		return -ENODEV;
>> +#endif
> 
> It might also be prudent to emit a KERN_INFO line telling that we don't 
> create the device - so that people who suddenly see unexpected breakage or 
> change in behavior have a chance to see what we've done?

There are so many other -ENODEV return paths here which don't
emit messages that this seemed inappropriate, the more that a
message _is_ being issued if the platform RTC device does get
registered (and hence one could judge by the message
disappearing between before and after the patch got applied).

Jan


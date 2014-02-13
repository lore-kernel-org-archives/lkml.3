Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462AbaBMNlA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 08:41:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11780 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753261AbaBMNk7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 08:40:59 -0500
References: <8738jr5t3e.fsf@redhat.com> <20140210175246.GB2887@console-pimps.org> <87mwhy8iaj.fsf@redhat.com> <20140211131640.GD2887@console-pimps.org> <87lhxh69u0.fsf@redhat.com> <20140211141846.GA1725@console-pimps.org> <1392221703.5612.164.camel@misato.fc.hp.com> <20140213105547.GC20717@console-pimps.org>
User-agent: mu4e 0.9.9.6pre2; emacs 24.3.1
From: Madper Xie <cxie@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Toshi Kani <toshi.kani@hp.com>, Madper Xie <cxie@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi\@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Josh Triplett <josh@joshtriplett.org>
Subject: Re: [BUG] can't boot up: unable to handle kernel paging request at ffffffffff340003
In-reply-to: <20140213105547.GC20717@console-pimps.org>
Date: Thu, 13 Feb 2014 21:40:36 +0800
Message-ID: <87k3czdtbf.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


matt@console-pimps.org writes:

> On Wed, 12 Feb, at 09:15:03AM, Toshi Kani wrote:
>> 
>> Hi Matt,
>> 
>> Yes, I agree that the table size should be 0x38.  However, ACPI spec
>> states that bit0 of status indicates if the boot image graphic is valid.
>> This bit is set to 0 (invalid) on the system.  Can you check this bit
>> and return when invalid? 
>
> Madper, could you try out this patch?
>
Thanks Matt. This patch fix the panic. And ioremap warning disappeared
after apply your patch.
> ---
>
> diff --git a/arch/x86/platform/efi/efi-bgrt.c b/arch/x86/platform/efi/efi-bgrt.c
> index 4df9591eadad..f15103dff4b4 100644
> --- a/arch/x86/platform/efi/efi-bgrt.c
> +++ b/arch/x86/platform/efi/efi-bgrt.c
> @@ -42,7 +42,7 @@ void __init efi_bgrt_init(void)
>  
>  	if (bgrt_tab->header.length < sizeof(*bgrt_tab))
>  		return;
> -	if (bgrt_tab->version != 1)
> +	if (bgrt_tab->version != 1 || bgrt_tab->status != 1)
>  		return;
>  	if (bgrt_tab->image_type != 0 || !bgrt_tab->image_address)
>  		return;

-- 
Madper

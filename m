Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758656Ab3BGQaI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 11:30:08 -0500
Received: from mail-ve0-f175.google.com ([209.85.128.175]:36993 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754325Ab3BGQaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 11:30:06 -0500
MIME-Version: 1.0
In-Reply-To: <20130207113340.GW25591@8bytes.org>
References: <5fc782f401fc7bb0cd829b2316d7f29eb2595036.1360206266.git.luto@amacapital.net>
 <20130207113340.GW25591@8bytes.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 7 Feb 2013 08:29:42 -0800
Message-ID: <CALCETrUzX9efPafJ0W2vxU-KgQ_FOxQ4YqGDKbw5z6d1P0ZYEQ@mail.gmail.com>
Subject: Re: [PATCH] intel_iommu: Disable vfio and kvm interrupt assignment
 when unsafe
To: Joerg Roedel <joro@8bytes.org>
Cc: Gleb Natapov <gleb@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Don Zickus <dzickus@redhat.com>, Prarit Bhargava <prarit@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 7, 2013 at 3:33 AM, Joerg Roedel <joro@8bytes.org> wrote:
> On Wed, Feb 06, 2013 at 07:08:24PM -0800, Andy Lutomirski wrote:
>> -     if (x2apic_present)
>> -             WARN(1, KERN_WARNING
>> -                     "Failed to enable irq remapping.  You are vulnerable to irq-injection attacks.\n");
>> -
>> +     irq_remapping_is_secure = 0;
>>       return -1;
>>  }
>
> Why do you remove this warning? It seems unrelated to the rest of the
> patch.

The idea is that setting irq_remapping_is_secure = 0 makes you (much
less) vulnerable to irq-injection attacks: you're vulnerable to
malicious hardware but not to attack via vfio or kvm, because those
paths are disabled.

I'd have no problem leaving the warning in and letting whoever manages
to trigger it and get annoyed fix it.  FWIW, it's actually likely to
be interesting if the warning hits.

--Andy

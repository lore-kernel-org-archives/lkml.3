Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142Ab3BDSUb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 13:20:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24256 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754984Ab3BDSU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 13:20:29 -0500
Date: Mon, 4 Feb 2013 13:20:15 -0500
From: Don Zickus <dzickus@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Gleb Natapov <gleb@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Prarit Bhargava <prarit@redhat.com>
Subject: Re: [PATCH] intel_irq_remapping: Clean up x2apic optout security
 warning mess
Message-ID: <20130204182015.GY98867@redhat.com>
References: <510C3AF0.6050109@amacapital.net>
 <2011b943a886fd7c46079eb10bc24fc130587503.1359759303.git.luto@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2011b943a886fd7c46079eb10bc24fc130587503.1359759303.git.luto@amacapital.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 01, 2013 at 02:57:43PM -0800, Andy Lutomirski wrote:
> Current kernels print this on my Dell server:
> 
>    ------------[ cut here ]------------
>    WARNING: at drivers/iommu/intel_irq_remapping.c:542
>    intel_enable_irq_remapping+0x7b/0x27e()
>    Hardware name: PowerEdge R620
>    Your BIOS is broken and requested that x2apic be disabled
>    This will leave your machine vulnerable to irq-injection attacks
>    Use 'intremap=no_x2apic_optout' to override BIOS request
>    [...]
>    Enabled IRQ remapping in xapic mode
>    x2apic not enabled, IRQ remapping is in xapic mode
> 
> This is inconsistent with itself -- interrupt remapping is *on*.
> 
> Fix the mess by making the warnings say what they mean and my making
> sure that compatibility format interrupts (the dangerous ones) are
> disabled if x2apic is present regardless of BIOS settings.

Yeah, this fixes the problem on our end too.  Thank Andy!

Cheers,
Don

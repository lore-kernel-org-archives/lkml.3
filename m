Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754399Ab3CHHP6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 02:15:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44378 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753976Ab3CHHP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 02:15:57 -0500
Date: Thu, 7 Mar 2013 23:16:11 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Tejun Heo <tj@kernel.org>, "Yu, Fenghua" <fenghua.yu@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Renninger <trenn@suse.de>,
        Tang Chen <tangchen@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        Pekka Enberg <penberg@kernel.org>, Jacob Shin <jacob.shin@amd.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 04/14] x86, ACPI: make acpi override finding work with
 32bit flat mode
Message-Id: <20130307231611.5fd2bdcb.akpm@linux-foundation.org>
In-Reply-To: <CAE9FiQVXOC71BGSK3t_xg+nP5Qq8ZKoup0sTMJDPnv-y8++=hg@mail.gmail.com>
References: <1362718720-27048-1-git-send-email-yinghai@kernel.org>
	<1362718720-27048-5-git-send-email-yinghai@kernel.org>
	<20130308055023.GF14556@mtj.dyndns.org>
	<CAE9FiQVXOC71BGSK3t_xg+nP5Qq8ZKoup0sTMJDPnv-y8++=hg@mail.gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Mar 2013 22:57:21 -0800 Yinghai Lu <yinghai@kernel.org> wrote:

> >
> >> @@ -552,38 +552,47 @@ u8 __init acpi_table_checksum(u8 *buffer, u32 length)
> >>       return sum;
> >>  }
> >>
> >> -/* All but ACPI_SIG_RSDP and ACPI_SIG_FACS: */
> >> -static const char * const table_sigs[] = {
> >> -     ACPI_SIG_BERT, ACPI_SIG_CPEP, ACPI_SIG_ECDT, ACPI_SIG_EINJ,
> >> -     ACPI_SIG_ERST, ACPI_SIG_HEST, ACPI_SIG_MADT, ACPI_SIG_MSCT,
> >> -     ACPI_SIG_SBST, ACPI_SIG_SLIT, ACPI_SIG_SRAT, ACPI_SIG_ASF,
> >> -     ACPI_SIG_BOOT, ACPI_SIG_DBGP, ACPI_SIG_DMAR, ACPI_SIG_HPET,
> >> -     ACPI_SIG_IBFT, ACPI_SIG_IVRS, ACPI_SIG_MCFG, ACPI_SIG_MCHI,
> >> -     ACPI_SIG_SLIC, ACPI_SIG_SPCR, ACPI_SIG_SPMI, ACPI_SIG_TCPA,
> >> -     ACPI_SIG_UEFI, ACPI_SIG_WAET, ACPI_SIG_WDAT, ACPI_SIG_WDDT,
> >> -     ACPI_SIG_WDRT, ACPI_SIG_DSDT, ACPI_SIG_FADT, ACPI_SIG_PSDT,
> >> -     ACPI_SIG_RSDT, ACPI_SIG_XSDT, ACPI_SIG_SSDT, NULL };
> >
> > Why is this table made a stack variable?  What's the benefit of doing
> > that?
> 
> so I do need to switch global variables to phys and access it.

What Tejun means is that it should be marked "static" within
acpi_initrd_override(), so we don't have to build a copy on the stack
at runtime each time acpi_initrd_override() is called.

While we're there, it should be __initdata also.

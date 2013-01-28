Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563Ab3A1KLm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 05:11:42 -0500
Received: from mail-bk0-f49.google.com ([209.85.214.49]:60651 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754442Ab3A1KLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 05:11:40 -0500
Date: Mon, 28 Jan 2013 11:11:35 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "Wang, Song-Bo (Stoney)" <song-bo.wang@hp.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Zhang, Lin-Bao (Linux Kernel R&D)" <linbao.zhang@hp.com>,
        "Pearson, Greg" <greg.pearson@hp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "suresh.b.siddha@intel.com" <suresh.b.siddha@intel.com>
Subject: Re: [PATCH] x86/apic: check FADT settings after enable x2apic
Message-ID: <20130128101135.GD7168@gmail.com>
References: <1358214636-4801-1-git-send-email-song-bo.wang@hp.com>
 <FE3E8B88161FFE48B03E3B93408433EC671016E2@G9W0754.americas.hpqcorp.net>
 <CAE9FiQW75eP_exufb1gd7jQuu98WnkyGX23EBXktUCSyZX9Jvg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQW75eP_exufb1gd7jQuu98WnkyGX23EBXktUCSyZX9Jvg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> On Sun, Jan 27, 2013 at 9:05 PM, Wang, Song-Bo (Stoney)
> <song-bo.wang@hp.com> wrote:
> > Hi Yinghai, hpa and others,
> >
> > Would you please review the patch on detecting x2apic FADT settings?
> >
> > We meet a BIOS system which works on x2apic physical mode by 
> > setting the bit ACPI_FADT_APIC_PHYSICAL in FADT table. And 
> > for those systems with all cpuid < 255, the spec requires 
> > BIOS's default mode in xapic. The kernel detects the default 
> > mode and do some initializations and will call 
> > enable_IR_x2apic and change the mode to x2apic successfully.
> 
> Hi, Peter and Ingo,
> 
> I checked the patch, and looks right.
> 
> I updated the changelog and simplify the code a little bit.
> 
> Please check if you can put it into tip:x86/apic

The code looks good to me, but the changelog is still lacking:

> HP has systems that work with x2apic phys mode and BIOS set 
> ACPI_FADT_APIC_PHYSICAL in FADT table, and all cpuid < 255, 
> the spec requires BIOS only put system on xapic mode. Kernel 

Which spec?

> will set to x2apic logical mode instead of x2apic phys mode.

Which has exactly what bad effect on users of these systems?

You left out the most important information from the changelog: 
why do users care, what good does the patch do?

Thanks,

	Ingo

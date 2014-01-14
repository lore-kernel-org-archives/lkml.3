Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751659AbaANOiN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 09:38:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14859 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751318AbaANOiJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 09:38:09 -0500
Date: Tue, 14 Jan 2014 09:37:49 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Prarit Bhargava <prarit@redhat.com>
Cc: Toshi Kani <toshi.kani@hp.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Linn Crosetto <linn@hp.com>,
        Pekka Enberg <penberg@kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        Wen Congyang <wency@cn.fujitsu.com>, Dave Young <dyoung@redhat.com>,
        linux-acpi@vger.kernel.org, "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] x86, acpi memory hotplug, add parameter to disable
 memory hotplug
Message-ID: <20140114143749.GB3096@redhat.com>
References: <1389650161-13292-1-git-send-email-prarit@redhat.com>
 <CAHGf_=pX303E6VAhL+gApSQ1OsEQHqTuCN8ZSdD3E54YAcFQKA@mail.gmail.com>
 <52D47999.5080905@redhat.com>
 <52D48EC4.5070400@jp.fujitsu.com>
 <1389663689.1792.268.camel@misato.fc.hp.com>
 <52D519EB.3040709@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52D519EB.3040709@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 06:05:15AM -0500, Prarit Bhargava wrote:
> 
> 
> On 01/13/2014 08:41 PM, Toshi Kani wrote:
> > On Tue, 2014-01-14 at 10:11 +0900, Yasuaki Ishimatsu wrote:
> >  :
> >>>> I think we need a knob manually enable mem-hotplug when specify memmap. But
> >>>> it is another story.
> >>>>
> >>>> Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> >>>
> >>> As mentioned, self-NAK.  I have seen a system that I needed to specify
> >>> memmap=exactmap & had hotplug memory.  I will only keep the acpi_no_memhotplug
> >>> option in the next version of the patch.
> >>
> >>
> >> Your following first patch is simply and makes sense.
> >>
> >> http://marc.info/?l=linux-acpi&m=138922019607796&w=2
> >>
> > 
> > In this option, it also requires changing kexec-tools to specify the new
> > option for kdump.  It won't be simpler.
> 
> It will be simpler for the kernel and those of us who have to debug busted e820
> maps ;)
> 
> Unfortunately I may not be able to give you the automatic disable.  I did
> contemplate adding a !is_kdump_kernel() to the ACPI memory hotplug init call,
> but it seems like that is unacceptable as well.

Yep, I don't think hotplug feature should be tied to it being a kdump
kernel.

Thanks
Vivek

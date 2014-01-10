Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757341AbaAJBVy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 20:21:54 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:50552 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753435AbaAJBVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 20:21:52 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>, linux-acpi@vger.kernel.org,
        Len Brown <lenb@kernel.org>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Dave Young <dyoung@redhat.com>,
        Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATCH] acpi memory hotplug, add parameter to disable memory hotplug for kexec
Date: Fri, 10 Jan 2014 02:35:42 +0100
Message-ID: <1954341.oEieD4sfT5@vostro.rjw.lan>
User-Agent: KMail/4.11.3 (Linux/3.13.0-rc6+; KDE/4.11.3; x86_64; ; )
In-Reply-To: <20140109214425.GD12111@redhat.com>
References: <1389220181-14474-1-git-send-email-prarit@redhat.com> <CAHGf_=oaPZNE8tVsZ1C1z3mHee8MK6CkuZ0YBTcJpRrTWgVn6g@mail.gmail.com> <20140109214425.GD12111@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, January 09, 2014 04:44:25 PM Vivek Goyal wrote:
> On Thu, Jan 09, 2014 at 04:34:16PM -0500, KOSAKI Motohiro wrote:
> > On Thu, Jan 9, 2014 at 10:00 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > > On Thu, Jan 09, 2014 at 12:00:29AM +0100, Rafael J. Wysocki wrote:
> > >
> > > [..]
> > >> > The system then panics and the kdump/kexec kernel boots.  During this boot
> > >> > ACPi is initialized and the kernel (as can be seen above)
> > >>
> > >> Which is a bug.  You're not supposed to initialize ACPI twice in a row.
> > >
> > > [CC lkml, kexec mailing list, dave young]
> > >
> > > It is a fresh instance of kernel booting and it is initializing its data
> > > structures fresh. It is *not* re-initializing ACPI in same kernel.
> > >
> > >> > This patchset resolves the problem by adding a kernel parameter,
> > >> > no_memory_hotplug, to disable ACPI memory hotplug.  It can be added by default
> > >> > as a parameter to the kexec/kdump kernel so the kernel boots correctly.
> > >>
> > >> This problem is specific to kexec/kdump, so please don't add *generic* command
> > >> line parameters to address this.
> > >>
> > >
> > > There are other command line options to solve kdump problems. In general
> > > one might want to disable memory hogplug on the fly even if it is compiled
> > > in the kernel. So it can act as a good debugging aid.
> > >
> > > Secondly, it can be specified with memmap=exactmap and mem=X paramters to
> > > make sure no memory is hot added in the system.
> > >
> > > So I can see other usages of this parameter. To me it makes sense to have
> > > a separate command line option to disable memory hotplug feature on the
> > > fly.
> > 
> > I'm ok this option. But note, even if this option is specified, SH,
> > Power and S390 still
> > be able to use memory hotplug because their firmware are totally
> > different from ACPI.
> > 
> > Maybe, adding acpi prefix provides good clarification.
> 
> Makes sense. Something like "acpi_no_memhotplug" or "acpi_disable_memhotplug"
> or something else.

acpi_no_memhotplug would make more sense.

That said if you make memmap=exactmap disable the memhotplug driver, the
existing kexec/kdump users won't need to be updated.

Thanks,
Rafael


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708AbaAJBR5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 20:17:57 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:59757 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751988AbaAJBRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 20:17:55 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Prarit Bhargava <prarit@redhat.com>, linux-acpi@vger.kernel.org,
        Len Brown <lenb@kernel.org>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Dave Young <dyoung@redhat.com>,
        Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATCH] acpi memory hotplug, add parameter to disable memory hotplug for kexec
Date: Fri, 10 Jan 2014 02:31:31 +0100
Message-ID: <2117213.k9zFiTsMXU@vostro.rjw.lan>
User-Agent: KMail/4.11.3 (Linux/3.13.0-rc6+; KDE/4.11.3; x86_64; ; )
In-Reply-To: <20140109150053.GD25897@redhat.com>
References: <1389220181-14474-1-git-send-email-prarit@redhat.com> <3476878.EqQiEtA2Ag@vostro.rjw.lan> <20140109150053.GD25897@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, January 09, 2014 10:00:53 AM Vivek Goyal wrote:
> On Thu, Jan 09, 2014 at 12:00:29AM +0100, Rafael J. Wysocki wrote:
> 
> [..]
> > > The system then panics and the kdump/kexec kernel boots.  During this boot
> > > ACPi is initialized and the kernel (as can be seen above)
> > 
> > Which is a bug.  You're not supposed to initialize ACPI twice in a row.
> 
> [CC lkml, kexec mailing list, dave young]
> 
> It is a fresh instance of kernel booting and it is initializing its data
> structures fresh. It is *not* re-initializing ACPI in same kernel.

I know.  The problem is that the BIOS is generally not stateless and it
remebers stuff.  In particular, there are a few handshakes done during the ACPI
initialization and they cannot be repeated without resetting the BIOS to the
initial state, which basically means a reboot.

That is kind of orthogonal to the problem at hand, though.

> > > This patchset resolves the problem by adding a kernel parameter,
> > > no_memory_hotplug, to disable ACPI memory hotplug.  It can be added by default
> > > as a parameter to the kexec/kdump kernel so the kernel boots correctly.
> > 
> > This problem is specific to kexec/kdump, so please don't add *generic* command
> > line parameters to address this.
> > 
> 
> There are other command line options to solve kdump problems. In general
> one might want to disable memory hogplug on the fly even if it is compiled
> in the kernel. So it can act as a good debugging aid.
> 
> Secondly, it can be specified with memmap=exactmap and mem=X paramters to
> make sure no memory is hot added in the system.
> 
> So I can see other usages of this parameter. To me it makes sense to have
> a separate command line option to disable memory hotplug feature on the
> fly.

Well, if there are other uses, then fine.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751519AbaDOPch (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 11:32:37 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:51140 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750983AbaDOPcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 11:32:35 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Ingo Molnar <mingo@kernel.org>
Cc: Igor Mammedov <imammedo@redhat.com>, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        bp@suse.de, paul.gortmaker@windriver.com, JBeulich@suse.com,
        prarit@redhat.com, drjones@redhat.com, toshi.kani@hp.com,
        riel@redhat.com, gong.chen@linux.intel.com, andi@firstfloor.org,
        lenb@kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v4 3/5] acpi_processor: do not mark present at boot but not onlined CPU as onlined
Date: Tue, 15 Apr 2014 17:48:43 +0200
Message-ID: <5009829.NmJUThsPMn@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140415060411.GB29649@gmail.com>
References: <1397488277-14865-1-git-send-email-imammedo@redhat.com> <1612053.dzUdn6OW1L@vostro.rjw.lan> <20140415060411.GB29649@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 15, 2014 08:04:11 AM Ingo Molnar wrote:
> 
> * Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> 
> > On Monday, April 14, 2014 05:11:15 PM Igor Mammedov wrote:
> > > acpi_processor_add() assumes that present at boot CPUs
> > > are always onlined, it is not so if a CPU failed to become
> > > onlined. As result acpi_processor_add() will mark such CPU
> > > device as onlined in sysfs and following attempts to
> > > online/offline it using /sys/device/system/cpu/cpuX/online
> > > attribute will fail.
> > > 
> > > Do not poke into device internals in acpi_processor_add()
> > > and touch "struct device { .offline }" attribute, since
> > > for CPUs onlined at boot it's set by:
> > >   topology_init() -> arch_register_cpu() -> register_cpu()
> > > before ACPI device tree is parsed, and for hotplugged
> > > CPUs it's set when userspace onlines CPU via sysfs.
> > > 
> > > Signed-off-by: Igor Mammedov <imammedo@redhat.com>
> > > ---
> > > v2:
> > >  - fix regression in v1 leading to NULL pointer dereference
> > >    on CPU unplug, do not remove "pr->dev = dev;"
> > 
> > Yeah.
> > 
> > Does this patch depend on any other patches in the series?
> > 
> > I don't think so, but just asking.
> > 
> > If it doesn't, why is it part of this series at all?
> 
> I suspect because Igor was rigorously stress-testing CPU hotplug, and 
> was fixing all the bugs he saw, before adding the one feature he is 
> interested in.
> 
> The feature cannot be guaranteed to be correct, without having a 
> stable base to work on.
> 
> As such this series makes sense, as long as the fixes precede the 
> feature, and as long as the fixes are correct.
> 
> Consider it work in progress, with you being one of the reviewers who 
> makes sure the fixes are correct.

Fair enough.

So perhaps the subject of the whole series should be changed, because x86 is
not the only architecture affected by this particular patch?

Rafael


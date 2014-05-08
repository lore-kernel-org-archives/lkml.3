Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566AbaEHLQw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 07:16:52 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:49307 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753094AbaEHLQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 07:16:51 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Ingo Molnar <mingo@kernel.org>
Cc: Igor Mammedov <imammedo@redhat.com>, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        bp@suse.de, paul.gortmaker@windriver.com, JBeulich@suse.com,
        prarit@redhat.com, drjones@redhat.com, toshi.kani@hp.com,
        riel@redhat.com, gong.chen@linux.intel.com, andi@firstfloor.org,
        lenb@kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v5 2/4] acpi_processor: do not mark present at boot but not onlined CPU as onlined
Date: Thu, 08 May 2014 13:33:30 +0200
Message-ID: <2022136.gFLGQmut0v@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140508060935.GA31184@gmail.com>
References: <1399322991-19329-1-git-send-email-imammedo@redhat.com> <20310348.uigSpUyQCR@vostro.rjw.lan> <20140508060935.GA31184@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 08, 2014 08:09:35 AM Ingo Molnar wrote:
> 
> * Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> 
> > On Monday, May 05, 2014 10:49:49 PM Igor Mammedov wrote:
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
> > > Acked-by: Toshi Kani <toshi.kani@hp.com>
> > 
> > Would there be a problem if I applied this separately from the rest 
> > of the series?
> 
> If you push the fix upstream for v3.15 then it would be fine and I 
> could base the other patches on top of your (soon to be upstream) 
> commit.

OK, I can do that.

We also seem to need this in -stable, right?


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629AbaKMChp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 21:37:45 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:56330 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753372AbaKMCho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 21:37:44 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: "Zheng, Lv" <lv.zheng@intel.com>
Cc: "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "Brown, Len" <len.brown@intel.com>, Lv Zheng <zetalog@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Andi Kleen (ak@linux.intel.com)" <ak@linux.intel.com>
Subject: Re: [PATCH 5/6] ACPI/EC: Cleanup QR_SC command processing by adding a kernel thread to poll EC events.
Date: Thu, 13 Nov 2014 03:58:39 +0100
Message-ID: <1961414.bGx3EdA0yT@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1AE640813FDE7649BE1B193DEA596E88026A0706@SHSMSX101.ccr.corp.intel.com>
References: <cover.1414988981.git.lv.zheng@intel.com> <2277351.09XTT17U9b@vostro.rjw.lan> <1AE640813FDE7649BE1B193DEA596E88026A0706@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 13, 2014 02:31:08 AM Zheng, Lv wrote:
> Hi, Rafael
> 
> > From: Rafael J. Wysocki [mailto:rjw@rjwysocki.net]
> > Sent: Wednesday, November 12, 2014 9:17 AM

[cut]

> > > +
> > > +static int ec_create_event_poller(struct acpi_ec *ec)
> > > +{
> > > +	struct task_struct *t;
> > > +
> > > +	t = kthread_run(acpi_ec_event_poller, ec, "ec/gpe-%lu", ec->gpe);
> > 
> > Does it have to be a kernel thread?
> > 
> > What about using a workqueue instead?
> 
> Actually I just want to use threaded IRQ here in response to Andi Kleen's comment.
> If acpi_irq is registered as threaded IRQ, then acpi_ec_event_poller() will be the
> callback from it.

How so?

> Since ACPICA is not ready for threaded IRQ currently, we cannot proceed at this point.
> So I copied the threaded IRQ code from kernel/irq/manage.c here to prepare threaded IRQ logics.

Oh dear, no.

This isn't the way forward here.

> Using a separate work queue, we didn't decrease the kernel thread count.

Why does that matter at all?

> And the code written for the work item cannot be derived when things are
> switched to the threaded IRQ.
> So I used kthread here.

Please use a workqueue instead.  If/when we need to switch over to threaded
IRQs, we'll do the work then.  For now, let's not complicate things more
than necessary.

Rafael


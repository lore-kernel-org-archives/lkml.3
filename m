Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754211AbaIOQSS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 12:18:18 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:56646 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753310AbaIOQSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 12:18:14 -0400
MIME-Version: 1.0
In-Reply-To: <20140915155837.GR5387@tassilo.jf.intel.com>
References: <20140915143832.GA3264@quad>
	<20140915155837.GR5387@tassilo.jf.intel.com>
Date: Mon, 15 Sep 2014 18:18:13 +0200
Message-ID: <CABPqkBTDXmgWGZttLC31LidhhZ+DM_jzfyZ5+_2BowUj2KQWng@mail.gmail.com>
Subject: Re: [PATCH] perf/x86/uncore: update support for client uncore IMC PMU
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>, "Liang, Kan" <kan.liang@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2014 at 5:58 PM, Andi Kleen <ak@linux.intel.com> wrote:
>
> On Mon, Sep 15, 2014 at 04:38:32PM +0200, Stephane Eranian wrote:
> >
> > This patch restructures the memory controller (IMC) uncore
> > PMU support for client SNB/IVB/HSW processors. The main change
> > is that it can now cope with more than one PCI device ID per
> > processor model. There are many flavors of memory controllers
> > for each processor. They have different PCI device ID, yet
> > they behave the same w.r.t. the memory controller PMU that
> > we are interested in.
> >
> > The patch now supports two distinct memory controllers for IVB
> > processors: one for mobile, one for desktop.
>
> I haven't investigated yet, but on my Lenovo ULT Haswell laptop
> the IMC PCI-ID doesn't exist, so the driver doesn't initialize.
>
This updates makes it easier to add new PCI-IDs. I don't have all of
them. I don't have all the HW combinations.

>
> So either it's the BIOS disabling it, or it's a different ID there
> too.
>
I bet it is a different ID.
Now, this patch still has a PCI-ID table per-processor and not a global table.
I debated this for a while. But I don't know if a PCI-ID can be used
for something
else on another platform.


>
> BTW any reason you didn't enable the CBOX/ARB PMUs originally for HSW?
> At least ARB events are useful for some things.
>
I have never looked at the ARB events. If they work like on SNB/IVB, then they
should be easy to enable.

>
> -Andi

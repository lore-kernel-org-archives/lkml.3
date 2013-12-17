Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751522Ab3LQKm5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 05:42:57 -0500
Received: from mail-ee0-f54.google.com ([74.125.83.54]:44965 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966Ab3LQKm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 05:42:56 -0500
Date: Tue, 17 Dec 2013 11:42:51 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        ak@linux.intel.com, acme@redhat.com, jolsa@redhat.com,
        zheng.z.yan@intel.com, bp@alien8.de, vincent.weaver@maine.edu,
        maria.n.dimakopoulou@gmail.com
Subject: Re: [PATCH 2/2] perf/x86: add RAPL PP1 energy counter support
Message-ID: <20131217104251.GA27274@gmail.com>
References: <1387225224-27799-1-git-send-email-eranian@google.com>
 <1387225224-27799-3-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387225224-27799-3-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Nice patch!

I noticed a couple of small details:

* Stephane Eranian <eranian@google.com> wrote:

> Add support for the RAPL energy counter PP1.
> 
> On client processors, it usually correspondss to the

s/correspondss
 /corresponds

> energy consumption of the builtin graphic card.
> 
> New event:
> - name: power/energy-gfx/
> - code: event=0x4
> - unit: 2^-32 Joules
> 
> On processors without graphics, this should count 0.
> The patch only enables this event on client processors.

>  EVENT_ATTR_STR(energy-cores, rapl_cores, "event=0x01");
>  EVENT_ATTR_STR(energy-pkg  , rapl_pkg, "event=0x02");
>  EVENT_ATTR_STR(energy-ram  , rapl_ram, "event=0x03");
> +EVENT_ATTR_STR(energy-gfx, rapl_gfx, "event=0x04");

>  EVENT_ATTR_STR(energy-cores.unit, rapl_cores_unit, "Joules");
>  EVENT_ATTR_STR(energy-pkg.unit  , rapl_pkg_unit, "Joules");
>  EVENT_ATTR_STR(energy-ram.unit  , rapl_ram_unit, "Joules");
> +EVENT_ATTR_STR(energy-gfx.unit  , rapl_gfx_unit, "Joules");

Nit: I think these fields have all similar lengths so they should be 
vertically aligned, something like:

 EVENT_ATTR_STR(energy-cores, rapl_cores, "event=0x01");
 EVENT_ATTR_STR(energy-pkg  , rapl_pkg  , "event=0x02");
 EVENT_ATTR_STR(energy-ram  , rapl_ram  , "event=0x03");
 EVENT_ATTR_STR(energy-gfx  , rapl_gfx  , "event=0x04");

 EVENT_ATTR_STR(energy-cores.unit, rapl_cores_unit, "Joules");
 EVENT_ATTR_STR(energy-pkg.unit  , rapl_pkg_unit  , "Joules");
 EVENT_ATTR_STR(energy-ram.unit  , rapl_ram_unit  , "Joules");
 EVENT_ATTR_STR(energy-gfx.unit  , rapl_gfx_unit  , "Joules");

Also, instead of 'gfx', shouldn't it be 'gpu' throughout the patch?

Thanks,

	Ingo

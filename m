Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759458AbaCSXqX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 19:46:23 -0400
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:45664 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964AbaCSXqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 19:46:21 -0400
Date: Thu, 20 Mar 2014 01:44:55 +0200
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Raghu Gandham <Raghu.Gandham@imgtec.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: Re: [PATCH] Input: i8042-io - Exclude mips platforms when
 allocating/deallocating IO regions.
Message-ID: <20140319234455.GB19187@drone.musicnaut.iki.fi>
References: <1390676514-30880-1-git-send-email-raghu.gandham@imgtec.com>
 <20140126214952.GD18840@core.coreip.homeip.net>
 <E2EE47005FA75F44B80E1019FDD2EBBB6E38B06D@BADAG02.ba.imgtec.org>
 <20140127065638.GB11945@core.coreip.homeip.net>
 <20140127202435.GA589@drone.musicnaut.iki.fi>
 <E2EE47005FA75F44B80E1019FDD2EBBB6E394CB2@BADAG02.ba.imgtec.org>
 <20140319204931.GI17197@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140319204931.GI17197@linux-mips.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Mar 19, 2014 at 09:49:31PM +0100, Ralf Baechle wrote:
> I think the patch (http://patchwork.linux-mips.org/patch/6419/) should be
> applied.  The argumentation for reserving ports in the platform code are
> the same as on x86 - touch the registers and bad things may happen.  This
> is because a fair number of older MIPS platforms were based on x86 chipsets
> or at least are using very similar designs.

If you drop the request_region() from the driver, it will try to probe
anyway regardless what the platform code codes. So bad things could happen,
no?

Currently we can prevent i8042 driver from probing I/O space on PCI-less
Octeons (for example), because we define empty I/O space so request_region()
by driver will fail. So we can actually prevent bad things from happening.
I would call this good design, not an accident.

Maybe I'm missing something? Anyway, I don't have strong feelings whether
this patch is applied or not. My computers will keep on working on either
case.

A.

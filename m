Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514AbaCLQUA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 12:20:00 -0400
Received: from www.linutronix.de ([62.245.132.108]:43357 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754748AbaCLQT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 12:19:58 -0400
Date: Wed, 12 Mar 2014 17:20:02 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: joeyli <jlee@suse.com>
cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Julian Wollrath <jwollrath@web.de>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RESEND] Fast TSC calibration fails with v3.14-rc1 and later
In-Reply-To: <1394638899.26565.197.camel@linux-s257.site>
Message-ID: <alpine.DEB.2.02.1403121716540.18573@ionos.tec.linutronix.de>
References: <20140310110410.5b2218f6@ilfaris>  <1394596807.26565.135.camel@linux-s257.site>  <1902317.cSAIh6fs84@vostro.rjw.lan>  <53642014.xoKWERQIvL@vostro.rjw.lan> <1394638899.26565.197.camel@linux-s257.site>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Mar 2014, joeyli wrote:
> I think maybe still using ACPI_FADT_NO_CMOS_RTC to check does
> acpi_early_init() need run before timekeeping_init().
> If there have any future machine that applied ACPI TAD but "Fast TSC
> calibration" fail, at least the alternate TSC calibration can work
> around issue.

Well, it can work around, but it sucks as it's way slower than the
fast one. And we really don't want to pay that price for some half
baken ACPI nonsense.

Why exactly do you need that ACPI stuff before timekeeping_init()?

Thanks,

	tglx

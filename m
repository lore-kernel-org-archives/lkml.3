Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194Ab3EaT4Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 15:56:16 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:58868 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753294Ab3EaT4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 15:56:02 -0400
From: Kevin Hilman <khilman@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: Re: [PATCH RFC] PM / Runtime: Rework the "runtime idle" helper routine
References: <1463685.qFyr66vqF2@vostro.rjw.lan>
Date: Fri, 31 May 2013 12:55:56 -0700
In-Reply-To: <1463685.qFyr66vqF2@vostro.rjw.lan> (Rafael J. Wysocki's message
	of "Wed, 29 May 2013 01:29:06 +0200")
Message-ID: <87r4gmyldf.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>
> The "runtime idle" helper routine, rpm_idle(), currently ignores
> return values from .runtime_idle() callbacks executed by it.
>
> However, it turns out that many subsystems use the generic idle
> callback routine pm_generic_runtime_idle() which checks the return
> value of the driver's callback and executes pm_runtime_suspend() for
> the device unless that value is different from 0.  If that logic is
> moved to rpm_idle() instead, pm_generic_runtime_idle() can be dropped
> and its users will not need any .runtime_idle() callbacks any more.
>
> Moreover, the PCI subsystem's .runtime_idle() routine,
> pci_pm_runtime_idle(), works in analogy with the generic one and if
> rpm_idle() calls rpm_suspend() after 0 has been returned by the
> .runtime_idle() callback executed by it, that routine will not be
> necessary any more and may be dropped.
>
> To reduce overall code duplication make the changes described above.
>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Acked-by: Kevin Hilman <khilman@linaro.org>
Tested-by: Kevin Hilman <khilman@linaro.org> # for OMAP PM domain change


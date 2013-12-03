Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145Ab3LCQwg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 11:52:36 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:53372 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766Ab3LCQwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 11:52:31 -0500
Date: Tue, 3 Dec 2013 16:51:40 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Hanjun Guo <hanjun.guo@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Daniel Lezcano <daniel.lezcano@linaro.org>, linux-acpi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@linaro.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Olof Johansson <olof@lixom.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Jon Masters <jonathan@jonmasters.org>, patches@linaro.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        linaro-acpi@lists.linaro.org,
        Graeme Gregory <graeme.gregory@linaro.org>
Subject: Re: [RFC part1 PATCH 3/7] ACPI / processor_core: Rework _PDC
 related stuff to make it more arch-independent
Message-ID: <20131203165140.24a05540@alan.etchedpixels.co.uk>
In-Reply-To: <1386088611-2801-4-git-send-email-hanjun.guo@linaro.org>
References: <1386088611-2801-1-git-send-email-hanjun.guo@linaro.org>
	<1386088611-2801-4-git-send-email-hanjun.guo@linaro.org>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  4 Dec 2013 00:36:47 +0800
Hanjun Guo <hanjun.guo@linaro.org> wrote:

> _PDC related stuff in processor_core.c is little bit X86/IA64 dependent,
> rework the code to make it more arch-independent.
> 
> The return value of acpi_processor_eval_pdc() should be 'acpi_status' but
> defined as 'int', fix it too.

Why not just define boot_options_idle_override as well. Then you can
leave the code unchanged. Also more importantly you can have override
values for ARM when it turns out you need those too and the logic will be
the same for both processor families

Alan

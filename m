Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895AbbAVIRu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 03:17:50 -0500
Received: from mail-ig0-f177.google.com ([209.85.213.177]:45279 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbbAVIRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 03:17:40 -0500
MIME-Version: 1.0
In-Reply-To: <4078818.ecVtLF3hjd@vostro.rjw.lan>
References: <1418890998-23811-1-git-send-email-heikki.krogerus@linux.intel.com>
	<CAAVeFuJUxad0dJ9vK1DaDJPDLM+rc5b77=PgcJT5+Bv1=iWGxg@mail.gmail.com>
	<CACRpkdZzCX0O1wX=W5RbjLcqOF_R3HMTT1w59oFu=JfPauLNuw@mail.gmail.com>
	<4078818.ecVtLF3hjd@vostro.rjw.lan>
Date: Thu, 22 Jan 2015 09:17:38 +0100
Message-ID: <CACRpkdZpUU71suzt9JhiBZez2VuJ6-Zm3D1uvmn71bjdn=oU_A@mail.gmail.com>
Subject: Re: [RFC PATCH] gpio: support for GPIO forwarding
From: Linus Walleij <linus.walleij@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Darren Hart <dvhart@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 10:25 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:

> Yes, it can (in principle).  In fact, we have a plan to refine it, but it is
> going to take some time.  Once we've done that, we'll see how painful it is to
> "patch" ACPI tables this way in practice.
>
> Also there is an ecosystem problem related to distributing such "patches".
> Today, distributions don't need to worry about patching buggy platform
> firmware, because they get workarounds in the kernel, but if we switch over
> to the model in which platform firmware "overlays" need to be provided in
> addition to it, then suddenly questions arise about who should be responsible
> for making them available, how to avoid duplication of efforts between
> distributions etc.
>
> All of that needs to be clarified before we start making hard statements like
> "No in-kernel workarounds for that!"

OK so why can't the patching happen in the kernel?

If the kernel anyway has to supply some kind of workaround for
the issue, it is more a question of where to place it. Whether it does
so by patching the ACPI tables or by detecting a bad ACPI thing
and working around it at runtime in a certain driver doesn't really
matter, does it? They are both in-kernel ACPI fixes, just that one
of the mechanisms is generic.

I don't understand why this obsession with userspace having
to do the ACPI table patching - if kernels should "just work" then
put this stuff behind Kconfig and have it in the kernel.

Yours,
Linus Walleij

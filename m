Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170Ab3JKBnA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 21:43:00 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:62995 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754904Ab3JKBm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 21:42:58 -0400
MIME-Version: 1.0
In-Reply-To: <18685640.N2BnVjDmHD@vostro.rjw.lan>
References: <20131010165905.7815defa@gandalf.local.home>
	<CA+55aFwA8WZ+ARtNFFY+z4d8kS5AUBLg32iu7Jkk3rsz_i1OZw@mail.gmail.com>
	<2679976.SxBsymIdoJ@vostro.rjw.lan>
	<18685640.N2BnVjDmHD@vostro.rjw.lan>
Date: Thu, 10 Oct 2013 18:42:56 -0700
X-Google-Sender-Auth: R31rjfUaDK8kYVxo0B5jAGs7WhU
Message-ID: <CA+55aFwqf7kkh0dy6AhCvB87XYkQ03YUpsYEDJmnkiRe8GQfMQ@mail.gmail.com>
Subject: Re: [BUG] WARN_ON(!context) in drivers/pci/hotplug/acpiphp_glue.c
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 6:45 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
>
>         /* Register slots for ejectable funtions only. */
> -       if (acpi_pci_check_ejectable(pbus, handle)  || is_dock_device(handle)) {
> +       if ((acpi_pci_check_ejectable(pbus, handle) || is_dock_device(handle))
> +           && !(pdev && device_is_managed_by_native_pciehp(pdev))) {
>                 unsigned long long sun;
>                 int retval;

I can't even begin to say whether this is a good solution or not,
because that if-conditional makes me want to go out and kill some
homeless people to let my aggressions out.

Can we please agree to *never* write code like this? Ever?

Use a well-named inline helper function where the name describes what
the f*ck the code is trying to do, and then comment the separate
issues. Because none of the above line noise makes me go "Ahh, it's
the test for an ejectable function".

What the heck _is_ an "ejectable function" anyway? The only comment
there just makes the code even less sensible.

Please?

                Linus

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756324Ab3JKRVl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 13:21:41 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:49619 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497Ab3JKRVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 13:21:37 -0400
MIME-Version: 1.0
In-Reply-To: <2096980.ZtIelfoX39@vostro.rjw.lan>
References: <20131010165905.7815defa@gandalf.local.home>
	<18685640.N2BnVjDmHD@vostro.rjw.lan>
	<CA+55aFwqf7kkh0dy6AhCvB87XYkQ03YUpsYEDJmnkiRe8GQfMQ@mail.gmail.com>
	<2096980.ZtIelfoX39@vostro.rjw.lan>
Date: Fri, 11 Oct 2013 10:21:35 -0700
X-Google-Sender-Auth: QoPayyCzt2s4dRUyWcylxlCxCFM
Message-ID: <CA+55aFyJL5gLGtg8-z1t1xSY1ih9MAzsDzMZaxrEYZOFZ7rRBw@mail.gmail.com>
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

On Fri, Oct 11, 2013 at 4:13 AM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> +/**
> + * slot_should_be_exposed - Check whether or not to expose a slot to userland.
> + * @bridge: ACPIPHP bridge the slot belongs to.
> + * @handle: ACPI handle of a device in the slot.
> + */
> +static inline bool slot_should_be_exposed(struct acpiphp_bridge *bridge,
> +                                         acpi_handle handle)

Thanks, that looks much better.

I do worry that we now seem to add the slot to all the acpiphp lists
even if it is managed by pciehp. That gets rid of the warning Steven
saw (because now it always has that context), but I'm left wondering
how much pcihp and aciphp will fight over the slot.

Yes, the acpiphp_register_hotplug_slot() doesn't get called, but we
still do register_hotplug_dock_device(), for example. How does that
interact with pcihp that thinks it owns the slot?

Or am I misreading the code? It's more readable, and no longer makes
me homicidal, but I don't actually know the code itself.

             Linus

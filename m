Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757588Ab3JJVSE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 17:18:04 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:58602 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757552Ab3JJVR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 17:17:59 -0400
MIME-Version: 1.0
In-Reply-To: <20131010165905.7815defa@gandalf.local.home>
References: <20131010165905.7815defa@gandalf.local.home>
Date: Thu, 10 Oct 2013 14:17:58 -0700
X-Google-Sender-Auth: e1puR2tbH0uEgvArlpOnRWyUzEs
Message-ID: <CA+55aFxTwBoeQOimg-ut+BipWx2veNOPT0yGvFBFn7nbX5yCkg@mail.gmail.com>
Subject: Re: [BUG] WARN_ON(!context) in drivers/pci/hotplug/acpiphp_glue.c
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 1:59 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> Unfortunately it's not a single commit. I tried to bisect it better,
> but it really is the merge. I'm thinking a chance in one merge caused
> the WARN_ON() to trigger that was added in a later merge.

That looks a bit unlikely. The whole acpiphp_init/get/put_context()
logic is entirely internal to drivers/pci/hotplug/acpiphp_glue.c, and
that merge gets absolutely all the changes from one side, except for a
one-liner change to that file that looks entirely unrelated (commit
928bea964827 "PCI: Delay enabling bridges until they're needed").

That said, that one commit did cause other problems (see commit
f41f064cf435: "PCI: Workaround missing pci_set_master in pci
drivers"), so who knows. Some subtle interaction with exactly when the
hotplug functions end up being called?

But it could possibly be timing-related too. Does everything behind
that hp bridge still work?

                Linus

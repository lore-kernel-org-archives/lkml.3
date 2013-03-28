Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827Ab3C1Mwo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 08:52:44 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:41082 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755596Ab3C1Mwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 08:52:38 -0400
MIME-Version: 1.0
In-Reply-To: <1364444885-19751-2-git-send-email-yinghai@kernel.org>
References: <1364444885-19751-1-git-send-email-yinghai@kernel.org> <1364444885-19751-2-git-send-email-yinghai@kernel.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 28 Mar 2013 06:52:17 -0600
Message-ID: <CAErSpo7UYk5q2BPcS4xX06S3qwjK-XRw2LTgOUEiDqwNeAWNgQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] eisa, PCI: Fix bus res reference
To: Yinghai Lu <yinghai@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Whitehead <mwhitehe@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 10:28 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> Matthem found that 3.8.3 is having problems with an old (ancient)
> PCI-to-EISA bridge, the Intel 82375. It worked with the 3.2 kernel.
> He identified the 82375, but doesn't assign the struct resource *res
> pointer inside the struct eisa_root_device, and panics.
>
> After looking at pci_eisa_init(), found it referring bus resource
> directly instead of pci_bus_resource_n().
>
> After commit 45ca9e97 (PCI: add helpers for building PCI bus resource lists)
> and commit 0efd5aab (PCI: add struct pci_host_bridge_window with CPU/bus
> address offset), bus->resource[] is not used for pci root bus any more.
>
> Fix it by using pci_bus_resource_n() and correct idx for root bus.

Please include URLs for the problem reports for these problems
(bugzilla or mailing list discussion).

> Reported-by: Matthew Whitehead <mwhitehe@redhat.com>
> Tested-by: Matthew Whitehead <mwhitehe@redhat.com>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Cc: stable@kernel.org

You are consistently using the wrong stable email address.  It should
be "stable@vger.kernel.org".  I assume you see a bounce every time; at
least, I get a bounce when I reply to your messages.

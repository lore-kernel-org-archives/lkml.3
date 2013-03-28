Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240Ab3C1PQH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 11:16:07 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:39285 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755605Ab3C1PQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 11:16:05 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo7UYk5q2BPcS4xX06S3qwjK-XRw2LTgOUEiDqwNeAWNgQ@mail.gmail.com>
References: <1364444885-19751-1-git-send-email-yinghai@kernel.org>
	<1364444885-19751-2-git-send-email-yinghai@kernel.org>
	<CAErSpo7UYk5q2BPcS4xX06S3qwjK-XRw2LTgOUEiDqwNeAWNgQ@mail.gmail.com>
Date: Thu, 28 Mar 2013 08:16:05 -0700
X-Google-Sender-Auth: oeCg6-x4wrme6Tb_NzQTim3bA6U
Message-ID: <CAE9FiQVLXrxjvF7zFfcx96ey+QwxX=qJEXR=BGuTCZeANigz9A@mail.gmail.com>
Subject: Re: [PATCH 1/2] eisa, PCI: Fix bus res reference
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Whitehead <mwhitehe@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 28, 2013 at 5:52 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Wed, Mar 27, 2013 at 10:28 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> Matthem found that 3.8.3 is having problems with an old (ancient)
>> PCI-to-EISA bridge, the Intel 82375. It worked with the 3.2 kernel.
>> He identified the 82375, but doesn't assign the struct resource *res
>> pointer inside the struct eisa_root_device, and panics.
>>
>> After looking at pci_eisa_init(), found it referring bus resource
>> directly instead of pci_bus_resource_n().
>>
>> After commit 45ca9e97 (PCI: add helpers for building PCI bus resource lists)
>> and commit 0efd5aab (PCI: add struct pci_host_bridge_window with CPU/bus
>> address offset), bus->resource[] is not used for pci root bus any more.
>>
>> Fix it by using pci_bus_resource_n() and correct idx for root bus.
>
> Please include URLs for the problem reports for these problems
> (bugzilla or mailing list discussion).

Matthew sent private mail to me, and I sent him test patch to see
if it fixes the problem. then I posted patches here after that.

>
>> Reported-by: Matthew Whitehead <mwhitehe@redhat.com>
>> Tested-by: Matthew Whitehead <mwhitehe@redhat.com>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>> Cc: stable@kernel.org
>
> You are consistently using the wrong stable email address.  It should
> be "stable@vger.kernel.org".  I assume you see a bounce every time; at
> least, I get a bounce when I reply to your messages.

I thought that is tag only, and stable maintainer  will search that from
Linus's tree.
but git send-mail will pick up Cc from the patch.

So stable@kernel.org will never get fixed?

Yinghai

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758314AbaGASf6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 14:35:58 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:57558 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932288AbaGASf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 14:35:56 -0400
MIME-Version: 1.0
In-Reply-To: <20140630224709.GA22024@google.com>
References: <1402346730-2508-1-git-send-email-andreas.noever@gmail.com>
	<20140617221620.GC30559@google.com>
	<CAE9FiQXD7hvt0cUYMzvq0r6CbZn=iJZc7BHRaF2nACbG7qwuBQ@mail.gmail.com>
	<CAMxnaaWWuNeNbnUe++N=2bBfs5JyKiq7tHH+_kiQZyQ9aakEHg@mail.gmail.com>
	<CAE9FiQVQ657vDOhdhBq5VC044qt6TUF7FKP_-qy+35g71e56Yg@mail.gmail.com>
	<20140630224709.GA22024@google.com>
Date: Tue, 1 Jul 2014 11:35:56 -0700
X-Google-Sender-Auth: qt3s5LPaSSIwRPLd5laiUZCP9SE
Message-ID: <CAE9FiQWzFP_6AU1hLwKKxD2tu+OPjwXfQbLwW-yNT6pCW7JJZA@mail.gmail.com>
Subject: Re: [PATCH] PCI: Do not touch siblings in pci_assign_unassigned_bridge_resources
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Andreas Noever <andreas.noever@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2014 at 3:47 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> Should not be dangerous, just second try.
>
> I still don't understand this.  Why do we set "res->flags = 0"?  That
> clears out the resource type.  Where do we figure out the type of "res"
> again?

pci_bridge_check_ranges()

>> Subject: [PATCH] pci: Add back missing MEM_64 check for hotplug path
>>
>> We miss that in
>> |  commit 5b28541552ef5eeffc41d6936105f38c2508e566
>> |    PCI: Restrict 64-bit prefetchable bridge windows to 64-bit resources
>> for pci hotplug path.
>
> This changelog is useless.  I don't have time to spend a few hours
> figuring out why we want this change.

We have MEM_64 in type_mask from pci_assign_unassigned_root_bus_resources().
And I missed the same change for hotplug path.


That is for exact type checking.

Thanks

Yinghai

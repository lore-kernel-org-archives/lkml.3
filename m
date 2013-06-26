Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751795Ab3FZHiS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 03:38:18 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:36995 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166Ab3FZHiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 03:38:17 -0400
MIME-Version: 1.0
In-Reply-To: <20130625211516.GA8494@google.com>
References: <1370066593-22736-1-git-send-email-yinghai@kernel.org>
	<1370066593-22736-3-git-send-email-yinghai@kernel.org>
	<20130625211516.GA8494@google.com>
Date: Wed, 26 Jun 2013 00:38:17 -0700
X-Google-Sender-Auth: PfLol9QfkDotnWrXCIASmm0uppI
Message-ID: <CAE9FiQWfmr+nDb8CH7OBiZFypStQyg_91E-6NWez0SdrPweewg@mail.gmail.com>
Subject: Re: [PATCH v5 3/7] PCI: Use pci_walk_bus to detect unassigned resources
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Gavin Shan <shangw@linux.vnet.ibm.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 2:15 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> +static int __init check_unassigned_resources(struct pci_dev *dev, void *data)
>
> I'm not going to add a function named "check_*()" because the name gives no
> clue about what the return value means.  If it's a boolean function, the
> name should be something like a question that has a yes/no answer.

that prototype return int is required by pci_walk_bus().

drivers/pci/bus.c:void pci_walk_bus(struct pci_bus *top, int
(*cb)(struct pci_dev *, void *)

return 1, will return early from pci_walk_bus().

count_unassigned_resources() is not good name too, as we bail out early.
find_unassigned_resources() is more weird, looks like it want to return resource

Yinghai

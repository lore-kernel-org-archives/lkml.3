Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756431Ab3C1Hlo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 03:41:44 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:63063 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755696Ab3C1Hll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 03:41:41 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo6v0mj9=Q13d=G4hho0mb9XTcsmefzke9fROYmZ7oBWxQ@mail.gmail.com>
References: <CAE9FiQXmeb66dc8fET0y99BjqpUXp11c7utiQ5keR1Wf+N9xaA@mail.gmail.com>
	<1363628226-6679-1-git-send-email-yinghai@kernel.org>
	<CAErSpo6v0mj9=Q13d=G4hho0mb9XTcsmefzke9fROYmZ7oBWxQ@mail.gmail.com>
Date: Thu, 28 Mar 2013 00:41:40 -0700
X-Google-Sender-Auth: 46jrIGvceX3ZutR6raquzsUnF_c
Message-ID: <CAE9FiQU7cDzJdHxmqhJNgc9UCsRLgvCFQpv8+fLxD79pLEUC5A@mail.gmail.com>
Subject: Re: [PATCH] PCI: Remove not needed check in disable aspm link
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>, stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 3:56 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>
> Why can't we set all the ASPM flags *first*, before calling
> pci_acpi_scan_root()?  That way we could just do the correct ASPM
> setup as we discover devices during enumeration, rather than trying to
> fix things up afterwards.  I suspect pcie_clear_aspm() is broken
> anyway, because it looks like it only touches one level of the
> hierarchy, without recursively descending it.

Yes, we can clean up aspm stop/clear up.
and that should be for 3.10 right?

But this patch should be safe for 3.9 and stable.

Thanks

Yinghai

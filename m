Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800AbaGNRVG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 13:21:06 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:39174 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717AbaGNRUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 13:20:53 -0400
MIME-Version: 1.0
In-Reply-To: <CAODwPW9FORb2jnxFi6US6CUJvJzKyUkT8cuSzkPues41hJe+Jw@mail.gmail.com>
References: <1404954350-26343-1-git-send-email-abrestic@chromium.org>
	<1404954350-26343-5-git-send-email-abrestic@chromium.org>
	<CAODwPW9FORb2jnxFi6US6CUJvJzKyUkT8cuSzkPues41hJe+Jw@mail.gmail.com>
Date: Mon, 14 Jul 2014 10:20:52 -0700
X-Google-Sender-Auth: H-VY0acQSK5KpALwO2hhB8Ex79k
Message-ID: <CAL1qeaGCLw0LSE_Oy_VteAyWLHS9D4y-U8+6Mu+cGKEUp3T3GQ@mail.gmail.com>
Subject: Re: [PATCH 4/4] xhci: Allow xHCI drivers to be built as separate modules
From: Andrew Bresticker <abrestic@chromium.org>
To: Julius Werner <jwerner@chromium.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2014 at 11:34 AM, Julius Werner <jwerner@chromium.org> wrote:
>> diff --git a/drivers/usb/host/Makefile b/drivers/usb/host/Makefile
>> index af89a90..bafba71 100644
>> --- a/drivers/usb/host/Makefile
>> +++ b/drivers/usb/host/Makefile
>> @@ -15,19 +15,19 @@ fhci-$(CONFIG_FHCI_DEBUG) += fhci-dbg.o
>>  xhci-hcd-y := xhci.o xhci-mem.o
>>  xhci-hcd-y += xhci-ring.o xhci-hub.o xhci-dbg.o
>>  xhci-hcd-y += xhci-trace.o
>> -xhci-hcd-$(CONFIG_PCI) += xhci-pci.o
>>
>> -ifneq ($(CONFIG_USB_XHCI_PLATFORM), )
>> -       xhci-hcd-y              += xhci-plat.o
>> +xhci-plat-hcd-y := xhci-plat.o
>>  ifneq ($(CONFIG_USB_XHCI_MVEBU), )
>> -       xhci-hcd-y              += xhci-mvebu.o
>> -endif
>
> nit: Can do this even simpler now, just
> "xhci-plat-hcd-$(CONFIG_USB_XHCI_MVEBU) += xhci-mvebu.o" without the
> ifneq.

Nope - since CONFIG_USB_XHCI_MVEBU can be 'y' or 'm' we need the ifneq
here (which matches against both) to ensure xhci-mvebu.o is built is
part of xhci-plat-hcd.o.

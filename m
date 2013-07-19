Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752973Ab3GSVhs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 17:37:48 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:58651 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294Ab3GSVhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 17:37:46 -0400
MIME-Version: 1.0
In-Reply-To: <1373987681-18245-1-git-send-email-abbotti@mev.co.uk>
References: <1373987681-18245-1-git-send-email-abbotti@mev.co.uk>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 19 Jul 2013 15:37:26 -0600
Message-ID: <CAErSpo4daNsF0BTJhqdZ0hrBpS+EQ3Z1_-C_LN=ec9fLafNkog@mail.gmail.com>
Subject: Re: [PATCH 0/4] pci_ids, 8250_pci: remove PCI_VENDOR_ID_ADDIDATA_OLD
To: Ian Abbott <abbotti@mev.co.uk>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        linux-serial@vger.kernel.org, driverdev-devel@linuxdriverproject.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        H Hartley Sweeten <hsweeten@visionengravers.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 9:14 AM, Ian Abbott <abbotti@mev.co.uk> wrote:
> The 8250_pci driver uses PCI_VENDOR_ID_ADDIDATA_OLD (0x10e8),
> PCI_DEVICE_ID_ADDIDATA_APCI7800 (0x818e) to recognize the original
> ADDI-DATA APCI-7800 PCI serial card.  However vendor ID 0x10e8 was
> assigned by PCI-SIG to Applied Micro Circuits Corporation (AMCC) and the
> associated device ID 0x818e was assigned by AMCC to ADDI-DATA.
>
> Comedi already defines PCI_VENDOR_ID_AMCC as 0x10e8 in one of its header
> files, so that definition can be moved into pci_ids.h and the 8250_pci
> driver changed to use it.  The PCI_DEVICE_ID_ADDIDATA_APCI7800 define
> seems out of place in pci_ids.h since it isn't associated with
> ADDI-DATA's vendor ID but with AMCC's vendor ID.  It's only used in
> 8250_pci.c so it can be moved there and renamed to something more
> sensible.
>
> 1) pci_ids.h: move PCI_VENDOR_ID_AMCC here
> 2) serial: 8250_pci: replace PCI_VENDOR_ID_ADDIDATA_OLD
> 3) serial: 8250_pci: use local device ID for ADDI-DATA APCI-7800
> 4) pci_ids.h: remove PCI_VENDOR_ID_ADDIDATA_OLD and
>    PCI_DEVICE_ID_ADDIDATA_APCI7800
>
>  drivers/staging/comedi/comedidev.h | 1 -
>  drivers/tty/serial/8250/8250_pci.c | 9 +++++----
>  include/linux/pci_ids.h            | 4 ++--
>  3 files changed, 7 insertions(+), 7 deletions(-)

For patches 1 & 4 (the ones that touch pci_ids.h):

Acked-by: Bjorn Helgaas <bhelgaas@google.com>

Please merge them along with the 8250 changes.

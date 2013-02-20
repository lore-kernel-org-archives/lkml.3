Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758885Ab3BTQ5a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 11:57:30 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:36904 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182Ab3BTQ52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 11:57:28 -0500
MIME-Version: 1.0
In-Reply-To: <5124820D.2080900@suse.de>
References: <1361182193-31894-1-git-send-email-hare@suse.de>
	<CAE9FiQWP1F5mLUoHoTHXy-wQoGxVK66QuuHYydaq3YfysS5Etg@mail.gmail.com>
	<5124820D.2080900@suse.de>
Date: Wed, 20 Feb 2013 08:57:27 -0800
X-Google-Sender-Auth: Axj00nfMSGnK9DkoVJamFer33W0
Message-ID: <CAE9FiQXHteymDNzu0GqWtVSVhu3g2hCT+K9e5tB1mR-OBX1ffA@mail.gmail.com>
Subject: Re: [PATCH] pci: do not try to assign irq 255
From: Yinghai Lu <yinghai@kernel.org>
To: Hannes Reinecke <hare@suse.de>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        Frederik Himpe <fhimpe@vub.ac.be>, Oliver Neukum <oneukum@suse.de>,
        David Haerdeman <david@hardeman.nu>, linux-usb@vger.kernel.org,
        linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2013 at 11:58 PM, Hannes Reinecke <hare@suse.de> wrote:
>>
> Apparently this device is meant to use MSI _only_ so the BIOS developer
> didn't feel the need to assign an INTx here.
>
> According to PCI-3.0, section 6.8 (Message Signalled Interrupts):
>> It is recommended that devices implement interrupt pins to
>> provide compatibility in systems that do not support MSI
>> (devices default to interrupt pins). However, it is expected
>> that the need for interrupt pins will diminish over time.
>> Devices that do not support interrupt pins due to pin
>> constraints (rely on polling for device service) may implement
>> messages to increase performance without adding additional pins. >
>> Therefore, system configuration software must not assume that a
>> message capable device has an interrupt pin.
>
> Which sounds to me as if the implementation is valid...

it seems you mess pin with interrupt line.

current code:
        unsigned char irq;

        pci_read_config_byte(dev, PCI_INTERRUPT_PIN, &irq);
        dev->pin = irq;
        if (irq)
                pci_read_config_byte(dev, PCI_INTERRUPT_LINE, &irq);
        dev->irq = irq;

so if the device does not have interrupt pin implemented, pin should be zero.
and  pin and irq in dev should
be all 0.

Thanks

Yinghai

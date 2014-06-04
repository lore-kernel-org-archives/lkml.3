Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932701AbaFDGWw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 02:22:52 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:63813 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932426AbaFDGWv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 02:22:51 -0400
MIME-Version: 1.0
In-Reply-To: <20140604032533.GA22469@roeck-us.net>
References: <20140603225502.F1C5122C07D5@bs320.sjc.aristanetworks.com>
	<20140603232100.GA15247@kroah.com>
	<20140604032533.GA22469@roeck-us.net>
Date: Tue, 3 Jun 2014 23:22:50 -0700
Message-ID: <CA+HUmGgGuWbg8drsRYKN=OAD_WPYOjRh9tAZ0EXky1KNoVGa5Q@mail.gmail.com>
Subject: Re: pci: kernel crash in bus_find_device
From: Francesco Ruggeri <fruggeri@arista.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Francesco Ruggeri <fruggeri@aristanetworks.com>,
        linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>
> Look for callers of bus_find_device. Unless I am missing something, only pci
> and scsi code call it with non-NULL 'start' argument, and the scsi use is
> limited to a walk through scsi devices for a proc file.
>
> Makes me wonder if the start argument should go away, and if pci and scsi
> should use another means to walk through devices.

I think that would be the correct approach.
In case of pci all functions using pci_get_device, pci_get_subsys or
pci_get_class (which call pci_get_dev_by_id/bus_find_device) to
iterate over the whole list using a non-NULL start argument would have
to be audited.
There seem to be quite a few of them using loops of the kind
while ((dev = pci_get_device( …, dev)) != NULL)
(and similarly for pci_get_subsys and pci_get_class) and they could
all be vulnerable if they try to resume their search from a device
that was unregistered.

Francesco


>
> Guenter

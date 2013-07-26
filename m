Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759592Ab3GZUPG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 16:15:06 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:57910 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753594Ab3GZUPD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 16:15:03 -0400
MIME-Version: 1.0
In-Reply-To: <51F2D427.7050106@linutronix.de>
References: <1374516607-2705-1-git-send-email-bigeasy@linutronix.de>
	<1374516607-2705-15-git-send-email-bigeasy@linutronix.de>
	<CADYTM3a5xzs+-VCTeKLGiRjo7JOqOJ5H4EWDACpTMovY5_ooRA@mail.gmail.com>
	<51EEBE05.2040000@linutronix.de>
	<CADYTM3ZfvDDKY6NyAv9xGSZ0angGYVOGf8uUDR2vU1jDwCGmzA@mail.gmail.com>
	<20130726163101.GB29819@linutronix.de>
	<CADYTM3bfkxEYgvk5v_0=BJFMb8izULpgc1uZVPDPnSs29UpYeA@mail.gmail.com>
	<CADYTM3b7-WHA73qMypUSd8VcTWuvooap_Ki65BcoJ7qKhejXZw@mail.gmail.com>
	<51F2BE6F.3010008@linutronix.de>
	<CADYTM3Y5p-ysgbcL4qZMWLiRVbcPgNQgtydpdhYQJLtd+r1hfw@mail.gmail.com>
	<51F2D427.7050106@linutronix.de>
Date: Fri, 26 Jul 2013 15:15:02 -0500
Message-ID: <CADYTM3ZAsBuFi2guX-j+0f837Uy4EkZ0_QEhKV+WWUOsaDfaDQ@mail.gmail.com>
Subject: Re: [PATCH 14/16] usb: musb: dsps: add MUSB_DEVCTL_SESSION back after removal
From: Bin Liu <binmlist@gmail.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, balbi@ti.com,
        george.cherian@ti.com
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sebastian,

On Fri, Jul 26, 2013 at 2:55 PM, Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
> The bit is removed in otg_timer() because the phy gets into
> OTG_STATE_A_WAIT_BCON.
>
> Now, this is current HEAD + my stuff to get second port working. I
> downloaded v3.2 and browsed as I was looking for the workaround, never
> tested maybe I should…
>
> On v3.8 from git://git.ti.com/ti-linux-kernel/ti-linux-kernel.git I
> don't get the second port to work. I see
>
> [    1.989101] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
> [    1.996361] usb usb1: New USB device strings: Mfr=3, Product=2,
> SerialNumber=1
> [    2.004060] usb usb1: Product: MUSB HDRC host driver
> [    2.009363] usb usb1: Manufacturer: Linux 3.8.13+ musb-hcd
> [    2.015183] usb usb1: SerialNumber: musb-hdrc.0.auto
> [    2.033653] hub 1-0:1.0: USB hub found
> [    2.037861] hub 1-0:1.0: 1 port detected
>
> and nothing happens once I plug in the device.

I started thinking when I tried this git.ti.com 3.8 kernel, I might
have done 'devmem2 0x47401c60 b 0x81' to manually set the SESSION bit
after plugged a device. It was months ago, I don't quite remember what
I tested.

My build server is down this afternoon. Once it comes back next week,
I will try 3.8 again, to see how I can help on this USB1 host mode
issue. its devctl register should stay on 0x19 even nothing is
connected.

>
> Sebastian

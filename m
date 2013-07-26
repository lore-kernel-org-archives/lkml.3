Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759617Ab3GZTzY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 15:55:24 -0400
Received: from www.linutronix.de ([62.245.132.108]:38858 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477Ab3GZTzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 15:55:22 -0400
Message-ID: <51F2D427.7050106@linutronix.de>
Date: Fri, 26 Jul 2013 21:55:19 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130630 Icedove/17.0.7
MIME-Version: 1.0
To: Bin Liu <binmlist@gmail.com>
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, balbi@ti.com,
        george.cherian@ti.com
Subject: Re: [PATCH 14/16] usb: musb: dsps: add MUSB_DEVCTL_SESSION back after
 removal
References: <1374516607-2705-1-git-send-email-bigeasy@linutronix.de> <1374516607-2705-15-git-send-email-bigeasy@linutronix.de> <CADYTM3a5xzs+-VCTeKLGiRjo7JOqOJ5H4EWDACpTMovY5_ooRA@mail.gmail.com> <51EEBE05.2040000@linutronix.de> <CADYTM3ZfvDDKY6NyAv9xGSZ0angGYVOGf8uUDR2vU1jDwCGmzA@mail.gmail.com> <20130726163101.GB29819@linutronix.de> <CADYTM3bfkxEYgvk5v_0=BJFMb8izULpgc1uZVPDPnSs29UpYeA@mail.gmail.com> <CADYTM3b7-WHA73qMypUSd8VcTWuvooap_Ki65BcoJ7qKhejXZw@mail.gmail.com> <51F2BE6F.3010008@linutronix.de> <CADYTM3Y5p-ysgbcL4qZMWLiRVbcPgNQgtydpdhYQJLtd+r1hfw@mail.gmail.com>
In-Reply-To: <CADYTM3Y5p-ysgbcL4qZMWLiRVbcPgNQgtydpdhYQJLtd+r1hfw@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2013 08:29 PM, Bin Liu wrote:

Hi Bin,

>> [   97.570852] musb-hdrc musb-hdrc.1.auto: Poll devctl 19 (a_wait_bcon)
> I don't think you are testing with the 3.2 kernel you referred from
> the ti.com link you mentioned above.
> 3.2 kernel should have no '.auto' at the end of the device name.
> 
> If it is 3.8 or later, it seems the driver does something wrong,
> SESSION bit should not be cleared after the device is unplugged.

The bit is removed in otg_timer() because the phy gets into
OTG_STATE_A_WAIT_BCON.

Now, this is current HEAD + my stuff to get second port working. I
downloaded v3.2 and browsed as I was looking for the workaround, never
tested maybe I should…

On v3.8 from git://git.ti.com/ti-linux-kernel/ti-linux-kernel.git I
don't get the second port to work. I see

[    1.989101] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    1.996361] usb usb1: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    2.004060] usb usb1: Product: MUSB HDRC host driver
[    2.009363] usb usb1: Manufacturer: Linux 3.8.13+ musb-hcd
[    2.015183] usb usb1: SerialNumber: musb-hdrc.0.auto
[    2.033653] hub 1-0:1.0: USB hub found
[    2.037861] hub 1-0:1.0: 1 port detected

and nothing happens once I plug in the device.

Sebastian

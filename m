Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697AbaFDQAd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 12:00:33 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:46930 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497AbaFDQAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 12:00:31 -0400
Date: Wed, 4 Jun 2014 18:00:00 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Mike Remski <mremski@mutualink.net>
Cc: Johan Hovold <jhovold@gmail.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: ftdi_sio BUG: NULL pointer dereference
Message-ID: <20140604160000.GF11160@localhost>
References: <20140602164957.GC13790@localhost>
 <538CB049.9020805@mutualink.net>
 <20140602174630.GD13790@localhost>
 <538DA0BD.5080208@mutualink.net>
 <20140604141937.GA11160@localhost>
 <538F2D51.2010508@mutualink.net>
 <20140604145200.GB11160@localhost>
 <538F3360.40407@mutualink.net>
 <20140604150938.GD11160@localhost>
 <538F3E3B.5080906@mutualink.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <538F3E3B.5080906@mutualink.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2014 at 11:41:47AM -0400, Mike Remski wrote:
> Ok, had a chance to try the cdc-acm;  yes it's the ancient one that is 
> in the base install of CentOS 6.4 (2.6.32-71.29.1 centos patched).  I'm 
> hitting something similar;  I noticed there where a few commits for NULL 
> pointer dereferences in cdc-acm.c.
> 
> I'll poke into this a bit (yes, I know try a newer kernel, etc) and let 
> you know what I find (or perhaps this looks similar to something already 
> seen?).  This device is the same as the original ftdi crash, 1.2 is the 
> same interface with bNumEndpoints == 0.
> 
> Jun  4 11:35:20 nicA91A84 kernel: cdc_acm 5-2:1.2: This device cannot do 
> calls on its own. It is not a modem.
> Jun  4 11:35:20 nicA91A84 kernel: BUG: unable to handle kernel NULL 
> pointer dereference at 00000004
> Jun  4 11:35:20 nicA91A84 kernel: IP: [<f84f9c9e>] 
> acm_probe+0x44e/0x127c [cdc_acm]
> Jun  4 11:35:20 nicA91A84 kernel: *pdpt = 00000000354eb001 *pde = 
> 000000007f003067
> Jun  4 11:35:20 nicA91A84 kernel: Oops: 0000 [#1] SMP
> Jun  4 11:35:20 nicA91A84 kernel: last sysfs file: 
> /sys/devices/pci0000:00/0000:00:1d.0/usb5/5-2/product

Yeah, you really need to update your kernel. You'll definitely need at
least commit 99f347caa456 ("USB: CDC ACM: Fix NULL pointer
dereference").

No more reports until you've tried a recent kernel, ok? ;)

Johan

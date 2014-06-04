Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508AbaFDRFJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 13:05:09 -0400
Received: from mail-qg0-f45.google.com ([209.85.192.45]:49808 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016AbaFDRFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 13:05:06 -0400
Message-ID: <538F51BF.2030901@mutualink.net>
Date: Wed, 04 Jun 2014 13:05:03 -0400
From: Mike Remski <mremski@mutualink.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Johan Hovold <jhovold@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: ftdi_sio BUG: NULL pointer dereference
References: <20140602164957.GC13790@localhost> <538CB049.9020805@mutualink.net> <20140602174630.GD13790@localhost> <538DA0BD.5080208@mutualink.net> <20140604141937.GA11160@localhost> <538F2D51.2010508@mutualink.net> <20140604145200.GB11160@localhost> <538F3360.40407@mutualink.net> <20140604150938.GD11160@localhost> <538F3E3B.5080906@mutualink.net> <20140604160000.GF11160@localhost>
In-Reply-To: <20140604160000.GF11160@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2014 12:00 PM, Johan Hovold wrote:
> On Wed, Jun 04, 2014 at 11:41:47AM -0400, Mike Remski wrote:
>> Ok, had a chance to try the cdc-acm;  yes it's the ancient one that is
>> in the base install of CentOS 6.4 (2.6.32-71.29.1 centos patched).  I'm
>> hitting something similar;  I noticed there where a few commits for NULL
>> pointer dereferences in cdc-acm.c.
>>
>> I'll poke into this a bit (yes, I know try a newer kernel, etc) and let
>> you know what I find (or perhaps this looks similar to something already
>> seen?).  This device is the same as the original ftdi crash, 1.2 is the
>> same interface with bNumEndpoints == 0.
>>
>> Jun  4 11:35:20 nicA91A84 kernel: cdc_acm 5-2:1.2: This device cannot do
>> calls on its own. It is not a modem.
>> Jun  4 11:35:20 nicA91A84 kernel: BUG: unable to handle kernel NULL
>> pointer dereference at 00000004
>> Jun  4 11:35:20 nicA91A84 kernel: IP: [<f84f9c9e>]
>> acm_probe+0x44e/0x127c [cdc_acm]
>> Jun  4 11:35:20 nicA91A84 kernel: *pdpt = 00000000354eb001 *pde =
>> 000000007f003067
>> Jun  4 11:35:20 nicA91A84 kernel: Oops: 0000 [#1] SMP
>> Jun  4 11:35:20 nicA91A84 kernel: last sysfs file:
>> /sys/devices/pci0000:00/0000:00:1d.0/usb5/5-2/product
> Yeah, you really need to update your kernel. You'll definitely need at
> least commit 99f347caa456 ("USB: CDC ACM: Fix NULL pointer
> dereference").
>
> No more reports until you've tried a recent kernel, ok? ;)
>
> Johan
Device in question does not cause kernel crash when using the cdc-acm 
driver on  a Fedora 19 system running Fedora kernel 3.9.5-301.

Thanks for all the help, I'll take care of my ancient kernels.



-- 
Office: (978)401-4032 (x123 internally)
Cell: (603) 759-6953


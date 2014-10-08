Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225AbaJHRNm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 13:13:42 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:60741 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976AbaJHRNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 13:13:40 -0400
Message-ID: <543570C3.9080207@infradead.org>
Date: Wed, 08 Oct 2014 10:13:39 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        linux-media <linux-media@vger.kernel.org>
Subject: Re: linux-next: Tree for Oct 8 (media/usb/gspca)
References: <20141008174923.76786a03@canb.auug.org.au>
In-Reply-To: <20141008174923.76786a03@canb.auug.org.au>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/14 23:49, Stephen Rothwell wrote:
> Hi all,
> 
> Please do not add any material intended for v3.19 to you linux-next
> included trees until after v3.18-rc1 has been released.
> 
> Changes since 20141007:
> 

I saw these build errors in gspca when CONFIG_INPUT=m but the gspca
sub-drivers are builtin:

drivers/built-in.o: In function `gspca_dev_probe2':
(.text+0x10ef43): undefined reference to `input_allocate_device'
drivers/built-in.o: In function `gspca_dev_probe2':
(.text+0x10efdd): undefined reference to `input_register_device'
drivers/built-in.o: In function `gspca_dev_probe2':
(.text+0x10f002): undefined reference to `input_free_device'
drivers/built-in.o: In function `gspca_dev_probe2':
(.text+0x10f0ac): undefined reference to `input_unregister_device'
drivers/built-in.o: In function `gspca_disconnect':
(.text+0x10f186): undefined reference to `input_unregister_device'
drivers/built-in.o: In function `sd_int_pkt_scan':
se401.c:(.text+0x11373d): undefined reference to `input_event'
se401.c:(.text+0x11374e): undefined reference to `input_event'
drivers/built-in.o: In function `sd_pkt_scan':
t613.c:(.text+0x119f0e): undefined reference to `input_event'
t613.c:(.text+0x119f1f): undefined reference to `input_event'
drivers/built-in.o: In function `sd_stopN':
t613.c:(.text+0x11a047): undefined reference to `input_event'
drivers/built-in.o:t613.c:(.text+0x11a058): more undefined references to `input_event' follow

These could be fixed in Kconfig by something like (for each sub-driver that tests
CONFIG_INPUT):

	depends on INPUT || INPUT=n

Do you have another preference for fixing this?

thanks,
-- 
~Randy

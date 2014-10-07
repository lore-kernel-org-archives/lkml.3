Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126AbaJGHrK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 03:47:10 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:41015 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbaJGHrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 03:47:05 -0400
Message-ID: <54339A73.40107@gmail.com>
Date: Tue, 07 Oct 2014 09:46:59 +0200
From: =?windows-1252?Q?Philippe_R=E9tornaz?= 
	<philippe.retornaz@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org
CC: linux-m32r-ja@ml.linux-m32r.org, linux-mips@linux-mips.org,
        linux-efi@vger.kernel.org, linux-ia64@vger.kernel.org,
        Heiko Stuebner <heiko@sntech.de>, Len Brown <len.brown@intel.com>,
        linux-xtensa@linux-xtensa.org, Pavel Machek <pavel@ucw.cz>,
        devel@driverdev.osuosl.org, linux-s390@vger.kernel.org,
        lguest@lists.ozlabs.org, linux-c6x-dev@linux-c6x.org,
        linux-hexagon@vger.kernel.org, linux-sh@vger.kernel.org,
        Alexander Graf <agraf@suse.de>, linux-acpi@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        xen-devel@lists.xenproject.org, devicetree@vger.kernel.org,
        user-mode-linux-devel@lists.sourceforge.net, linux-pm@vger.kernel.org,
        adi-buildroot-devel@lists.sourceforge.net, linux-m68k@vger.kernel.org,
        linux-am33-list@redhat.com, linux-tegra@vger.kernel.org,
        openipmi-developer@lists.sourceforge.net, linux-metag@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org,
        linux-cris-kernel@axis.com, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        linux-alpha@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Romain Perier <romain.perier@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 01/44] kernel: Add support for poweroff handler call chain
References: <1412659726-29957-1-git-send-email-linux@roeck-us.net> <1412659726-29957-2-git-send-email-linux@roeck-us.net>
In-Reply-To: <1412659726-29957-2-git-send-email-linux@roeck-us.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

This seems exactly what I would need on the mc13783 to handle cleanly 
the poweroff,
but after reading this patchset I have the following question:

[...]

> +/*
> + *	Notifier list for kernel code which wants to be called
> + *	to power off the system.
> + */
> +static ATOMIC_NOTIFIER_HEAD(poweroff_handler_list);

[...]

> +void do_kernel_poweroff(void)
> +{
> +	atomic_notifier_call_chain(&poweroff_handler_list, 0, NULL);
> +}
> +

It seems that the poweroff callback needs to be atomic as per
_atomic_notifier_call_chain documentation:

	"Calls each function in a notifier chain in turn.  The functions
	 run in an atomic context"

But this is a problem for many MFD (mc13783, twl4030 etc ...) which are
accessible on only a blocking bus (SPI, I2C).

What I am missing here ?

Thanks,

Philippe

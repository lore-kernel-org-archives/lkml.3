Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109AbaJTOWZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 10:22:25 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:54902 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372AbaJTOWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 10:22:22 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Aaron Lu <aaron.lu@intel.com>, devicetree@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Darren Hart <dvhart@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v5 10/12] gpio: Support for unified device properties interface
Date: Mon, 20 Oct 2014 16:22:15 +0200
Message-ID: <15256871.WGP3V2Kd9r@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <25715349.xM7UOyLcLb@vostro.rjw.lan>
References: <2660541.BycO7TFnA2@vostro.rjw.lan> <2997291.LjjH2RgEUW@wuerfel> <25715349.xM7UOyLcLb@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Uo0sx/l6IfwrE1UDz3MKBKgK61wxu+3lrPud7Y8RCzp
 lfCcdy/SaCfez0C6FSKPFPJbr9pYFKpWCSuoOX6xpC5Sj4X13Q
 /2m+ADdnzLLKBOeckm2L8vIt8wuRsRn4US+LYhnjU+od5xqY7c
 pEourmk4+qUxZoiQu/AMD51OZ2sdB1qqtoiVheV+uOmYreNylY
 Z2fMEWqxZBAkQh8lE6x46VueNAANzLZH00IxGwRk1Nekc5TxPH
 J5YcupUZnBHU9jVVM6oqoxttYuD+XdKxP4GYzrJNShHfX8vKD+
 GiDPHDNyo4Kdm/de1dLyCZV/dlgCzAOoGaLV02uoCrPgQP3kDX
 +yzclTr813wmJWxC1h+M=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 20 October 2014 01:58:57 Rafael J. Wysocki wrote:
> 
> Actually, since the two last patches in the series, which currently are
> the only users of these new functions, both pass "gpios" as the property
> name and 0 as the index, I can simplify the functions so that (a)
> fwnode_get_gpiod() takes fwnode and name and then simply passes 0 as the
> index to either of_get_named_gpiod_flags() or acpi_get_gpiod_by_index()
> and (b) devm_get_named_gpiod_from_child() takes only dev and fwnode (child)
> and passes "gpios" as the property name to fwnode_get_gpiod().  The name
> of devm_get_named_gpiod_from_child() could then be changed to something
> like devm_get_gpiod_from_child() even.
> 
> If anyone in the future needs anything more general, they can simply
> add more complexity to that code, but for now we can go for a simplified
> interface just fine.
> 

That sounds good, yes.

	Arnd

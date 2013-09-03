Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933811Ab3ICTK0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 15:10:26 -0400
Received: from nm18-vm10.access.bullet.mail.bf1.yahoo.com ([216.109.115.89]:39669
	"EHLO nm18-vm10.access.bullet.mail.bf1.yahoo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933794Ab3ICTKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 15:10:23 -0400
X-Yahoo-Newman-Id: 838146.86671.bm@smtp106.sbc.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: j0mfhHQVM1n5rQhfcjpmuucAeJkF8TLgLrVabZJIsFKZOmo
 Gn3q.slTxEto4od00UG1EuKtvyVQkTkgJuoZxJatpcvWgCBSXGPB9fwDTMjn
 9Wk.1wH9XTlAcw3GJq1MIBpYVyotaJ2m3lwilOUXmJWvphCvUfjRU3pNp0MG
 .1yHMvtZsI4oN8.Bqp2s5ywTFwFSlNlZZTXpd.0WuWhKtuQ2uzPMjL75jiUJ
 E.ViJrieDSIgkQyRzduc0I5p8fP8vPefQIwQwfG0hNhicr65TO0bHk6Txlg0
 nFg0ZYPNoUeAGOYBnRgs_LuYwGn1Qxi5Piw.ldpIkT8.qw0W4KWJBii81Uil
 aE4_FNk0R8cJog2x7yA660Pqv5UKeLA3oimWvWstlWTQ8257aFjnAvNugpXO
 OZC0dK947NG54I0n8cxVWowtheo3vzDaicp7B6gHAkJNwWIthZYq7bxh91qC
 5Gjewx0OnMLLTeVFaHsRUIc6z5VBIALNev1fp8jFrabg9RUxb_d0SSsdzZs_
 rend_IwqkkTKNkrug6iTFGV0xhQyShbL91J3IE0m7K1T6oAqAotYHrrgjwCt
 7iJKxfx3e6vch8JkdPWmxaSg-
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
X-Rocket-Received: from [192.168.1.4] (danielfsantos@99.70.244.137 with plain)
        by smtp106.sbc.mail.bf1.yahoo.com with SMTP; 03 Sep 2013 12:10:21 -0700 PDT
Message-ID: <5226342E.70804@att.net>
Date: Tue, 03 Sep 2013 14:10:38 -0500
From: Daniel Santos <danielfsantos@att.net>
Reply-To: Daniel Santos <daniel.santos@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130730 Thunderbird/17.0.7
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        linux-gpio <linux-gpio@vger.kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>,
        linux-spi <linux-spi@vger.kernel.org>
Subject: Re: RESEND: Generating interrupts from a USB device driver?
References: <52251562.5000208@att.net> <20130902230738.GA22494@kroah.com> <52253E1F.6000101@att.net> <20130903175933.GA8463@kroah.com>
In-Reply-To: <20130903175933.GA8463@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 09/03/2013 12:59 PM, Greg KH wrote:
> Hm, I thought we used to have some of them, I guess people have been
> saying they would write a driver for this type of hardware for a long
> time now :(

Well, on the bright side, we have one now, albeit in a "this is my first 
driver that nobody has reviewed yet" state. :)  It works (even on RPi -- 
well, mostly).  As-is, it has a fair TODO & fix list, which I'm sure 
will grow rapidly with some review. I hope that as I learn the kernel 
better, I can generalize parts of this into some re-usable lib for other 
USB-to-SPI/I2C/GPIO drivers.

https://github.com/daniel-santos/mcp2210-linux/

> Anyway, look at the spi core, I think you want to tie into the
> spi_new_device() call in your usb driver, and start sending/receiving
> data through the SPI interfaces the spi core provides.

I'm actually using the alternative to that call, which is the 
spi_alloc_device() / spi_add_device() pair as I'm not using struct 
spi_board_info at all since it doesn't (currently) have even half of the 
fields I need for each device. However, struct spi_device does have the 
two void * fields controller_data and controller_state -- I suppose I 
can use those to pass a pointer to a add_notify() type of function.  I 
was just trying to seek a more generic, re-usable mechanism, but this 
should at least work for now.

> The Linux SPI mailing list should be able to help you out a lot more
> here than I can.
>
> greg k-h

Thanks again for your help!

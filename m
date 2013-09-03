Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760441Ab3ICUAi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 16:00:38 -0400
Received: from nm7-vm8.access.bullet.mail.bf1.yahoo.com ([216.109.114.167]:39014
	"EHLO nm7-vm8.access.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758525Ab3ICUAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 16:00:36 -0400
X-Yahoo-Newman-Id: 845988.77911.bm@smtp114.sbc.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: Q2c9yBcVM1nIZQyL43iHEeVG1l3WT8jY5wCiULkoxu4eP__
 kfBOc23VFkiS9jdr1dgj2X86lzapXzEmZxx5heYSL4UfYDrsd4GiUbgVpesg
 vBjWmLynxqNINxvejUqp8m70mjyiXP5l6SEP.rIysh_.o7ooR6jfzOrkXvZt
 bPak6MhzqI2ylKNzyVSR0zm5PurgxVifd6zfIkDYpY5FU5.RatSZCZEGdtTm
 FYh.M0jRzAgvThfzi_T.LVHPqiA_WL3Ck.HtD0boP5DGz9hyz.3XadSR2ahv
 fA4bnGq6UPeYeFGC_hOXWi_mY7aykvHeIutJ3GwphSFKKclqaTyA4CDmG0o0
 WX3Qm.iC9pZWbb1O53Pm8dzj2HrbuNmLng_juh6WJu0khvVM9pGKyLgtOHTT
 g0dPS1qVCCsVHwQah6cHfA07PI.I9T7JFvlbk3E1AsEs.N3E5R5J0Fo1Gl7s
 q_zABUwC8J64i_xa1rjC5TW9zO_pts5cl9pcQsV3G3T2A2XOQSA--
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
X-Rocket-Received: from [192.168.1.4] (danielfsantos@99.70.244.137 with plain)
        by smtp114.sbc.mail.ne1.yahoo.com with SMTP; 03 Sep 2013 13:00:34 -0700 PDT
Message-ID: <52263FF3.6080409@att.net>
Date: Tue, 03 Sep 2013 15:00:51 -0500
From: Daniel Santos <danielfsantos@att.net>
Reply-To: Daniel Santos <daniel.santos@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130730 Thunderbird/17.0.7
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        linux-gpio <linux-gpio@vger.kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>,
        linux-spi <linux-spi@vger.kernel.org>
Subject: Re: RESEND: Generating interrupts from a USB device driver? (USB
 to SPI/GPIO bridge)
References: <52251562.5000208@att.net> <20130902230738.GA22494@kroah.com>
In-Reply-To: <20130902230738.GA22494@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/2013 06:07 PM, Greg KH wrote:
> On Mon, Sep 02, 2013 at 05:46:58PM -0500, Daniel Santos wrote:
>> Hello guys.  I didn't get a response the last time so hopefully with
>> 3.11 out I'll get one this time.
>>
>> I need to be able to generate interrupts from a USB device driver while
>> servicing the complete() function of an interrupt URB.
> No you don't :)

Hmm, am I wrong that if I want my gpios to be poll()-able from userspace 
(via /sys/class/gpio/gpio<num>/value), that I must generate an IRQ and 
populate my .to_irq function of gpio_chip? Or is it cleaner to find the 
dirent and directly call sysfs_notify_dirent() to facilitate this 
behavior to userspace?

Of course, this will wont enable drivers that want an irq in the kernel, 
but aside from this ADNS-9800, I don't need that functionality.

Thanks,
Daniel

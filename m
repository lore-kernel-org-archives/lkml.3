Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759189Ab3ICBqE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 21:46:04 -0400
Received: from nm8.access.bullet.mail.bf1.yahoo.com ([216.109.114.70]:20184
	"EHLO nm8.access.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754103Ab3ICBqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 21:46:01 -0400
X-Greylist: delayed 329 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Sep 2013 21:46:01 EDT
X-Yahoo-Newman-Id: 535040.10119.bm@smtp106.sbc.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 701DVJwVM1ljLY6WJ6rKLCxU67Hn0uaBYOjAWmvCCejqbjV
 Pn9kJjB6nIX.dggzhPH.wOq13u_eS081v1XTD424qsN8RnQTt1XnV17QrOP0
 pjZ2qqCgrnOqL1IxAc77iUcNEuW4DUY_pdK49nAVyKO8QNzUbsYI5as00wkV
 A4YaSqPksuCSDqEEwgISXcuqolBKDGobcMgo7aPtjxp0eqrn5QkSQLpE0VSo
 Off92Nbfo_7IKqan6qh14ijPnrUdiSvJ6E_iVaMIu9oFTy6BjchySoUq6.My
 qhfSVMQlFUlTkDDM2QpClTmzfgs.5fqgX_5cvGQeQiMSmsTxGxOsa7o_0Gt7
 qXsuAByAFi0an1qViGvj8jmcKuwV9BVnP.n8u4mKLAApOihIYhW8iEZMf6f6
 KBPuXaUDAZf.FxXvM8W_XXRXONhyu6I9Dp_HApWhsOdeT5DwNnXY5no6Z9z0
 VE_BPbN9uYdaF0qUUv4jHmkV_musjT2tTKCIG0XDI30LzzAWLAhjSUOP7oqI
 4mw84oXfnFId1eMfZ9cyUqoYANkg-
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
X-Rocket-Received: from [192.168.1.4] (danielfsantos@99.70.244.137 with plain)
        by smtp106.sbc.mail.bf1.yahoo.com with SMTP; 02 Sep 2013 18:40:31 -0700 PDT
Message-ID: <52253E1F.6000101@att.net>
Date: Mon, 02 Sep 2013 20:40:47 -0500
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
>
>> While I realize that this may seem strange, the purpose is for a USB
>> to SPI/GPIO bridge chip (the MCP2210). When something happens on the
>> remote device where a chip is expecting it's interrupt out pin to
>> trigger an interrupt on some local (to the board) microcontroller, the
>> MCP2210 instead receives that signal and communicates it to the host
>> the next time it's queried. This is the interrupt that I need to, in
>> effect propagate locally. Since my spi_master and gpio_chip are all
>> functioning now, this is the last step to get one of my spi protocol
>> drivers working correctly.
> Just pass the data up the spi stack in your interrupt endpoint handler.
> No need to try to create a "real" interrupt.  There are other USB SPI
> drivers that should give you the idea of how to do it.
Thanks for your response! I haven't been able to find these drivers, can 
you please point me to one? I guess I don't know the "spi stack" well 
enough to know how to propagate that notification up to the driver for 
the spi device (let alone that it was called a "stack" :)

Thanks!!
Daniel

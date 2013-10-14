Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757575Ab3JNXcd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 19:32:33 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:39192 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757144Ab3JNXcc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 19:32:32 -0400
From: Maximilian =?ISO-8859-1?Q?G=FCntner?= 
	<maximilian.guentner@gmail.com>
To: Bryan Wu <cooloney@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-leds <linux-leds@vger.kernel.org>,
        Peter Meerwald <pmeerw@pmeerw.net>
Subject: Re: [PATCH] leds: Added driver for the NXP PCA9685 I2C chip
Date: Tue, 15 Oct 2013 01:32:29 +0200
Message-ID: <3053694.67rQ0WDbyA@titan>
User-Agent: KMail/4.11.2 (Linux/3.11.4-1-ARCH; KDE/4.11.2; x86_64; ; )
In-Reply-To: <CAK5ve-++aGqSe5dg=MHxNKrk0V75OP0_OY5h2KVYeDY3VjZ4zg@mail.gmail.com>
References: <2819232.mPNW6mO2uH@titan> <CAK5ve-++aGqSe5dg=MHxNKrk0V75OP0_OY5h2KVYeDY3VjZ4zg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 October 2013 15:08:15 Bryan Wu wrote:
> On Mon, Oct 14, 2013 at 10:31 AM, Maximilian Güntner
> 
> <maximilian.guentner@gmail.com> wrote:
> > The NXP PCA9685 supports 16 channels/leds using a 12-bit PWM (4095
> > levels of brightness)
> > This driver supports configuration using platform_data.
> 
> I'm OK for this patch basically, just a little picky coding style
> issue as below.
> > +       if (brightness == 4096)
> > +               *((u16 *)(i2c_buffer+1)) = cpu_to_le16(0x1000);
> > +       else
> > +               *((u16 *)(i2c_buffer+1)) = 0x0000;
> 
> One empty line here probably is better.
fixed.
> > +
> > +       pdata = dev_get_platdata(&client->dev);
> > +
> 
> No need empty line here.
fixed.
> > +       pca9685 = devm_kzalloc(&client->dev, 16 * sizeof(*pca9685),
> > GFP_KERNEL); +
> 
> No need empty line here.
fixed.
> > &pca9685[i].led_cdev); +               if (err < 0)
> > +                       goto exit;
> > +       }
> 
> You can add one empty line here.
fixed

Thanks for the quick review. A v2 of this patch is on its way which addresses your and
Peter Meerwald's comments.

Maximilian

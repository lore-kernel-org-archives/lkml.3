Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757975Ab3BAXAc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 18:00:32 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:60096 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757313Ab3BAXA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 18:00:29 -0500
MIME-Version: 1.0
In-Reply-To: <1359752988.22968.16.camel@thor.lan>
References: <CANK3SE09VqvshdLrV4xp2W8BHZqLmuz-pV9jQVj7tbk1JBX+9g@mail.gmail.com>
 <Pine.LNX.4.44L0.1301311002190.1876-100000@iolanthe.rowland.org>
 <CANK3SE25kcgSu2dwKtQKU6-wvryC4qNQJu_nj3NPJHQTTC0oXw@mail.gmail.com> <1359752988.22968.16.camel@thor.lan>
From: Mark Einon <mark.einon@gmail.com>
Date: Fri, 1 Feb 2013 23:00:14 +0000
Message-ID: <CANK3SE2nsxLMUyANzsov4d86ow4v9NuzaZsS3XvjpQJOfYXYUQ@mail.gmail.com>
Subject: Re: [PATCH] firewire: Fix ohci free_irq() warning
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1 February 2013 21:09, Peter Hurley <peter@hurleysoftware.com> wrote:
> Hi Mark,
>
> I think what Alan means is that the suspend/resume code should just
> mask/unmask interrupts at the OHCI controller, via the OHCI
> IntEventClear/Set registers (naturally, saving the current mask and
> restoring it on resume).
>
> Of course, there's a lot more to do with an OHCI controller -- as you
> note. Like stopping running DMA contexts :)  And restarting them on
> resume.
>
> I'd do it, but I'm buried to my eyeballs in tty right now -- not fun. I
> can _eventually_ do this as I need to address problems with the FW643
> anyway at some point, but it's going to be a little while.

Hi Peter,

Ok, understood. I can certainly attempt a patch if I get time.

>
> In the meantime, I'm a little confused: you say you can't test this code
> because you have no hardware; but then how'd you trip this bug?

I can test the code in that I have a firewire port on my laptop, but
haven't got anything to plug into the port.
I assume that any large changes I make are quite capable of breaking
something there...

Cheers,

Mark

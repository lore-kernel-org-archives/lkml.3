Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031AbaGGPIE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 11:08:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34013 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752462AbaGGPIC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 11:08:02 -0400
Date: Mon, 7 Jul 2014 17:07:59 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
cc: Antonio Borneo <borneo.antonio@gmail.com>,
        linux-input <linux-input@vger.kernel.org>,
        David Barksdale <dbarksdale@uplogix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] HID: cp2112: fix gpio value in gpio_direction_output
In-Reply-To: <CAN+gG=GM9FqZJwJF0G41E9oWEjcWDeavd=kfZ9qcXvoAkmUdpA@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1407071707490.1655@pobox.suse.cz>
References: <1404022428-2816-1-git-send-email-borneo.antonio@gmail.com> <CAN+gG=GM9FqZJwJF0G41E9oWEjcWDeavd=kfZ9qcXvoAkmUdpA@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Jul 2014, Benjamin Tissoires wrote:

> > CP2112 does not offer an atomic method to set both gpio
> > direction and value.
> > Also it does not permit to set gpio value before putting
> > gpio in output. In fact, accordingly to Silicon Labs
> > AN495, Rev. 0.2, cpt. 4.4, the HID report to set gpio
> > values "does not affect any pins that are not configured
> > as outputs".
> >
> > This is confirmed on evaluation board CP2112-EK.
> > With current driver, after execute:
> >         echo in > /sys/class/gpio/gpio248/direction
> >         echo low > /sys/class/gpio/gpio248/direction
> > gpio output is still high. Only after a following
> >         echo low > /sys/class/gpio/gpio248/direction
> > gpio output gets low.
> >
> > Fix driver by changing order of operations; first set
> > direction then set value.
> >
> > The drawback of this new sequence is that we can have
> > a pulse on gpio pin when direction is changed from
> > input to output-low, but this cannot be avoided on
> > current CP2112.
> 
> In this case, does keeping the first cp2112_gpio_set() before setting
> the output direction prevents the pulse?
> If so, then you can just keep the current code, and simply add the
> cp2112_gpio_set() at the end of cp2112_gpio_direction_output().
> 
> In both case, this is:
> Reviewed-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

I am queuing this for 3.17, thanks.

-- 
Jiri Kosina
SUSE Labs

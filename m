Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026AbaLQKz2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 05:55:28 -0500
Received: from canardo.mork.no ([148.122.252.1]:40406 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751692AbaLQKzT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 05:55:19 -0500
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Joe Perches <joe@perches.com>
Cc: Josh Triplett <josh@joshtriplett.org>, LKML <linux-kernel@vger.kernel.org>,
        kernelnewbies <kernelnewbies@kernelnewbies.org>
Subject: Re: newbies CheckpatchTips for multiline statements (Breaking function calls)
Organization: m
References: <1418763529.14140.9.camel@perches.com>
Date: Wed, 17 Dec 2014 09:58:00 +0100
In-Reply-To: <1418763529.14140.9.camel@perches.com> (Joe Perches's message of
	"Tue, 16 Dec 2014 12:58:49 -0800")
Message-ID: <87ppbi3b6v.fsf@nemi.mork.no>
User-Agent: Gnus/5.130011 (Ma Gnus v0.11) Emacs/24.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.3.9 (canardo.mork.no [IPv6:2001:4641::1]); Wed, 17 Dec 2014 11:52:59 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches <joe@perches.com> writes:

> This style is fine, and generally perferred. However, some driver
> writers prefer to have the trailing line of a function call line up with
> the starting '('. They use tabs, followed by spaces, to align the
> trailing line: 
>
>  
>         pdata->urbdata = usb_alloc_coherent(pdata->udev, ACD_URB_BUFFER_LEN,
>                                             GFP_KERNEL,
>                                             &pdata->urb->transfer_dma);

It might be worth noting that the network subsystem maintainer prefers
this style as well.  So most networking patches should probably use it.
The exception would be files which already use the other style.

You should also be aware of the implications of this style: You have to
modify all three lines if you change anything on the first line causing
the position of the starting '(' to change.  I.e., a patch like this is
not acceptable:

         -pdata->urbdata = usb_alloc_coherent(pdata->udev, ACD_URB_BUFFER_LEN,
         +p->urbdata = usb_alloc_coherent(pdata->udev, ACD_URB_BUFFER_LEN,
                                              GFP_KERNEL,
                                              &pdata->urb->transfer_dma);


It needs to be

         -pdata->urbdata = usb_alloc_coherent(pdata->udev, ACD_URB_BUFFER_LEN,
         -                                    GFP_KERNEL,
         -                                    &pdata->urb->transfer_dma);
         +p->urbdata = usb_alloc_coherent(pdata->udev, ACD_URB_BUFFER_LEN,
         +                                GFP_KERNEL,
         +                                &pdata->urb->transfer_dma);


Bjørn

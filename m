Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757104Ab3K0Qig (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 11:38:36 -0500
Received: from p3plex2out01.prod.phx3.secureserver.net ([184.168.131.12]:60727
	"EHLO p3plex2out01.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754778Ab3K0Qif convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 11:38:35 -0500
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Dave Jones <davej@redhat.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Subject: RE: staging: comedi: Fix boolean/logical and mix-up.
Thread-Topic: staging: comedi: Fix boolean/logical and mix-up.
Thread-Index: AQHO6xxsmRSIhYRkSkOlyQZyHNtwUJo5R03A
Date: Wed, 27 Nov 2013 16:38:34 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D8817E0BBCA@P3PWEX4MB008.ex4.secureserver.net>
References: <20131107062754.93B2D660F4A@gitolite.kernel.org>
 <20131108200659.GA2101@redhat.com>
 <DC148C5AA1CEBA4E87973D432B1C2D8817E08AC5@P3PWEX4MB008.ex4.secureserver.net>
 <20131127025724.GA18860@redhat.com>
In-Reply-To: <20131127025724.GA18860@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [184.183.19.121]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 26, 2013 7:57 PM, Dave Jones wrote:
> Introduced in commit b3ff824a81e8.
>
> Signed-off-by: Dave Jones <davej@fedoraproject.org>
>
> diff --git a/drivers/staging/comedi/drivers/pcl730.c b/drivers/staging/comedi/drivers/pcl730.c
> index d041b714db29..2baaf1db6fbf 100644
> --- a/drivers/staging/comedi/drivers/pcl730.c
> +++ b/drivers/staging/comedi/drivers/pcl730.c
> @@ -173,11 +173,11 @@ static int pcl730_do_insn_bits(struct comedi_device *dev,
>  	if (mask) {
>  		if (mask & 0x00ff)
>  			outb(s->state & 0xff, dev->iobase + reg);
> -		if ((mask & 0xff00) & (s->n_chan > 8))
> +		if ((mask & 0xff00) && (s->n_chan > 8))
>  			outb((s->state >> 8) & 0xff, dev->iobase + reg + 1);
> -		if ((mask & 0xff0000) & (s->n_chan > 16))
> +		if ((mask & 0xff0000) && (s->n_chan > 16))
>  			outb((s->state >> 16) & 0xff, dev->iobase + reg + 2);
> -		if ((mask & 0xff000000) & (s->n_chan > 24))
> +		if ((mask & 0xff000000) && (s->n_chan > 24))
>  			outb((s->state >> 24) & 0xff, dev->iobase + reg + 3);
>  	}

My bad...

Added Greg KH and the staging devel list to the CCs.

Acked-by: H Hartley Sweeten <hsweeten@visionengravers.com>

 

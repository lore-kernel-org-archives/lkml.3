Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755150Ab3G2WWu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 18:22:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60262 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754181Ab3G2WWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 18:22:48 -0400
Date: Mon, 29 Jul 2013 15:22:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Chereji Marian-Cornel-R27762 <R27762@freescale.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grigore Sebastian-SGRIGOR1 <sgrigor1@freescale.com>,
        Schmitt Richard-B43082 <B43082@freescale.com>,
        Fleming Andy-AFLEMING <afleming@freescale.com>
Subject: Re: [PATCH] lib: Add CRC64 ECMA module
Message-Id: <20130729152247.6c00ed3e6de57bb3e7addca9@linux-foundation.org>
In-Reply-To: <4B6ACA9E2957BC4EBAA02AF13568C81B03CA7BC4@039-SN2MPN1-021.039d.mgd.msft.net>
References: <1373619386-29550-1-git-send-email-marian.chereji@freescale.com>
	<20130726150043.67b248c9d5d93c00ed30ebc8@linux-foundation.org>
	<4B6ACA9E2957BC4EBAA02AF13568C81B03CA7BC4@039-SN2MPN1-021.039d.mgd.msft.net>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Jul 2013 11:49:31 +0000 Chereji Marian-Cornel-R27762 <R27762@freescale.com> wrote:

> -----Original Message-----
> From: Andrew Morton [mailto:akpm@linux-foundation.org] 
> Sent: Saturday, July 27, 2013 1:01 AM
> To: Chereji Marian-Cornel-R27762
> Cc: linux-kernel@vger.kernel.org; Grigore Sebastian-SGRIGOR1; Schmitt Richard-B43082; Fleming Andy-AFLEMING
> Subject: Re: [PATCH] lib: Add CRC64 ECMA module
> 
> On Fri, 12 Jul 2013 11:56:26 +0300 Marian Chereji <marian.chereji@freescale.com> wrote:
> 
> > Added implementation of CRC64 ECMA checksum.
> > 
> > Signed-off-by: Marian Chereji <marian.chereji@freescale.com>
> > Reviewed-by: Varvara Andrei-B21317 <andrei.varvara@freescale.com>
> > Reviewed-by: Fleming Andrew-AFLEMING <AFLEMING@freescale.com>
> > ---
> >  include/linux/crc64_ecma.h |   56 +++++++
> >  lib/Kconfig                |    7 +
> >  lib/Makefile               |    1 +
> >  lib/crc64_ecma.c           |  341 ++++++++++++++++++++++++++++++++++++++++++++
> > 
> > Presumably you have some code which will need this library feature?
> > 
> > What code is that, and what is its status?
> > 
>
> Hi Andrew,
> 
> we have an IP Acceleration driver for Freescale network processors
> which is using this CRC64. However, it still needs some work in
> order for it to become upstreamable.
> 
> Thought this CRC64 could helps others in the meantime since it doesn't
> have anything specific to do with our driver.

Please don't top-post - it makes it very hard to conduct a conversation.

I don't think it's generally desirable to put code into lib/ unless we
have an in-kernel user: it consumes resources and is untestable.  From
a quick grep I don't see any current in-kernel code which might use
this.

So I'd propose that I keep this patch in -mm to get a bit of exposure
and compilation testing and wait until the first user comes along, OK?


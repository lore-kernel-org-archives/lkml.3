Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967402Ab3E3Fb7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 01:31:59 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:47836 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416Ab3E3Fbt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 01:31:49 -0400
Date: Thu, 30 May 2013 08:33:32 +0300
From: Timo Teras <timo.teras@iki.fi>
To: Jon Arne =?UTF-8?Q?J=C3=B8rgensen?= <jonarne@jonarne.no>
Cc: Andy Walls <awalls@md.metrocast.net>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        hans.verkuil@cisco.com, prabhakar.csengg@gmail.com,
        g.liakhovetski@gmx.de, ezequiel.garcia@free-electrons.com
Subject: Re: [RFC 1/3] saa7115: Set saa7113 init to values from datasheet
Message-ID: <20130530083332.245e3c62@vostro>
In-Reply-To: <20130530052136.GF2367@dell.arpanet.local>
References: <1369860078-10334-1-git-send-email-jonarne@jonarne.no>
	<1369860078-10334-2-git-send-email-jonarne@jonarne.no>
	<20130529213554.690f7eaa@redhat.com>
	<7454763a-75fe-4d98-b7ab-29b6649dc25e@email.android.com>
	<20130530052136.GF2367@dell.arpanet.local>
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.17; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 May 2013 07:21:36 +0200
Jon Arne Jørgensen <jonarne@jonarne.no> wrote:

> On Wed, May 29, 2013 at 10:19:49PM -0400, Andy Walls wrote:
> > Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
> > 
> > >Em Wed, 29 May 2013 22:41:16 +0200
> > >Jon Arne Jørgensen <jonarne@jonarne.no> escreveu:
> > >
> > >> Change all default values in the initial setup table to match the
> > >table
> > >> in the datasheet.
> > >
> > >This is not a good idea, as it can produce undesired side effects
> > >on the existing drivers that depend on it, and can't be easily
> > >tested.
> > >
> > >Please, don't change the current "default". It is, of course, OK
> > >to change them if needed via the information provided inside the
> > >platform data.
> >
> > I was going to make a comment along the same line as Mauro.  
> > Please leave the driver defaults alone.  It is almost impossible to
> > regression test all the different devices with a SAA7113 chip, to
> > ensure the change doesn't cause someone's device to not work
> > properly.
> >
> 
> You guys are totally right.
> 
> What if I clone the original saa7113_init table into a new one, and
> make the driver use the new one if the calling driver sets
> platform_data.
> 
> Something like this?
> 
>         switch (state->ident) {
>         case V4L2_IDENT_SAA7111:
>         case V4L2_IDENT_SAA7111A:
>                 saa711x_writeregs(sd, saa7111_init);
>                 break;
>         case V4L2_IDENT_GM7113C:
>         case V4L2_IDENT_SAA7113:
> -		saa711x_writeregs(sd, saa7113_init);
> +		if (client->dev.platform_data)
> +			saa711x_writeregs(sd, saa7113_new_init);
> +		else
> +			saa711x_writeregs(sd, saa7113_init);

I would rather have the platform_data provide the new table. Or if you
think bulk of the table will be the same for most users, then perhaps
add there an enum saying which table to use - and name the tables
according to the chip variant it applies to.

- Timo

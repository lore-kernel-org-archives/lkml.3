Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752431Ab3EaOGa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 10:06:30 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:44881 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374Ab3EaOGV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 10:06:21 -0400
Date: Fri, 31 May 2013 17:08:02 +0300
From: Timo Teras <timo.teras@iki.fi>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Jon Arne =?UTF-8?Q?J=C3=B8rgensen?= <jonarne@jonarne.no>,
        Andy Walls <awalls@md.metrocast.net>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, hans.verkuil@cisco.com,
        prabhakar.csengg@gmail.com, g.liakhovetski@gmx.de,
        ezequiel.garcia@free-electrons.com
Subject: Re: [RFC 1/3] saa7115: Set saa7113 init to values from datasheet
Message-ID: <20130531170802.642fbc3e@vostro>
In-Reply-To: <20130531100827.10710841@redhat.com>
References: <1369860078-10334-1-git-send-email-jonarne@jonarne.no>
	<1369860078-10334-2-git-send-email-jonarne@jonarne.no>
	<20130529213554.690f7eaa@redhat.com>
	<7454763a-75fe-4d98-b7ab-29b6649dc25e@email.android.com>
	<20130530052136.GF2367@dell.arpanet.local>
	<20130530083332.245e3c62@vostro>
	<20130530190001.GG2367@dell.arpanet.local>
	<20130531100827.10710841@redhat.com>
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.17; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 May 2013 10:08:27 -0300
Mauro Carvalho Chehab <mchehab@redhat.com> wrote:

> Em Thu, 30 May 2013 21:00:01 +0200
> Jon Arne Jørgensen <jonarne@jonarne.no> escreveu:
> 
> > On Thu, May 30, 2013 at 08:33:32AM +0300, Timo Teras wrote:
> > > I would rather have the platform_data provide the new table. Or
> > > if you think bulk of the table will be the same for most users,
> > > then perhaps add there an enum saying which table to use - and
> > > name the tables according to the chip variant it applies to.
> > > 
> > 
> > I think the bulk of the table will be the same for all drivers.
> > It's one bit here and one bit there that needs changing.
> > As the driver didn't support platform data.
> > Changing to a new init table for the drivers that implement
> > platform_data shouldn't cause any regressions.
> 
> There are several things that are very bad on passing a table via
> platform data:

Sorry, my wording was self-conflicting. The intention was to
suggest providing an enum saying which table to use. Not that the
platform data would provide the whole table.

> 	1) you're adding saa711x-specific data at the bridge driver,
> 	   so, the saa711x code is spread on several places at the
> 	   long term;
> 
> 	2) some part of the saa711x code may override the data there, 
> 	   as it is not aware about what bits should be preserved from
> 	   the new device;
> 
> 	3) due (2), latter changes on the code are more likely to
> 	   cause regressions;
> 
> 	4) also due to (2), some hacks can be needed, in order to warn
> 	   saa711x to handle some things differently.

Agreed.

> That's why it is a way better to add meaningful parameters telling
> what bits are needed for the driver to work with the bridge. That's
> also why we do this with all other drivers.

Based on the latest patch, more of these bits need to be controlled
individually than I figured. So yes, individual meaningful bits do make
the most sense.

Thanks,
 Timo

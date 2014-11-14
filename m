Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161239AbaKNQT7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 11:19:59 -0500
Received: from mailsec101.isp.belgacom.be ([195.238.20.97]:1582 "EHLO
	mailsec101.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934046AbaKNQT5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 11:19:57 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=aVuRYB9jFzFsbHnyIO6WTXMsFsysg296qeRS+2aVNsk= c=1 sm=2
 a=IkcTkHD0fZMA:10 a=rOUgymgbAAAA:8 a=gu6fZOg2AAAA:8
 a=vTJXzolrOz3ChiOL6rsA:9 a=QEXdDO2ut3YA:10 a=GC8p-B92FUEA:10
 a=NWVoK91CQyQA:10
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArYLAI8qZlTD7hTS/2dsb2JhbABbgw5VWQGDBbY9BpM8h04CgR8WAQEBAQF9hAIBAQEDASMEUgULBQQCGAICGA4CAlcGARIRiCcNCZ5QnHGHAo8+AQEBAQEFAQEBAR6BLYURijEzB4J3gVQFlyKJG5UJg308MIJLAQEB
Date: Fri, 14 Nov 2014 17:19:55 +0100 (CET)
From: Fabian Frederick <fabf@skynet.be>
Reply-To: Fabian Frederick <fabf@skynet.be>
To: Jens Axboe <axboe@kernel.dk>, Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Message-ID: <1420366039.63212.1415981995308.open-xchange@webmail.nmp.skynet.be>
In-Reply-To: <54622AED.9060205@kernel.dk>
References: <20141111131216.3742d156@canb.auug.org.au> <318149421.176770.1415704819915.open-xchange@webmail.nmp.skynet.be> <54622AED.9060205@kernel.dk>
Subject: Re: linux-next: build failure after merge of the block tree
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Priority: 3
Importance: Medium
X-Mailer: Open-Xchange Mailer v7.2.2-Rev27
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> On 11 November 2014 at 16:27 Jens Axboe <axboe@kernel.dk> wrote:
>
>
> On 2014-11-11 04:20, Fabian Frederick wrote:
> >
> >
> >> On 11 November 2014 at 03:12 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >>
> >>
> >> Hi Jens,
> >>
> >> After merging the block tree, today's linux-next build (x86_64
> >> allmodconfig) failed like this:
> >>
> >> drivers/built-in.o: In function `cdrom_sysctl_handler':
> >> cdrom_sysctl.c:(.text+0x156d92): undefined reference to `cdrom_mutex'
> >> cdrom_sysctl.c:(.text+0x156da0): undefined reference to `cdrom_autoclose'
> >> cdrom_sysctl.c:(.text+0x156dae): undefined reference to `cdrom_autoeject'
> >> cdrom_sysctl.c:(.text+0x156dbc): undefined reference to `cdrom_debug'
> >> cdrom_sysctl.c:(.text+0x156dca): undefined reference to `cdrom_lockdoor'
> >> cdrom_sysctl.c:(.text+0x156dd8): undefined reference to
> >> `cdrom_check_media_type'
> >> cdrom_sysctl.c:(.text+0x156e0b): undefined reference to `cdrom_list'
> >> cdrom_sysctl.c:(.text+0x156e37): undefined reference to `cdrom_autoclose'
> >> cdrom_sysctl.c:(.text+0x156e57): undefined reference to `cdrom_autoeject'
> >> cdrom_sysctl.c:(.text+0x156e77): undefined reference to
> >> `cdrom_check_media_type'
> >> cdrom_sysctl.c:(.text+0x156ea4): undefined reference to `cdrom_lockdoor'
> >> cdrom_sysctl.c:(.text+0x156eb5): undefined reference to `cdrom_list'
> >> cdrom_sysctl.c:(.text+0x15702e): undefined reference to `cdrom_mutex'
> >> drivers/built-in.o: In function `cdrom_print_info.constprop.0':
> >> cdrom_sysctl.c:(.text+0x1570f3): undefined reference to `cdrom_list'
> >> cdrom_sysctl.c:(.text+0x157189): undefined reference to `cdrom_list'
> >> drivers/built-in.o: In function `cdrom_sysctl_info':
> >> cdrom_sysctl.c:(.text+0x1572c3): undefined reference to `cdrom_mutex'
> >> cdrom_sysctl.c:(.text+0x1576dc): undefined reference to `cdrom_mutex'
> >> drivers/built-in.o: In function `cdrom_sysctl_register':
> >> (.text+0x157765): undefined reference to `cdrom_autoclose'
> >> drivers/built-in.o: In function `cdrom_sysctl_register':
> >> (.text+0x157781): undefined reference to `cdrom_autoeject'
> >> drivers/built-in.o: In function `cdrom_sysctl_register':
> >> (.text+0x15778e): undefined reference to `cdrom_debug'
> >> drivers/built-in.o: In function `cdrom_sysctl_register':
> >> (.text+0x15779b): undefined reference to `cdrom_lockdoor'
> >> drivers/built-in.o: In function `cdrom_sysctl_register':
> >> (.text+0x1577a8): undefined reference to `cdrom_check_media_type'
> >>
> >> Probably caused by commit d01681d1457c ("cdrom: export sysctl code").
> >> This build has CONFIG_SYSCTL=y, CONFIG_BLK_DEV_IDECD=m,
> >> CONFIG_BLK_DEV_SR=m, CONFIG_PARIDE_PCD=m, CONFIG_CDROM_PKTCDVD=m,
> >> CONFIG_GDROM=n.
> >>
> >> I have used the block tree from next-20141110 for today.
> >> --
> >> Cheers,
> >> Stephen Rothwell                    sfr@canb.auug.org.au
> >
> > Hi Stephen,
> >
> > Problem is in Makefile:
> >
> > obj-$(CONFIG_BLK_DEV_SR) += cdrom.o
> > obj-$(CONFIG_PARIDE_PCD) += cdrom.o
> > obj-$(CONFIG_CDROM_PKTCDVD) += cdrom.o
> > +obj-$(CONFIG_SYSCTL) += cdrom_sysctl.o
> >
> > I tried cdrom-$(CONFIG_SYSCTL)  += cdrom_sysctl.o
> > to add sysctl only when cdrom.o is created
> >
> > but now
> >
> > drivers/scsi/sr_mod.ko
> > drivers/ide/ide-cd_mod.ko
> > drivers/ide/ide-cd_mod.ko
> >
> > can't find cdrom.c functions ...
> >
> > Is there another way to do it ?
>
> The problem is, now you can have cdrom/sr modular, but cdrom_sysctl.o is
> linked in. That's just not going to work. Instead of jumping through
> hoops to make this work, leave the section in cdrom.c and hid it behind a
>
> #if defined(CONFIG_SYSCTL)
> ...
> #endif
>
> at the bottom or something.
>
> --
> Jens Axboe
>

Hi Jens,

   It's already the case in current code so I'll drop this patch.
I've got a small question about another one:
(http://marc.info/?l=linux-kernel&m=141565102708591&w=2)

I was looking if there was a reason for calling

init_cdrom_command with 0 length in dvd_do_auth():

   memset(buf, 0, sizeof(buf));
   init_cdrom_command(&cgc, buf, 0, CGC_DATA_READ)
       
This doesn't impact setup_report_key/setup_send_key
calls -as those functions initialize cgc buflen again
depending on type argument- without DVD_INVALIDATE_AGID:
we call setup_report_key(&cgc, ai->lsa.agid, 0x3f);
where type is used for cmd[10]:

   cgc->cmd[10] = type | (agid << 6);

the switch(type) below doesn't have 0x3f case so we
go directly to

   cgc->cmd[9] = cgc->buflen;

I replaced the 2 lines above with

   init_cdrom_command(&cgc, buf, sizeof(buf), CGC_DATA_READ)

(as memset is already done during init_cdrom_command) but that would
change buflen in that case and subsequent cdo->generic_packet
behaviour or am I missing something ?

Regards,
Fabian

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932247AbaGWPav (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 11:30:51 -0400
Received: from mailsec108.isp.belgacom.be ([195.238.20.104]:1860 "EHLO
	mailsec108.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758348AbaGWPau convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 11:30:50 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=UGN7JNw3bPEHpwjh5ACRRBK85/3fvewMg9DN/Z6sboU= c=1 sm=2
 a=BvXeENiMdHAA:10 a=IkcTkHD0fZMA:10 a=IJv9LcIfAAAA:8
 a=JUB8fNl_A1OsHX5GLncA:9 a=QEXdDO2ut3YA:10 a=K6kUPx8HyhEA:10
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoFAFDUz1PD7hTU/2dsb2JhbABZgw5SV4J4rEMBAQEBAQEGmBqHTQGBCxZ2hAMBAQQBIwRSBQsFBhgCAhgOAgJXBhMRiCkMqQiGf5AzF4EshE+JHTMHgniBTgWvbYNKOy8
Date: Wed, 23 Jul 2014 17:30:48 +0200 (CEST)
From: Fabian Frederick <fabf@skynet.be>
Reply-To: Fabian Frederick <fabf@skynet.be>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org
Message-ID: <1974949051.1018368.1406129448295.open-xchange@webmail.nmp.skynet.be>
In-Reply-To: <1406128031.2755.21.camel@joe-AO725>
References: <1406127018-15953-1-git-send-email-fabf@skynet.be> <1406128031.2755.21.camel@joe-AO725>
Subject: Re: [PATCH V2] SYSV: logging update
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Priority: 3
Importance: Medium
X-Mailer: Open-Xchange Mailer v7.2.2-Rev27
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> On 23 July 2014 at 17:07 Joe Perches <joe@perches.com> wrote:
>
>
> On Wed, 2014-07-23 at 16:50 +0200, Fabian Frederick wrote:
> > -use current logging functions
> > -replace no level printk by pr_err
> > -add debug.c / sysv_err function to include sb->s_id
> > -standardize prefix: "sysv (sb id): " and remove sb id from various logging
> > at different places.
> > -use __func__
> > -coalesce formats
>
> Seems fine but:
>
> > diff --git a/fs/sysv/debug.c b/fs/sysv/debug.c
> []
> > @@ -0,0 +1,15 @@
> > +#define pr_fmt(fmt) KBUILD_MODNAME " " fmt
>
> Please use KBUILD_MODNAME ": " fmt

fs logging is generally like the following:

"sysv(sb->s_id): "

with KBUILD_MODNAME ": " :

"sysv: (sb->s_id)"


>
> > +
> > +#include "sysv.h"
> > +
> > +void sysv_err(struct super_block *sb, const char *fmt, ...)
> > +{
> > +   struct va_format vaf;
> > +   va_list args;
> > +
> > +   va_start(args, fmt);
> > +   vaf.fmt = fmt;
> > +   vaf.va = &args;
> > +   pr_err("(%s): %pV\n", sb->s_id, &vaf);
>
> This trailing \n is not necessary and causes
> blank lines in the log.
>
> All callers already use it.

I could remove it from all callers instead ?
Thanks,
Fabian
>
>

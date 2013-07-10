Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766Ab3GJQRv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 12:17:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37647 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752571Ab3GJQRu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 12:17:50 -0400
Subject: Re: [PATCH] firmware/dmi_scan: Drop OOM messages
From: Jean Delvare <jdelvare@suse.de>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Ben Hutchings <ben@decadent.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1373467888.14604.32.camel@joe-AO722>
References: <1373460424.4399.45.camel@chaos.site>
	 <1373467888.14604.32.camel@joe-AO722>
Content-Type: text/plain; charset="UTF-8"
Organization: Suse Linux
Date: Wed, 10 Jul 2013 18:17:31 +0200
Message-ID: <1373473051.4399.51.camel@chaos.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

Le Wednesday 10 July 2013 à 07:51 -0700, Joe Perches a écrit :
> even more trivial...
> 
> On Wed, 2013-07-10 at 14:47 +0200, Jean Delvare wrote:
> > +++ linux-3.11-rc0/drivers/firmware/dmi_scan.c	2013-07-10 14:11:56.544792703 +0200
> > @@ -62,8 +62,6 @@ static const char * __init dmi_string(co
> >  	str = dmi_alloc(len);
> >  	if (str != NULL)
> []
> > @@ -219,10 +217,8 @@ static void __init dmi_save_one_device(i
> >  	dev = dmi_alloc(sizeof(*dev) + strlen(name) + 1);
> > +	if (!dev)
> >  		return;
> []
> > @@ -258,10 +254,8 @@ static void __init dmi_save_oem_strings_
> >  		dev = dmi_alloc(sizeof(*dev));
> > +		if (!dev)
> >  			break;
> []
> > @@ -277,18 +271,14 @@ static void __init dmi_save_ipmi_device(
> >  	data = dmi_alloc(dm->length);
> > +	if (data == NULL)
> >  		return;
> []
> >  	dev = dmi_alloc(sizeof(*dev));
> > +	if (!dev)
> >  		return;
> []
> > @@ -303,10 +293,9 @@ static void __init dmi_save_dev_onboard(
> >  	onboard_dev = dmi_alloc(sizeof(*onboard_dev) + strlen(name) + 1);
> > +	if (!onboard_dev)
> >  		return;
> 
> It'd also be nice to use the same test style
> in all 6 uses.
> 
> 	if (!foo)

Both styles are used throughout the file, and checkpatch doesn't
complain. Unifying the coding style is beyond the scope of my patchset,
sorry. Feel free to send a patch on top of mine if you really care.

-- 
Jean Delvare
Suse L3


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754451AbaCPQza (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 12:55:30 -0400
Received: from smtprelay0051.hostedemail.com ([216.40.44.51]:35231 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752187AbaCPQz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 12:55:29 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1500:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3871:3873:3874:4037:4250:4321:4362:4605:5007:6691:7652:8957:10004:10400:10848:11026:11232:11473:11658:11914:12043:12438:12517:12519:12679:12740:13069:13161:13229:13311:13357:14093:14097,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: able72_86f37a19ff561
X-Filterd-Recvd-Size: 2755
Message-ID: <1394988926.5689.39.camel@joe-AO722>
Subject: Re: [PATCH] fixing some coding style issues on line6 driver.c
From: Joe Perches <joe@perches.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Davide Berardi <berardi.dav@gmail.com>, linux-kernel@vger.kernel.org
Date: Sun, 16 Mar 2014 09:55:26 -0700
In-Reply-To: <20140316163700.GA1781@kroah.com>
References: <20140316132016.388a3f69@White-Rabbit>
	 <20140316163700.GA1781@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-03-16 at 16:37 +0000, Greg KH wrote:
> On Sun, Mar 16, 2014 at 01:20:16PM +0100, Davide Berardi wrote:
> > Fixed some over-80 characters lines.
> > (this is for eudyptula challenge task 10).
[]
> > diff --git a/drivers/staging/line6/driver.c b/drivers/staging/line6/driver.c
[]
> > @@ -59,26 +59,46 @@ MODULE_DEVICE_TABLE(usb, line6_id_table);
> >  
> >  /* *INDENT-OFF* */
> >  static struct line6_properties line6_properties_table[] = {
> > -	{ LINE6_BIT_BASSPODXT,     "BassPODxt",     "BassPODxt",        LINE6_BIT_CONTROL_PCM_HWMON },
> > -	{ LINE6_BIT_BASSPODXTLIVE, "BassPODxtLive", "BassPODxt Live",   LINE6_BIT_CONTROL_PCM_HWMON },
[]
> > +	{ LINE6_BIT_BASSPODXT,     "BassPODxt",
> > +		"BassPODxt",        LINE6_BIT_CONTROL_PCM_HWMON },
> > +	{ LINE6_BIT_BASSPODXTLIVE, "BassPODxtLive",
> > +		"BassPODxt Live",   LINE6_BIT_CONTROL_PCM_HWMON },
> 
> That looks worse, sorry, I can't take this.

Thanks Greg.

Davide, you _might_ add a simplifying macro if you really
wanted this to be a bit neater, but any gains are going
to be _very_ minor.

>  static struct line6_properties line6_properties_table[] = {
> > -	{ LINE6_BIT_BASSPODXT,     "BassPODxt",     "BassPODxt",        LINE6_BIT_CONTROL_PCM_HWMON },

The struct is:

struct line6_properties {
	int device_bit;
	const char *id;
	const char *name;
	int capabilities;
};

Here's a possible simplifying macro:

#define L6_PROP(dev, id, name, cap) \
	{.int = LINE6_BIT_##bit, .id = id, .name = name, .capabilities = LINE6_BIT_##cap}

so the entries could become:

static struct line6_properties line6_properties_table[] = {
	L6_PROP(BASSPODXT, "BassPODxt", "BassPODxt", CONTROL_PCM_HWMON),
etc.

But even that isn't necessarily better.

Probably the better improvement here would be to change
the declaration of line6_properties_table to

static const struct line6_properties line6_properties_table[] = {



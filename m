Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756897Ab3JNQRC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 12:17:02 -0400
Received: from smtprelay0029.hostedemail.com ([216.40.44.29]:32803 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756763Ab3JNQQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 12:16:59 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3871:3872:3874:4250:4321:5007:7652:10004:10400:10848:11026:11232:11473:11658:11914:12043:12438:12517:12519:12740:13069:13138:13231:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: war23_3c9ed80a55f2c
X-Filterd-Recvd-Size: 2632
Message-ID: <1381767415.25528.10.camel@joe-AO722>
Subject: Re: [PATCH v3 07/10] intel_mid: Added custom device_handler support
From: Joe Perches <joe@perches.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: David Cohen <david.a.cohen@linux.intel.com>, tglx@linutronix.de,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, platform-driver-x86@vger.kernel.org,
        Kuppuswamy Sathyanarayanan 
	<sathyanarayanan.kuppuswamy@linux.intel.com>
Date: Mon, 14 Oct 2013 09:16:55 -0700
In-Reply-To: <525C15E8.9010201@zytor.com>
References: <1381549404-22594-1-git-send-email-david.a.cohen@linux.intel.com>
	 <1381549404-22594-8-git-send-email-david.a.cohen@linux.intel.com>
	 <525C15E8.9010201@zytor.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-10-14 at 09:03 -0700, H. Peter Anvin wrote:
> On 10/11/2013 08:43 PM, David Cohen wrote:
> >  
> >  	/* MSIC subdevices */
> > -	{"msic_battery", SFI_DEV_TYPE_IPC, 1, &msic_battery_platform_data},
> > -	{"msic_gpio", SFI_DEV_TYPE_IPC, 1, &msic_gpio_platform_data},
> > -	{"msic_audio", SFI_DEV_TYPE_IPC, 1, &msic_audio_platform_data},
> > -	{"msic_power_btn", SFI_DEV_TYPE_IPC, 1, &msic_power_btn_platform_data},
> > -	{"msic_ocd", SFI_DEV_TYPE_IPC, 1, &msic_ocd_platform_data},
> > -	{"msic_thermal", SFI_DEV_TYPE_IPC, 1, &msic_thermal_platform_data},
> > -
> > +	{"msic_battery", SFI_DEV_TYPE_IPC, 1, &msic_battery_platform_data,
> > +					NULL},
> > +	{"msic_gpio", SFI_DEV_TYPE_IPC, 1, &msic_gpio_platform_data, NULL},
> > +	{"msic_audio", SFI_DEV_TYPE_IPC, 1, &msic_audio_platform_data, NULL},
> > +	{"msic_power_btn", SFI_DEV_TYPE_IPC, 1, &msic_power_btn_platform_data,
> > +					NULL},
> > +	{"msic_ocd", SFI_DEV_TYPE_IPC, 1, &msic_ocd_platform_data, NULL},
> > +	{"msic_thermal", SFI_DEV_TYPE_IPC, 1, &msic_thermal_platform_data,
> > +					NULL},
> >  	{},
> >  };
> >  
> 
> For highly regular arrays like this it is better to keep each line a
> single line even if it gets a bit too long rather than randomly breaking
> them.  The alternative is to put every field of every entry on a
> separate line, but I don't think that is necessary called for here.

True.

Another option is to #define YA macro to produce the
SFI_DEV_TYPE_IPC, 1, ... NULL that's common to all of them.



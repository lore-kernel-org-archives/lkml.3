Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837Ab3F0PVy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 11:21:54 -0400
Received: from co1ehsobe006.messaging.microsoft.com ([216.32.180.189]:36051
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752777Ab3F0PVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 11:21:52 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dI1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2dh668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1155h)
X-WSS-ID: 0MP25C8-02-IBA-02
X-M-MSG: 
Date: Thu, 27 Jun 2013 10:21:43 -0500
From: Jacob Shin <jacob.shin@amd.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: Tim Gardner <tim.gardner@canonical.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        LKML <linux-kernel@vger.kernel.org>, <cpufreq@vger.kernel.org>,
        <linux-pm@vger.kernel.org>
Subject: Re: od_set_powersave_bias: NULL pointer dereference
Message-ID: <20130627152143.GA5324@jshin-Toonie>
References: <51C87ADC.4070409@canonical.com>
 <CAKohponCrC93D88Fgg_3LKsLG0KMeCVKsTEoy-N3jsdUQdgWvA@mail.gmail.com>
 <20130625161935.GA10208@jshin-Toonie>
 <CAKohpomSa0FRviZHkkJOeUUxubbzueVb3yyP5G8ASwpRB6wANQ@mail.gmail.com>
 <20130626142852.GA2326@jshin-Toonie>
 <CAKohpom_jHQeR2FKFS3-RkxpPrJvekw8pDb-qnApnzu-VqreBQ@mail.gmail.com>
 <20130626175722.GA20226@jshin-Toonie>
 <CAKohpo=UTmpLmyQs5+xLNnCLMCeZHNQT3USjmK1NTaFJLNQg-Q@mail.gmail.com>
 <20130627145505.GA3076@jshin-Toonie>
 <CAKohpomSNGn1wTzbCxpHN5fu2L6mJ1fnhvt2uLBWLgQE8fS6Rg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAKohpomSNGn1wTzbCxpHN5fu2L6mJ1fnhvt2uLBWLgQE8fS6Rg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27, 2013 at 08:39:12PM +0530, Viresh Kumar wrote:
> On 27 June 2013 20:25, Jacob Shin <jacob.shin@amd.com> wrote:
> > diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
> > index 4b9bb5d..93eb5cb 100644
> > --- a/drivers/cpufreq/cpufreq_ondemand.c
> > +++ b/drivers/cpufreq/cpufreq_ondemand.c
> > @@ -47,6 +47,8 @@ static struct od_ops od_ops;
> >  static struct cpufreq_governor cpufreq_gov_ondemand;
> >  #endif
> >
> > +static unsigned int default_powersave_bias;
>
> Why are the above three changes required? And in case they are, then
> they must have been commited separately.
> 
> Because you haven't replied to my earlier comment on this, I
> thought you agreed. But it looks you haven't read my first
> reply well.

Sorry I totally missed it,

I was trying to account for the case when od_set_powersave_bias() is
called while ondemand is not the current governor. And then later
becomes the current governor. So when od_init() is called it will take
the expected default, rather than 0.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752299Ab3FZOgH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 10:36:07 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:17175 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751271Ab3FZOgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 10:36:05 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz98dI1432I4015Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2dh668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1155h)
X-WSS-ID: 0MP08JX-02-7XZ-02
X-M-MSG: 
Date: Wed, 26 Jun 2013 09:35:55 -0500
From: Jacob Shin <jacob.shin@amd.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: Tim Gardner <tim.gardner@canonical.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        LKML <linux-kernel@vger.kernel.org>, <cpufreq@vger.kernel.org>,
        <linux-pm@vger.kernel.org>
Subject: Re: od_set_powersave_bias: NULL pointer dereference
Message-ID: <20130626143555.GA2989@jshin-Toonie>
References: <51C87ADC.4070409@canonical.com>
 <CAKohponCrC93D88Fgg_3LKsLG0KMeCVKsTEoy-N3jsdUQdgWvA@mail.gmail.com>
 <20130625161935.GA10208@jshin-Toonie>
 <CAKohpomSa0FRviZHkkJOeUUxubbzueVb3yyP5G8ASwpRB6wANQ@mail.gmail.com>
 <20130626142852.GA2326@jshin-Toonie>
 <CAKohpom_jHQeR2FKFS3-RkxpPrJvekw8pDb-qnApnzu-VqreBQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAKohpom_jHQeR2FKFS3-RkxpPrJvekw8pDb-qnApnzu-VqreBQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 08:02:29PM +0530, Viresh Kumar wrote:
> On 26 June 2013 19:58, Jacob Shin <jacob.shin@amd.com> wrote:
> > On Wed, Jun 26, 2013 at 12:18:27PM +0530, Viresh Kumar wrote:
> 
> >> I am not sure if this is enough. What if we had ondemand as the
> >> governor initially, then we changed it to something else. Now also
> >> cur_policy contains a address and isn't zero.
> >
> > Right, so we check below ..
> >
> >>
> >> >                 cpumask_or(&done, &done, policy->cpus);
> >> > +
> >> > +               if (policy->governor != &cpufreq_gov_ondemand)
> >> > +                       continue;
> >
> > This should catch that case no ?
> 
> Policy might be freed and reallocated by then. And so doing
> policy->governor is dangerous.

Hm . any hints on how to check for if ondemand is running on this CPU
or not ? I'm not sure what the best way to handle this is ..

Thanks,


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854Ab3FZR5c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 13:57:32 -0400
Received: from mail-db9lp0251.outbound.messaging.microsoft.com ([213.199.154.251]:8186
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752759Ab3FZR5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 13:57:31 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dI1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2dh668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1155h)
X-WSS-ID: 0MP0HVN-02-N88-02
X-M-MSG: 
Date: Wed, 26 Jun 2013 12:57:22 -0500
From: Jacob Shin <jacob.shin@amd.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: Tim Gardner <tim.gardner@canonical.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        LKML <linux-kernel@vger.kernel.org>, <cpufreq@vger.kernel.org>,
        <linux-pm@vger.kernel.org>
Subject: Re: od_set_powersave_bias: NULL pointer dereference
Message-ID: <20130626175722.GA20226@jshin-Toonie>
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
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
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

I just tested this case with this patch applied, and did not have any
problems.

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

Are you worried that after we have passed the above if check, and
before we access ->tuner governor change might occur?

Is there something synonymous to get/put_online_cpus() for cpufreq to
prevent governor change while we update ->tuner values?

Otherwise, should just spinlock?


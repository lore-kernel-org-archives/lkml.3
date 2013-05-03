Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762097Ab3ECMjl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 08:39:41 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:56484 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761757Ab3ECMjk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 08:39:40 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, linaro-kernel@lists.linaro.org,
        patches@linaro.org, cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com
Subject: Re: [PATCH V2] cpufreq: cpu0: Free parent node for error cases
Date: Fri, 03 May 2013 14:47:58 +0200
Message-ID: <455891364.DU1qQaFqNq@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130503060327.GA19902@S2101-09.ap.freescale.net>
References: <03c6b0e0f41238c1b4346b4186040ff69e369b4a.1367556239.git.viresh.kumar@linaro.org> <20130503060327.GA19902@S2101-09.ap.freescale.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 03, 2013 02:03:29 PM Shawn Guo wrote:
> On Fri, May 03, 2013 at 10:14:25AM +0530, Viresh Kumar wrote:
> > We are freeing parent node in success cases but not in failure cases. Lets do
> > it.
> > 
> > Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> 
> Acked-by: Shawn Guo <shawn.guo@linaro.org>

OK, queued up for the v3.10-rc2 push.

Thanks,
Rafael


> > ---
> >  drivers/cpufreq/cpufreq-cpu0.c | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/cpufreq/cpufreq-cpu0.c b/drivers/cpufreq/cpufreq-cpu0.c
> > index 3ab8294..8565d41 100644
> > --- a/drivers/cpufreq/cpufreq-cpu0.c
> > +++ b/drivers/cpufreq/cpufreq-cpu0.c
> > @@ -189,7 +189,8 @@ static int cpu0_cpufreq_probe(struct platform_device *pdev)
> >  
> >  	if (!np) {
> >  		pr_err("failed to find cpu0 node\n");
> > -		return -ENOENT;
> > +		ret = -ENOENT;
> > +		goto out_put_parent;
> >  	}
> >  
> >  	cpu_dev = &pdev->dev;
> > @@ -264,6 +265,8 @@ out_free_table:
> >  	opp_free_cpufreq_table(cpu_dev, &freq_table);
> >  out_put_node:
> >  	of_node_put(np);
> > +out_put_parent:
> > +	of_node_put(parent);
> >  	return ret;
> >  }
> >  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe cpufreq" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

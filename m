Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647Ab3AZWSI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 17:18:08 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:56714 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754401Ab3AZWSF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 17:18:05 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Mark Langsdorf <mark.langsdorf@calxeda.com>, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 4/4] cpufreq, highbank: add support for highbank cpufreq
Date: Sat, 26 Jan 2013 23:24:12 +0100
Message-ID: <1523559.2KevGvelzH@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc5; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130126143950.GA7079@S2101-09.ap.freescale.net>
References: <1351631056-25938-1-git-send-email-mark.langsdorf@calxeda.com> <1359143205-20279-5-git-send-email-mark.langsdorf@calxeda.com> <20130126143950.GA7079@S2101-09.ap.freescale.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, January 26, 2013 10:39:53 PM Shawn Guo wrote:
> Mark,
> 
> On Fri, Jan 25, 2013 at 01:46:45PM -0600, Mark Langsdorf wrote:
> > +static int hb_cpufreq_driver_init(void)
> > +{
> > +	struct device *cpu_dev;
> > +	struct clk *cpu_clk;
> > +	struct device_node *np;
> > +	int ret;
> > +
> > +	for_each_child_of_node(of_find_node_by_path("/cpus"), np)
> > +		if (of_get_property(np, "operating-points", NULL))
> > +			break;
> > +
> > +	if (!np) {
> > +		pr_err("failed to find highbank cpufreq node\n");
> > +		return -ENOENT;
> > +	}
> > +
> ...
> > +out_put_node:
> > +	of_node_put(np);
> > +	return ret;
> > +}
> > +module_init(hb_cpufreq_driver_init);
> 
> As we are moving to multiplatform build, this init function will run
> on all other platforms built together with highbank.  We should
> probably eliminate that effect.

That change can be made on top of the Mark's patches I think, right?

If so, I'd prefer it that way.  The Mark's patches have been in a limbo for
too long already and that issue doesn't seem to be serious enough to block
them any longer.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

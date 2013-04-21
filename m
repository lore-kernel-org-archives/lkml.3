Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283Ab3DUXXa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 19:23:30 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:40202 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751264Ab3DUXX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 19:23:28 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        robin.randhawa@arm.com, Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        linaro-kernel@lists.linaro.org, patches@linaro.org
Subject: Re: [PATCH] cpufreq: cpu0: Put cpu parent node after using it
Date: Mon, 22 Apr 2013 01:31:30 +0200
Message-ID: <3264633.p6VbhCnLVY@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc8+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130416084013.GB11245@S2101-09.ap.freescale.net>
References: <377acb684be024176e1c64f7ca5b1937c3a23878.1366009701.git.viresh.kumar@linaro.org> <20130416084013.GB11245@S2101-09.ap.freescale.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 16, 2013 04:40:15 PM Shawn Guo wrote:
> On Mon, Apr 15, 2013 at 12:39:37PM +0530, Viresh Kumar wrote:
> > Parent node must be put after using it to balance its usage count. This was
> > missing in cpufreq-cpu0 driver. Fix it.
> > 
> > Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> 
> Acked-by: Shawn Guo <shawn.guo@linaro.org>

Applied.

Thanks,
Rafael


> > ---
> >  drivers/cpufreq/cpufreq-cpu0.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/cpufreq/cpufreq-cpu0.c b/drivers/cpufreq/cpufreq-cpu0.c
> > index 31282fc..3ab8294 100644
> > --- a/drivers/cpufreq/cpufreq-cpu0.c
> > +++ b/drivers/cpufreq/cpufreq-cpu0.c
> > @@ -257,6 +257,7 @@ static int cpu0_cpufreq_probe(struct platform_device *pdev)
> >  	}
> >  
> >  	of_node_put(np);
> > +	of_node_put(parent);
> >  	return 0;
> >  
> >  out_free_table:
> 
> --
> To unsubscribe from this list: send the line "unsubscribe cpufreq" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

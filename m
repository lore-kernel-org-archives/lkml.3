Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475AbaETM2a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 08:28:30 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:61483 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752940AbaETM23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 08:28:29 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Nishanth Menon <nm@ti.com>, Chander Kashyap <chander.kashyap@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pavel Machek <pavel@ucw.cz>, "Brown, Len" <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chander Kashyap <k.chander@samsung.com>,
        Inderpal Singh <inderpal.s@samsung.com>
Subject: Re: [PATCH v3] PM / OPP: discard duplicate OPPs
Date: Tue, 20 May 2014 14:45:24 +0200
Message-ID: <2638341.ymNLNAMmAG@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAKohpomKvPcioNmfzvx7vqJHqs_TrhnHH6yYb5w_0f+YvA5hvA@mail.gmail.com>
References: <1400230809-11401-1-git-send-email-chander.kashyap@linaro.org> <CAKohponAx=Hi_Ywgg4hXxrpmmaqy5=pYnb3nSBNUP3KtADTEeA@mail.gmail.com> <CAKohpomKvPcioNmfzvx7vqJHqs_TrhnHH6yYb5w_0f+YvA5hvA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, May 20, 2014 05:35:04 PM Viresh Kumar wrote:
> On 20 May 2014 16:56, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> > But we aren't talking about failure here. Its not failure. The operation
> > we are trying to do is already done and nothing should break if the
> > OPP was already there or its added now. Its all the same.
> 
> Though after more thought into this I feel this must also be done:
> 
> diff --git a/drivers/base/power/opp.c b/drivers/base/power/opp.c
> index bdf09f5..3f540d8 100644
> --- a/drivers/base/power/opp.c
> +++ b/drivers/base/power/opp.c
> @@ -453,9 +453,13 @@ int dev_pm_opp_add(struct device *dev, unsigned
> long freq, unsigned long u_volt)
>         }
> 
>         if (new_opp->rate == opp->rate) {
> +               int ret = 0;

		int ret = new_opp->u_volt == opp->u_volt ? -EEXIST : 0;

would be slightly simpler IMO.

> +
> +               if (new_opp->u_volt == opp->u_volt)
> +                       ret = -EEXIST;
>                 mutex_unlock(&dev_opp_list_lock);
>                 kfree(new_opp);
> -               return 0;
> +               return ret;

>         }
> 
>         list_add_rcu(&new_opp->node, head);


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

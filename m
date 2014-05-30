Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932249AbaE3MFt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 08:05:49 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:59046 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751955AbaE3MFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 08:05:47 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Sachin Kamat <sachin.kamat@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>
Cc: Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, arvind.chauhan@arm.com,
        inderpal.s@samsung.com, Nishanth Menon <nm@ti.com>,
        Chander Kashyap <chander.kashyap@linaro.org>,
        Pavel Machek <pavel@ucw.cz>, len.brown@intel.com, sudeep.holla@arm.com
Subject: Re: [PATCH V4 2/8] opp: call of_node_{get|put}() from of_init_opp_table()
Date: Fri, 30 May 2014 14:22:55 +0200
Message-ID: <2049073.iShziF2J0h@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAK9yfHw1HSX_idrFGO5P0bxxwf8iyd1J7MfNyqHGa45E-ZbZww@mail.gmail.com>
References: <cover.1401191054.git.viresh.kumar@linaro.org> <4139797fe7501ba99adf63ec8e5cf9fa9b24c197.1401191054.git.viresh.kumar@linaro.org> <CAK9yfHw1HSX_idrFGO5P0bxxwf8iyd1J7MfNyqHGa45E-ZbZww@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 30, 2014 12:03:08 PM Sachin Kamat wrote:
> Hi Viresh,
> 
> On 27 May 2014 17:20, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> > All callers of of_init_opp_table() are required to take reference of
> > dev->of_node, by initiating calls to of_node_{get|put}(), before and after
> > calling of_init_opp_table().
> >
> > Its better to call these from within of_init_opp_table(), no fun adding
> > redundant code to every caller.
> >
> > Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> > ---
> >  drivers/base/power/opp.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> >
> > diff --git a/drivers/base/power/opp.c b/drivers/base/power/opp.c
> > index faae9cf..2b615b9 100644
> > --- a/drivers/base/power/opp.c
> > +++ b/drivers/base/power/opp.c
> > @@ -622,6 +622,9 @@ int of_init_opp_table(struct device *dev)
> >         const __be32 *val;
> >         int nr;
> >
> > +       if (!of_node_get(dev->of_node))
> > +               return -ENODEV;
> > +
> >         prop = of_find_property(dev->of_node, "operating-points", NULL);
> >         if (!prop)
> >                 return -ENODEV;
> 
> What about of_node_put before returning here and other places in this function?

Yeah, that needs to be fixed.

The rest of the series looks good to me, so Viresh, please fix this one ASAP and
send an update (of this particular patch only).

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

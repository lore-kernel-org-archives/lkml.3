Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932613AbaIDAxU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 20:53:20 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:34918 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755150AbaIDAxT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 20:53:19 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Stephen Boyd <sboyd@codeaurora.org>,
        "Tomeu Vizoso" <tomeu.vizoso@collabora.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <5407A6B9.1080606@codeaurora.org>
Cc: "Stephen Warren" <swarren@wwwdotorg.org>,
        "Peter De Schrijver" <pdeschrijver@nvidia.com>,
        linux-kernel@vger.kernel.org, tomasz.figa@gmail.com, rabin@rab.in,
        "Thierry Reding" <thierry.reding@gmail.com>,
        "Javier Martinez Canillas" <javier.martinez@collabora.co.uk>,
        linux-arm-kernel@lists.infradead.org
References: <1409758148-20104-1-git-send-email-tomeu.vizoso@collabora.com>
 <1409758434-20810-1-git-send-email-tomeu.vizoso@collabora.com>
 <1409758434-20810-3-git-send-email-tomeu.vizoso@collabora.com>
 <5407A6B9.1080606@codeaurora.org>
Message-ID: <20140904005305.11368.16931@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH v9 5/6] clk: Add floor and ceiling constraints to clock rates
Date: Wed, 03 Sep 2014 17:53:05 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Stephen Boyd (2014-09-03 16:39:37)
> On 09/03/14 08:33, Tomeu Vizoso wrote:
> > +int clk_set_ceiling_rate(struct clk *clk_user, unsigned long rate)
> > +{
> > +     struct clk_core *clk = clk_to_clk_core(clk_user);
> > +
> > +     WARN(rate > 0 && rate < clk_user->floor_constraint,
> > +          "clk %s dev %s con %s: new ceiling %lu lower than existing floor %lu\n",
> > +          __clk_get_name(clk), clk_user->dev_id, clk_user->con_id, rate,
> > +          clk_user->floor_constraint);
> > +
> > +     clk_user->ceiling_constraint = rate;
> > +     return clk_provider_set_rate(clk, clk_provider_get_rate(clk));
> > +}
> > +EXPORT_SYMBOL_GPL(clk_set_ceiling_rate);
> 
> Maybe I'm late to this patch series given that Mike applied it, but I
> wonder why we wouldn't just have one API that takes a min and a max,
> i.e. clk_set_rate_range(clk, min, max)? Then clk_set_rate() is a small
> wrapper on top that just sets min and max to the same value.

We certainly can have that. But being able to easily adjust a floor or
ceiling value seems like a good thing to me, and that is what these
functions do.

If we decide to have a clk_set_rate_range (where we perhaps pass zero in
for a value that we do not wish to constrain) then I imagine that
clk_set_ceiling_rate and clk_set_floor_rate will simply become a wrapper
for that function. No harm having it both ways. If one way of doing
things falls out of favor we can always cull it and update all the
users.

Regards,
Mike

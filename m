Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758208Ab3CTJuK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 05:50:10 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:18130 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620Ab3CTJuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 05:50:08 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 20 Mar 2013 02:50:01 -0700
Date: Wed, 20 Mar 2013 11:49:57 +0200
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Mike Turquette <mturquette@linaro.org>
CC: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "Stephen Warren" <swarren@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] clk: add table lookup to mux
Message-ID: <20130320094957.GG18519@tbergstrom-lnx.Nvidia.com>
References: <1363113747-6572-1-git-send-email-pdeschrijver@nvidia.com>
 <20130319235110.8663.67548@quantum>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130319235110.8663.67548@quantum>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 12:51:10AM +0100, Mike Turquette wrote:
> Quoting Peter De Schrijver (2013-03-12 11:42:23)
> > diff --git a/include/linux/clk-private.h b/include/linux/clk-private.h
> > index 9c7f580..53d39c2 100644
> > --- a/include/linux/clk-private.h
> > +++ b/include/linux/clk-private.h
> > @@ -144,12 +144,13 @@ struct clk {
> >  
> >  #define DEFINE_CLK_MUX(_name, _parent_names, _parents, _flags, \
> >                                 _reg, _shift, _width,           \
> > -                               _mux_flags, _lock)              \
> > +                               _mux_flags, _table, _lock)      \
> >         static struct clk _name;                                \
> >         static struct clk_mux _name##_hw = {                    \
> >                 .hw = {                                         \
> >                         .clk = &_name,                          \
> >                 },                                              \
> > +               .table = _table,                                \
> >                 .reg = _reg,                                    \
> >                 .shift = _shift,                                \
> >                 .width = _width,                                \
> 
> This breaks OMAP horribly since OMAP already uses this macro.  There are
> two options:
> 
> 1) stop using statically initialized data and no longer use
> clk-private.h macros.  I was under the impression that the tegra clock
> data no longer required this?

Ok. We don't do that anymore. Maybe I just modified it out of habbit...

> 
> 2) if you must continue to use the clk-private.h macros (temporarily!)
> then create a new one, DEFINE_CLK_MUX_TABLE.

Hopefully not needed.

Cheers,

Peter.

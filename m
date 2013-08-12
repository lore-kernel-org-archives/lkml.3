Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755576Ab3HLFpe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 01:45:34 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:7491 "EHLO
	mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750843Ab3HLFpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 01:45:32 -0400
X-IronPort-AV: E=Sophos;i="4.89,859,1367964000"; 
   d="scan'208";a="23742026"
Date: Mon, 12 Aug 2013 07:45:26 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Viresh Kumar <viresh.kumar@linaro.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, kernel-janitors@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/16] drivers/cpufreq/pxa3xx-cpufreq.c: Avoid using
 ARRAY_AND_SIZE(e) as a function argument
In-Reply-To: <CAKohpo=MfrUTYQKvJHP1Gns3kUfjqG6r9T8+7ZZ98-8yb0BZXw@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1308120743030.2038@localhost6.localdomain6>
References: <1376239917-15594-1-git-send-email-Julia.Lawall@lip6.fr> <1376239917-15594-13-git-send-email-Julia.Lawall@lip6.fr> <CAKohpo=MfrUTYQKvJHP1Gns3kUfjqG6r9T8+7ZZ98-8yb0BZXw@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 12 Aug 2013, Viresh Kumar wrote:

> On 11 August 2013 22:21, Julia Lawall <Julia.Lawall@lip6.fr> wrote:
> > From: Julia Lawall <Julia.Lawall@lip6.fr>
> >
> > Replace ARRAY_AND_SIZE(e) in function argument position to avoid hiding the
> > arity of the called function.
> 
> Makes sense.
> 
> > The semantic match that makes this change is as follows:
> > (http://coccinelle.lip6.fr/)
> 
> What is this doing here?

I'm not sure to understand the sense of the question.  The semantic patch 
explains exactly what considerations were used when making the 
transformation.  That is, any function call, having a call to 
ARRAY_AND_SIZE as an argument is rewritten to replace the call to 
ARRAY_AND_SIZE with the correspondingtwo arguments.  The transformation 
was performed entirely automatically, although in a lot of cases it was 
necessary to add newlines afterwards.

julia

> > // <smpl>
> > @@
> > expression e,f;
> > @@
> >
> > f(...,
> > - ARRAY_AND_SIZE(e)
> > + e,ARRAY_SIZE(e)
> >   ,...)
> > // </smpl>
> >
> > Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> >
> > ---
> > Not compiled.
> >
> >  drivers/cpufreq/pxa3xx-cpufreq.c |    6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

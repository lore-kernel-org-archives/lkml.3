Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751762AbaIJOGu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 10:06:50 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:5318 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751637AbaIJOGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 10:06:48 -0400
X-IronPort-AV: E=Sophos;i="5.04,499,1406584800"; 
   d="scan'208";a="93972454"
Date: Wed, 10 Sep 2014 16:06:01 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Joe Perches <joe@perches.com>
cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>, devel@driverdev.osuosl.org,
        "Dilger, Andreas" <andreas.dilger@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peng Tao <bergwolf@gmail.com>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Drokin, Oleg" <oleg.drokin@intel.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Andy Whitcroft <apw@canonical.com>
Subject: Re: [PATCH] checkpatch: Warn on macros with flow control
 statements
In-Reply-To: <1410357331.24028.39.camel@joe-AO725>
Message-ID: <alpine.DEB.2.10.1409101604210.4747@hadrien>
References: <1410106715-9573-6-git-send-email-Julia.Lawall@lip6.fr>  <20140909125410.GJ6549@mwanda> <1410295093.12560.60.camel@joe-AO725>  <20140910084306.GV6600@mwanda> <1410357331.24028.39.camel@joe-AO725>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Sep 2014, Joe Perches wrote:

> On Wed, 2014-09-10 at 11:43 +0300, Dan Carpenter wrote:
> > On Tue, Sep 09, 2014 at 01:38:13PM -0700, Joe Perches wrote:
> > > Macros with flow control statements (goto and return) are
> > > not very nice to read as any flow movement is unexpected.
>
> break and continue are also flow control statements
> but are those are frequently used in macros in
> complete switch statements so were not added.

Would it be possible to make a warning when there is a break or continue
but no while/switch/etc.

julia

> > > Try to highlight them and emit a warning on their definition.
> > >
> > > Avoid warning on macros that use argument concatenation as
> > > those macros commonly create another function where the
> > > concatenation is used in the function name definition like:
> > > 	#define FOO_FUNC(name, rtn_type)	\
> > > 	rtn_type func##name(arg1, ...)		\
> > > 	{					\
> > > 		rtn_type rtn;			\
> > > 		[code...]			\
> > > 		return rtn;			\
> > > 	}
> > >
> >
> > It adds 382 new warnings.
>
> Thanks for running it over the tree.
>
> > The '##' trick doesn't remove all then macros which create functions.
> > I can't think of a better way to do that though.
>
> Nor I.  I suppose it could be a --strict CHK and not
> a WARN message type though.
>
> > We will eventually get rid of almost all the warnings in staging.  The
> > one that makes sense to keep is:
> >
> > drivers/staging/lustre/lnet/selftest/selftest.h:559
> > #define STATE2STR(x) case x: return #x
>
> Yup, there are a few of those and they should
> definitely stay.
>
> > My guess is that other maintainers won't be as excited to change these...
>
> Do maintainers ever get excited about style?
>
> > Some of the macros have "RETURN", "RET" or "EXIT" in the name so the
> > return is not really hidden.
>
> Not sure what to do about that.
>
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

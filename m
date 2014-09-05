Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993AbaIEWid (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 18:38:33 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:58747 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751948AbaIEWic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 18:38:32 -0400
X-Sasl-enc: kJ+uF/OdQ3JwJyVd9cm5lhSqMKGZRCedKrM8jx7ib4p8 1409956711
Message-ID: <1409956708.5306.35.camel@localhost>
Subject: Re: [PATCH] gcc: clamp gcc version to most highest specific header
 version available
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Sasha Levin <sasha.levin@oracle.com>, akpm@linuxfoundation.org,
        mingo@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Richard Weinberger <richard.weinberger@gmail.com>
Date: Sat, 06 Sep 2014 00:38:28 +0200
In-Reply-To: <1409951364.2618.28.camel@joe-AO725>
References: <5409CC39.3060608@oracle.com>
	 <8bf23840962ec5a33b1bfae7fdf8b0a0f94c4227.1409949573.git.hannes@stressinduktion.org>
	 <1409951364.2618.28.camel@joe-AO725>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fr, 2014-09-05 at 14:09 -0700, Joe Perches wrote:
> On Fri, 2014-09-05 at 22:39 +0200, Hannes Frederic Sowa wrote:
> > As announced in [1] gcc will increase its major number yearly but we don't
> > need to include gcc version specific quirks for every version normally.
> > 
> > This patch allows to compile every kernel with all new versions of gcc
> > without adding a specific compiler-gccX.h header. We do so by clamping
> > the __GNUC__ version to the most specific version dependent header file.
> > 
> > If someone adds a new gccX.h file __GCC_CLAMP_VERSION_HEADER also needs
> > to be modified.
> > 
> > The decision if chained including of header files (e.g. gcc5.h includes
> > gcc4.h) is necessary or should be avoided can be postponed until more
> > experience in using the official gcc release is gained.
> 
> I think the churn rate in the gcc compiler specific
> #include headers will be low enough that a single
> combined file should be acceptable.
> 
> Keeping all the gcc #defines together seems more
> readable to me.
> 
> The trivial integration I did eliminated one
> duplicate #define as well as that hack for
> #include gcc_header(__GNUC__)

It's just a proposal and I don't have a strong opinion on that. I just
want to make sure it is easy to compile current kernel with a gcc
released in two years. ;)

Bye,
Hannes



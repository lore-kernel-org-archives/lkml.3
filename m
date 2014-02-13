Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824AbaBMU4F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 15:56:05 -0500
Received: from smtp0.kfki.hu ([148.6.0.25]:51262 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751252AbaBMU4D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 15:56:03 -0500
Date: Thu, 13 Feb 2014 21:55:58 +0100 (CET)
From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Florian Westphal <fw@strlen.de>
cc: Ilia Mirkin <imirkin@alum.mit.edu>, Patrick McHardy <kaber@trash.net>,
        Cong Wang <cwang@twopensource.com>, netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vitaly Lavrov <lve@guap.ru>
Subject: Re: ip_set: protocol %u message -- useful?
In-Reply-To: <20140213195908.GK25153@breakpoint.cc>
Message-ID: <alpine.DEB.2.10.1402132155120.18671@blackhole.kfki.hu>
References: <CAKb7UvhsLi2Sv4SWA2nVTgoFV8dzrY=3R1-SUk9D-aa0VdizSA@mail.gmail.com> <alpine.DEB.2.10.1402131117120.16734@blackhole.kfki.hu> <CAHA+R7MeEEfqz-7RhCUjsoWPx_BKHVXFV3Y32xjf0B1WwjNdRQ@mail.gmail.com> <20140213184254.GF14175@macbook.localnet>
 <CAKb7UvjdPco0zrP9Ry4mPv40r-bnfNgKEfwcOvJb4JU-5XcTaw@mail.gmail.com> <20140213195908.GK25153@breakpoint.cc>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Feb 2014, Florian Westphal wrote:

> Ilia Mirkin <imirkin@alum.mit.edu> wrote:
> > > Maybe printing "using protocol version X" will make it appear less like
> > > a debugging message referring to packet contents or something similar.
> > 
> > With pr_info it'll still appear in dmesg, and it'll still be "random
> > non-sensical message appears over and over in dmesg" type of
> > situation, to the vast majority of users. Do we need a print every
> > time someone creates a new tcp connection too? I'm still not totally
> > clear on the cause of this message getting printed, but I was seeing
> > it a whole bunch in my configuration...
> 
> Yes, because it erronously got moved into the netns init function.
> 
> And thats what causes the spew.  Moving it back into module init
> function should be enough.

Florian has got right, that'd be the best.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary

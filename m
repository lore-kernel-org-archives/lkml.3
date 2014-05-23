Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751236AbaEWTza (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 15:55:30 -0400
Received: from mail.kernel.org ([198.145.19.201]:48699 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751064AbaEWTz0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 15:55:26 -0400
Date: Fri, 23 May 2014 16:55:22 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: David Miller <davem@davemloft.net>
Cc: mtk.manpages@gmail.com, linux-kernel@vger.kernel.org,
        linux-man@vger.kernel.org, netdev@vger.kernel.org, neleai@seznam.cz,
        caitlin.bestler@gmail.com, nhorman@tuxdriver.com,
        eliedebrauwer@gmail.com, steve@chygwyn.com,
        remi.denis-courmont@nokia.com, paul@paul-moore.com,
        chris.friesen@windriver.com
Subject: Re: [PATCH/RFC] Re: recvmmsg() timeout behavior strangeness [RESEND]
Message-ID: <20140523195522.GH2741@kernel.org>
References: <CAKgNAkgA_xTfRZhpyVwuACpCY7xMK89e0bK4PuVMG9reNV6Skw@mail.gmail.com>
 <20140512143451.GB13801@kernel.org>
 <20140521210535.GA5414@kernel.org>
 <20140523.150055.2214666905697701415.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140523.150055.2214666905697701415.davem@davemloft.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, May 23, 2014 at 03:00:55PM -0400, David Miller escreveu:
> From: Arnaldo Carvalho de Melo <acme@kernel.org>
> Date: Wed, 21 May 2014 18:05:35 -0300

> > But after thinking a bit more, looks like we need to do that, please
> > take a look at the attached patch to see if it addresses the problem.

> > Mostly it adds a new timeop to the per protocol recvmsg()
> > implementations, that, if not NULL, should be used instead of
> > SO_RCVTIMEO.

> > since the underlying recvmsg implementations already check that timeout,
> > return what is remaining, that will then be used in subsequent recvmsg
> > calls, at the end we just convert it back to timespec format.

> > In most cases it is just passed to skb_recv_datagram, that will check
> > the pointer, use it and update if not NULL.

> > Should have no problems, but I only did a boot with a system with this
> > patch applied, no problems noticed on a normal desktop session, ssh,
> > etc.
 
> This looks fine to me, but I have a small request:
 
> +	return noblock ? 0 : timeop ? *timeop : sk->sk_rcvtimeo;
 
> I keep forgetting which way these expressions associate, so if you could
> parenthesize the innermost ?: I'd appreciate it. :)

Ok, I actually wrote a sample program to verify that these ternaries did
what I meant 8)

I'll finish the cset log and do this clarification change.

Would be great to get Acked-by tags from the original reporter, Michael
and whoever had a look at this change, if possible. Michael, Elie?
 
> Thanks!

Thanks a lot for reviewing it!

- Arnaldo

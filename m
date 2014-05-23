Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751377AbaEWTBA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 15:01:00 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:54671 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbaEWTA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 15:00:58 -0400
Date: Fri, 23 May 2014 15:00:55 -0400 (EDT)
Message-Id: <20140523.150055.2214666905697701415.davem@davemloft.net>
To: acme@kernel.org
Cc: mtk.manpages@gmail.com, linux-kernel@vger.kernel.org,
        linux-man@vger.kernel.org, netdev@vger.kernel.org, neleai@seznam.cz,
        caitlin.bestler@gmail.com, nhorman@tuxdriver.com,
        eliedebrauwer@gmail.com, steve@chygwyn.com,
        remi.denis-courmont@nokia.com, paul@paul-moore.com,
        chris.friesen@windriver.com
Subject: Re: [PATCH/RFC] Re: recvmmsg() timeout behavior strangeness
 [RESEND]
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140521210535.GA5414@kernel.org>
References: <CAKgNAkgA_xTfRZhpyVwuACpCY7xMK89e0bK4PuVMG9reNV6Skw@mail.gmail.com>
	<20140512143451.GB13801@kernel.org>
	<20140521210535.GA5414@kernel.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 23 May 2014 12:00:57 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@kernel.org>
Date: Wed, 21 May 2014 18:05:35 -0300

> But after thinking a bit more, looks like we need to do that, please
> take a look at the attached patch to see if it addresses the problem.
> 
> Mostly it adds a new timeop to the per protocol recvmsg()
> implementations, that, if not NULL, should be used instead of
> SO_RCVTIMEO.
> 
> since the underlying recvmsg implementations already check that timeout,
> return what is remaining, that will then be used in subsequent recvmsg
> calls, at the end we just convert it back to timespec format.
> 
> In most cases it is just passed to skb_recv_datagram, that will check
> the pointer, use it and update if not NULL.
> 
> Should have no problems, but I only did a boot with a system with this
> patch applied, no problems noticed on a normal desktop session, ssh,
> etc.

This looks fine to me, but I have a small request:

+	return noblock ? 0 : timeop ? *timeop : sk->sk_rcvtimeo;

I keep forgetting which way these expressions associate, so if you could
parenthesize the innermost ?: I'd appreciate it. :)

Thanks!

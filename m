Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558AbaELXDz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 19:03:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39785 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbaELXDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 19:03:53 -0400
Date: Mon, 12 May 2014 16:03:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: George Spelvin <linux@horizon.com>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com,
        torvalds@linux-foundation.org
Subject: Re: [PATCH 1/2] Add lib/glob.c
Message-Id: <20140512160351.c0f7b25d7fa79e1cb19d6a79@linux-foundation.org>
In-Reply-To: <20140510122138.GA4721@mtj.dyndns.org>
References: <20140313121032.GA9981@htj.dyndns.org>
	<20140510031356.22726.qmail@ns.horizon.com>
	<20140510122138.GA4721@mtj.dyndns.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 May 2014 08:21:38 -0400 Tejun Heo <tj@kernel.org> wrote:

> > +int
> > +main(void)
> > +{
> > +	size_t i;
> > +
> > +	for (i = 0; i < sizeof(tests)/sizeof(*tests); i++)
> > +		test(tests + i);
> > +
> > +	return 0;
> > +}
> > +
> > +#endif	/* UNITTEST */
> 
> Again, I don't really think the userland testing code belongs here.
> If you wanna keep them, please make it in-kernel selftesting.  We
> don't really wanna keep code which can't get built and tested in
> kernel tree proper.

If the tests don't measurably increase boot times we could run them
unconditionally at boot.  Mark everything __init/__initdata and
the costs are very low.  lib/plist.c does this.

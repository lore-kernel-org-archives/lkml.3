Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752362AbaF3VRq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 17:17:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41829 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbaF3VRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 17:17:45 -0400
Date: Mon, 30 Jun 2014 14:17:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: Fabian Frederick <fabf@skynet.be>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 1/1] proc: constify seq_operations
Message-Id: <20140630141744.d7c29bf0d7e94e7ee3c4dd79@linux-foundation.org>
In-Reply-To: <1404162545.2717.14.camel@joe-AO725>
References: <1404154997-15490-1-git-send-email-fabf@skynet.be>
	<20140630133939.c24cd71919cd28c90992d6e1@linux-foundation.org>
	<1404161370.2717.10.camel@joe-AO725>
	<20140630135744.51ebff73c7e396f1c50f0c81@linux-foundation.org>
	<1404162545.2717.14.camel@joe-AO725>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jun 2014 14:09:05 -0700 Joe Perches <joe@perches.com> wrote:

> On Mon, 2014-06-30 at 13:57 -0700, Andrew Morton wrote:
> > On Mon, 30 Jun 2014 13:49:30 -0700 Joe Perches <joe@perches.com> wrote:
> 
> > > It moves ~100 bytes from data to text
> 
> > > $ size kernel/user_namespace.o*
> > >    text    data     bss     dec     hex filename
> > >    6676    3107    2248   12031    2eff kernel/user_namespace.o.new
> > >    6580    3211    2248   12039    2f07 kernel/user_namespace.o.old
> 
> > doh, I only looked at base.o.
> > 
> > I added this to the changelog.  It should have been there originally,
> > please.
> > 
> >    text    data     bss     dec     hex filename
> >    6817     404    1984    9205    23f5 kernel/user_namespace.o-before
> >    6913     308    1984    9205    23f5 kernel/user_namespace.o-after
> 
> The delta in our object sizes in curious.
> 
> x86-64 allyesconfig here.
> What gcc version for you?

gcc-4.4.4 allmodconfig, minus CONFIG_DEBUG_INFO 

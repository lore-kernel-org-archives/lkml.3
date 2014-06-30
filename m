Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751802AbaF3U5r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 16:57:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41730 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224AbaF3U5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 16:57:46 -0400
Date: Mon, 30 Jun 2014 13:57:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: Fabian Frederick <fabf@skynet.be>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 1/1] proc: constify seq_operations
Message-Id: <20140630135744.51ebff73c7e396f1c50f0c81@linux-foundation.org>
In-Reply-To: <1404161370.2717.10.camel@joe-AO725>
References: <1404154997-15490-1-git-send-email-fabf@skynet.be>
	<20140630133939.c24cd71919cd28c90992d6e1@linux-foundation.org>
	<1404161370.2717.10.camel@joe-AO725>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jun 2014 13:49:30 -0700 Joe Perches <joe@perches.com> wrote:

> On Mon, 2014-06-30 at 13:39 -0700, Andrew Morton wrote:
> > On Mon, 30 Jun 2014 21:03:17 +0200 Fabian Frederick <fabf@skynet.be> wrote:
> > 
> > > proc_uid_seq_operations, proc_gid_seq_operations and proc_projid_seq_operations
> > > are only called in proc_id_map_open with seq_open as
> > > const struct seq_operations so we can constify the 3 structures and update
> > > proc_id_map_open prototype.
> > 
> > There are an absolutely enormous number of places where we could
> > constify things.
> 
> Which would be a good thing.

These things involve tradeoffs.  A constant dribble of
do-nothing-useful patches just isn't worth the effort on either end,
IMO.

> >   For sheer sanity's sake I'm not inclined to churn the
> > code in this way unless a patch provides some sort of runtime benefit. 
> > And this particular patch doesn't appear to change the generated code
> > at all.
> 
> It moves ~100 bytes from data to text

doh, I only looked at base.o.

I added this to the changelog.  It should have been there originally,
please.

   text    data     bss     dec     hex filename
   6817     404    1984    9205    23f5 kernel/user_namespace.o-before
   6913     308    1984    9205    23f5 kernel/user_namespace.o-after


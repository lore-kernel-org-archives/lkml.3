Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751676Ab3EAQqC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 12:46:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59485 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910Ab3EAQp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 12:45:56 -0400
Date: Wed, 1 May 2013 18:42:46 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Colin Walters <walters@verbum.org>
Cc: Zbigniew =?utf-8?Q?J=C4=99drzejewski-Szmek?= <zbyszek@in.waw.pl>,
        systemd-devel@lists.freedesktop.org,
        Denys Vlasenko <vda.linux@googlemail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [systemd-devel] [PATCH 2/2] coredump: Handle programs with
	spaces in COMM
Message-ID: <20130501164246.GA7647@redhat.com>
References: <1367341939.6959.1.camel@localhost> <20130430174731.GC3394@in.waw.pl> <1367349331.6959.80.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1367349331.6959.80.camel@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30, Colin Walters wrote:
>
> On Tue, 2013-04-30 at 19:47 +0200, Zbigniew Jędrzejewski-Szmek wrote:
> > On Tue, Apr 30, 2013 at 01:12:19PM -0400, Colin Walters wrote:
> > > This patch makes systemd-coredump handle processes that have
> > > whitespace in their COMM fields.
> > >
> > > fs/coredump.c when given %e (as systemd-coredump uses), will end up
> > > joining the process arguments into a string (along with the other
> > > fields), then will split the entire thing up on whitespace, and use
> > > it as the arguments to the coredump pipe handler.
> > > ---
> > That's a workaround for a bug in the kernel. I think it makes sense, but
> > it'd be nice to fix the kernel too.

I wouldn't say this is bug... at least this is expected.

Sure, it is possible to rewrite format_corename/argv_split interaction,
but this is a bit painful and I am not sure it worth the trouble.

> To do what though?  Add a new coredump format specifier that gives you
> a string-escaped version as one argument?  That'd probably make sense,

Or, perhaps, we can simply change cn_escape() to do s/space/something/
unconditionally (currently it only does s'/'!'). But this is a user-
visible change.

Oleg.


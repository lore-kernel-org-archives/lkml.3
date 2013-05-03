Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933061Ab3ECPOO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 11:14:14 -0400
Received: from tango.0pointer.de ([85.214.72.216]:60226 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354Ab3ECPON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 11:14:13 -0400
X-Greylist: delayed 346 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 May 2013 11:14:13 EDT
Date: Fri, 3 May 2013 17:08:24 +0200
From: Lennart Poettering <mzxreary@0pointer.de>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Colin Walters <walters@verbum.org>,
        Denys Vlasenko <vda.linux@googlemail.com>,
        systemd-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [systemd-devel] [PATCH 2/2] coredump: Handle programs
 	with	spaces in COMM
Message-ID: <20130503150824.GB24114@tango.0pointer.de>
References: <1367341939.6959.1.camel@localhost>
 <20130430174731.GC3394@in.waw.pl>
 <1367349331.6959.80.camel@localhost>
 <20130501164246.GA7647@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130501164246.GA7647@redhat.com>
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 01.05.13 18:42, Oleg Nesterov (oleg@redhat.com) wrote:

> On 04/30, Colin Walters wrote:
> >
> > On Tue, 2013-04-30 at 19:47 +0200, Zbigniew Jędrzejewski-Szmek wrote:
> > > On Tue, Apr 30, 2013 at 01:12:19PM -0400, Colin Walters wrote:
> > > > This patch makes systemd-coredump handle processes that have
> > > > whitespace in their COMM fields.
> > > >
> > > > fs/coredump.c when given %e (as systemd-coredump uses), will end up
> > > > joining the process arguments into a string (along with the other
> > > > fields), then will split the entire thing up on whitespace, and use
> > > > it as the arguments to the coredump pipe handler.
> > > > ---
> > > That's a workaround for a bug in the kernel. I think it makes sense, but
> > > it'd be nice to fix the kernel too.
> 
> I wouldn't say this is bug... at least this is expected.
> 
> Sure, it is possible to rewrite format_corename/argv_split interaction,
> but this is a bit painful and I am not sure it worth the trouble.

It sounds really wrong to first merge this into one string and then
split it up again. It sounds much more sensible to instead just pass the
string array around all the time. What's the reason to make this one
string first?

Lennart

-- 
Lennart Poettering - Red Hat, Inc.

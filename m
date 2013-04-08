Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935266Ab3DHLxl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 07:53:41 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:38079 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935007Ab3DHLxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 07:53:39 -0400
Date: Mon, 8 Apr 2013 13:55:56 +0200
From: Philip Kranz <philip.kranz@googlemail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Philip Kranz <philip.kranz@googlemail.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Sebastian Wankerl <sisewank@cip.cs.fau.de>,
        linux-kernel@vger.kernel.org, i4passt@lists.informatik.uni-erlangen.de,
        linux-parisc@vger.kernel.org
Subject: Re: [PATCH] Add non-zero module sections to sysfs
Message-ID: <20130408115556.GB3561@yoda.lan>
References: <1364994499-23708-1-git-send-email-sisewank@cip.cs.fau.de> <87mwtf3ya1.fsf@rustcorp.com.au> <515D4A7F.5070102@cip.cs.fau.de> <87vc81lj7x.fsf@rustcorp.com.au> <1365156435.1970.31.camel@dabdike> <20130406104053.GA24710@yoda.lan> <878v4tbqve.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878v4tbqve.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.14 (2007-03-31)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 08, 2013 at 01:44:45PM +0930, Rusty Russell wrote:
> Philip Kranz <philip.kranz@googlemail.com> writes:
> > I am not able to produce an object file with duplicate section names
> > using gcc on x86. Even with -ffunction-sections, every section gets a
> > unique name. Is this architecture-specific behaviour of gcc?
> 
> Good point.  ld -r will collapse them into the same section (since gcc
> produces them they have to have the same section attributes).
> 
> You can do it with --unique, but no arch uses that.  PARISC has a
> platform-specific toolchain hack which does that for .text sections.
> (Thanks to Alan Modra for that clue...)

So that problem is indeed platform-specific. If it is safe to assume
that kernel modules don't have duplicate section names (except on
PARISC), it would make sense to simply move the check for empty sections
to arch/parisc as you suggested.

James, what do you think about that?

Greetings,
Philip

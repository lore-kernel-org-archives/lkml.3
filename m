Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933079Ab3CUWDs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 18:03:48 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38304 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932167Ab3CUWDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 18:03:33 -0400
Date: Thu, 21 Mar 2013 22:03:30 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: VFS deadlock ?
Message-ID: <20130321220330.GD21522@ZenIV.linux.org.uk>
References: <CA+55aFwyK4uDgSKUpXBGS5zi16qd8STtrGi3kndunYi40dnj+A@mail.gmail.com>
 <20130321203639.GC16406@redhat.com>
 <20130321204704.GZ21522@ZenIV.linux.org.uk>
 <20130321210255.GD16406@redhat.com>
 <CA+55aFxysZEw6fw8+LobMgfzeHuGSSs+hyrUr_frTOjaCGJFLQ@mail.gmail.com>
 <20130321212617.GA21522@ZenIV.linux.org.uk>
 <20130321214118.GA25517@redhat.com>
 <CA+55aFyKCswjX2Spg3UY8t9Uj2KwD-3Aga9epBUPR0cWnHfNqA@mail.gmail.com>
 <20130321215502.GC21522@ZenIV.linux.org.uk>
 <CA+55aFzK_OBwhuBw1Oap6Z-Q4+D3NZipZXBn50JuRvcYVz60+w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzK_OBwhuBw1Oap6Z-Q4+D3NZipZXBn50JuRvcYVz60+w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 02:57:29PM -0700, Linus Torvalds wrote:
> On Thu, Mar 21, 2013 at 2:55 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > On Thu, Mar 21, 2013 at 02:47:06PM -0700, Linus Torvalds wrote:
> >
> >> It will also end up giving you
> >> the information about whether the dentry is unlinked or not.
> >
> > You also want to know if p2 is unlinked, though (and yes, it's dentry_path(),
> > of course - apologies for the braino).
> 
> Just do dentry_path on both p1 and p2. You'll have to have two
> different buffers for them, of course.

I would be rather surprised if the pathnames proper would turn out to be
different, actually...

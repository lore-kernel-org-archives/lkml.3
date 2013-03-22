Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922Ab3CVANB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 20:13:01 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38978 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753654Ab3CVANA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 20:13:00 -0400
Date: Fri, 22 Mar 2013 00:12:57 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: VFS deadlock ?
Message-ID: <20130322001257.GH21522@ZenIV.linux.org.uk>
References: <CA+55aFwyK4uDgSKUpXBGS5zi16qd8STtrGi3kndunYi40dnj+A@mail.gmail.com>
 <20130321203639.GC16406@redhat.com>
 <20130321204704.GZ21522@ZenIV.linux.org.uk>
 <20130321210255.GD16406@redhat.com>
 <CA+55aFxysZEw6fw8+LobMgfzeHuGSSs+hyrUr_frTOjaCGJFLQ@mail.gmail.com>
 <20130321221256.GA30620@redhat.com>
 <CA+55aFx+O13YuJsZyrTS6O9Kws=1ff-knsSv9rV8wTf8yBrPJg@mail.gmail.com>
 <20130321233630.GE21522@ZenIV.linux.org.uk>
 <CA+55aFyLJ9vVm1T994EaE4tnEbV8rHj43m+cWsFFBi_qndao1A@mail.gmail.com>
 <CA+55aFyWNkOnrQ41xCAU8q5sVXdq1-u2P8n+quLY50OdiFo3Zw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyWNkOnrQ41xCAU8q5sVXdq1-u2P8n+quLY50OdiFo3Zw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 05:01:49PM -0700, Linus Torvalds wrote:
> On Thu, Mar 21, 2013 at 4:58 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > So yes, it's against the rules, and we get that deadlock right now,
> > but one solution would be to just allow this particular case. The
> > patch for the deadlock looks dead simple:
> 
> It should go without saying that that whitespace-damaged patch is
> entirely untested. But especially since we need to back-port whatever
> fix, it would be good if we could make the fix be something as simple
> as this. Because I don't believe we really want to backport some big
> network-namespace reorganization.
> 
> This is, of course, all assuming that hardlinked directories are ok if
> we can just guarantee the absence of loops. If there's some other
> reason why they'd be problematic, we're screwed.

See the posting upthread.  We could try to kludge around that as well
(e.g. have d_ancestor() compare ->d_inode instead of dentries themselves),
but I really think it's a lousy idea only inviting further abuse.

What we should do, IMO, is to turn /proc/<pid>/net into a honest symlink -
to ../nets/<netns ID>/net.  Hell, might even make it a magical symlink
instead...

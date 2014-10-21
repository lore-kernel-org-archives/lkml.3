Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933984AbaJUWGy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 18:06:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33362 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933170AbaJUWGx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 18:06:53 -0400
From: Steve Grubb <sgrubb@redhat.com>
To: Paul Moore <pmoore@redhat.com>
Cc: Eric Paris <eparis@redhat.com>, Richard Guy Briggs <rgb@redhat.com>,
        linux-audit@redhat.com, linux-kernel@vger.kernel.org, aviro@redhat.com
Subject: Re: [PATCH V5 0/5] audit by executable name
Date: Tue, 21 Oct 2014 18:06:52 -0400
Message-ID: <7183031.mHcELVMDhn@x2>
Organization: Red Hat
User-Agent: KMail/4.14.2 (Linux/3.16.6-200.fc20.x86_64; KDE/4.14.2; x86_64; ; )
In-Reply-To: <3623738.X9Kq6ePK5C@sifl>
References: <cover.1412303728.git.rgb@redhat.com> <4185398.VpQETdPFDe@x2> <3623738.X9Kq6ePK5C@sifl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, October 21, 2014 05:56:36 PM Paul Moore wrote:
> On Monday, October 20, 2014 07:33:39 PM Steve Grubb wrote:
> > On Monday, October 20, 2014 07:02:33 PM Paul Moore wrote:
> > > On Monday, October 20, 2014 06:47:27 PM Eric Paris wrote:
> > > > On Mon, 2014-10-20 at 16:25 -0400, Steve Grubb wrote:
> > > > > On Thursday, October 02, 2014 11:06:51 PM Richard Guy Briggs wrote:
> > > > > > This is a part of Peter Moody, my and Eric Paris' work to
> > > > > > implement
> > > > > > audit by executable name.
> > > > > 
> > > > > Does this patch set define an AUDIT_VERSION_SOMETHING and then set
> > > > > AUDIT_VERSION_LATEST to it? If not, I need one to tell if the kernel
> > > > > supports it when issuing commands. Also, if its conceivable that
> > > > > kernels
> > > > > may pick and choose what features could be backported to a curated
> > > > > kernel, should AUDIT_VERSION_ be a number that is incremented or a
> > > > > bit
> > > > > mask?
> > > > 
> > > > Right now the value is 2. So this is your last hope if you want to
> > > > make
> > > > it a bitmask. I'll leave that up to paul/richard to (over) design.
> > > 
> > > Audit is nothing if not over-designed.  I want to make sure we're
> > > consistent with the previous design methodologies ;)
> > > 
> > > I've been thinking about this for about the past half-hour while I've
> > > been
> > > going through some other mail and I'm not really enthused about using
> > > the
> > > version number to encode capabilities.  What sort of problems would we
> > > have if we introduced a new audit netlink command to query the kernel
> > > for
> > > audit capabilities?
> > 
> > I thought that is what we were getting in this patch:
> > https://www.redhat.com/archives/linux-audit/2014-January/msg00054.html
> 
> That patch, and the simple name "version", looks more like a version number
> and not a capabilities bitmap.  However, as Eric previously pointed out,
> since we are only at version 2, all is not lost.
> 
> > As I understood it, I send an AUDIT_GET command on netlink and then look
> > in
> > status.version to see what we have. I really think that in the mainline
> > kernel, there will be a steady increment of capabilities. However, for
> > distributions, they may want to pick and choose which capabilities to
> > backport to their shipping kernel. Meaning in practice, a bitmap may be
> > better to allow cherry picking capabilities and user space being able to
> > make informed decisions.
> 
> If we are intending to use this as a way of checking for functionality then
> it really should be a bitmap and not a version number.  Regardless of if we
> are talking about an upstream or distribution kernel.
> 
> > I really don't mind if this is done by a new netlink command (but if we
> > do,
> > what happens to status.version?) or if we just keep going with
> > status.version. Just tell me which it is.
> 
> No, let's stick with what we have now.  I mistakenly assumed that since the
> struct field and userspace #defines included "version" that the value was
> actually a version number ... silly me, I have no idea why I thought that.
> 
> So, with this in mind, I think a couple of small tweaks are in order (sorry
> Richard), in no particular order:
> 
> * Change the audit_status.version field comment in
> include/uapi/linux/audit.h to "/* audit functionality bitmap */", or
> similar.  We can't really change the structure now, but the comment is fair
> game.
> 
> * Change AUDIT_VERSION_LATEST to a bitmask instead of a number.  For
> example, it should be 3 given the current code, not 2.  In a perfect world
> this wouldn't even be in the uapi header, but it is so we need to keep it
> updated. Bumping it higher should be backwards compatible.
> 
> Can anyone think of anything else that might be affected by this?

This plan sounds good to me.

Thanks,
-Steve

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252Ab3GQMl3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 08:41:29 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53158 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754890Ab3GQMl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 08:41:26 -0400
Date: Wed, 17 Jul 2013 07:41:05 -0500
From: Serge Hallyn <serge.hallyn@ubuntu.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] allow some kernel filesystems to be mounted in a
 user namespace
Message-ID: <20130717124105.GA4442@sergelap>
References: <20130716192920.GA8980@sergelap>
 <20130716193826.GP4165@ZenIV.linux.org.uk>
 <20130716195002.GA23370@mail.hallyn.com>
 <51E5BC0D.3090303@mit.edu>
 <20130716213748.GA24076@mail.hallyn.com>
 <CALCETrV8QFZU947=OjL-abxAmHiLso-uhbmoJt45kfmtaw26Tg@mail.gmail.com>
 <20130716220301.GA24223@mail.hallyn.com>
 <CALCETrXgU560Vk382xsPJD+uE7EQzqkbCobV8BXwVXrK8EryNw@mail.gmail.com>
 <20130716222308.GA24408@mail.hallyn.com>
 <87d2qh91xm.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87d2qh91xm.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> "Serge E. Hallyn" <serge@hallyn.com> writes:
> 
> > I'm not "relying on LSM" to make these safe.  I'm relying on the
> > uid mappings to make these safe.
> >
> > Nevertheless I at least have hope of working around the others (in a
> > distro-acceptable way), so if the others are too scary I'll pursue
> > the workaround for the others and see where I get.  But I really feel
> > the securityfs one is the best solution.
> 
> Personally I don't trust debugfs enough to compile it into my kernel.

That, again, seems reasonable, but would also seem to invalidate
objections to this patch :)  but,

> fuse simply isn't ready to be have fresh mounts usefully created inside
> a user namespace.
> 
> Fundamentally with debugfs and securityfs you run into the issue we saw
> with sysfs and proc where at some level it is the system administrators
> perogative if those filesystems should be mounted.
> 
> The rule with filesystems like that is mounting them needs to be no more
> dangerous than bind mounting them.  At the point in the cycle you are
> talking about mounting them you presumably have already thrown away
> their original mounts making it impossible to tell if it would have been
> safe to mount them or not.  Making your patch completely inappropriate.

Right so the specific problem this patch introduces is:  An admin who is
using a distro kernel with these filesystems enabled but not mounted,
without this patch does not have to worry about unprivileged users being
able to access the fs.  With this patch, he does.

Thanks everyone, I withdraw this patch.

> What you need to do is at container setup time to bind mount those
> filesystems if they are already mounted and you want them in the
> container.  If you are just shuffling around something you can already
> see there are no security issues.

-serge

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422AbaKLRaN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 12:30:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40470 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753004AbaKLRaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 12:30:11 -0500
Date: Wed, 12 Nov 2014 12:30:07 -0500
From: Richard Guy Briggs <rgb@redhat.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Eric Paris <eparis@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-audit@redhat.com
Subject: Re: [PATCH] audit_tree: keep inode pinned
Message-ID: <20141112173007.GB28076@madcap2.tricolour.ca>
References: <20141104102712.GA7088@tucsk.piliscsaba.szeredi.hu>
 <20141105165833.GE5902@madcap2.tricolour.ca>
 <CAJfpeguyGSPp+g1SgwAY3aieB=6Z4d5qb72tOTd6oZ-2JFgsfQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpeguyGSPp+g1SgwAY3aieB=6Z4d5qb72tOTd6oZ-2JFgsfQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/11/05, Miklos Szeredi wrote:
> On Wed, Nov 5, 2014 at 5:58 PM, Richard Guy Briggs <rgb@redhat.com> wrote:
> > On 14/11/04, Miklos Szeredi wrote:
> >> From: Miklos Szeredi <mszeredi@suse.cz>
> >
> > Hi Miklos,
> >
> >> Audit rules disappear when an inode they watch is evicted from the cache.
> >> This is likely not what we want.
> >>
> >> The guilty commit is "fsnotify: allow marks to not pin inodes in core",
> >> which didn't take into account that audit_tree adds watches with a zero
> >> mask.
> >>
> >> Adding any mask should fix this.
> >
> > Nice find!  Do you have a quick reproducer to detect this?
> 
> - reboot
> - add tree rule
> - echo 2 > /proc/sys/vm/drop_caches
> 
> drop_caches doesn't guarantee dropping the inode from the cache, but
> after a reboot it usually does.

Perfect, thanks!  That works as expected.  While I was at it, I checked
the audit_watch code and the pending "filter on process name" patches to
make sure they didn't have the same problem.

> Thanks,
> Miklos

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545

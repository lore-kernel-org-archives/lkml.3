Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433Ab3JLAlN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 20:41:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4540 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752129Ab3JLAlL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 20:41:11 -0400
Date: Fri, 11 Oct 2013 20:42:44 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Scott Lovenberg <scott.lovenberg@gmail.com>
Cc: Jeremy Allison <jra@samba.org>, Andreas Dilger <adilger@dilger.ca>,
        "linux-fsdevel@vger.kernel.org Devel" <linux-fsdevel@vger.kernel.org>,
        Ganesha NFS List <nfs-ganesha-devel@lists.sourceforge.net>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 0/5] locks: implement "filp-private" (aka UNPOSIX)
 locks
Message-ID: <20131011204244.72c2d672@corrin.poochiereds.net>
In-Reply-To: <B0205F0B-0AC4-4B80-91C2-E3BD2D4B8E81@gmail.com>
References: <1381494322-2426-1-git-send-email-jlayton@redhat.com>
	<20131011200756.GB22160@fieldses.org>
	<EE732BCB-C38E-4874-AEDF-2EB9E1389A86@dilger.ca>
	<20131011192118.483e436f@tlielax.poochiereds.net>
	<20131011234923.GD8688@samba2>
	<B0205F0B-0AC4-4B80-91C2-E3BD2D4B8E81@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Oct 2013 20:18:58 -0400
Scott Lovenberg <scott.lovenberg@gmail.com> wrote:

> 
> On Oct 11, 2013, at 19:49, Jeremy Allison <jra@samba.org> wrote:
> 
> > On Fri, 11 Oct 2013 15:36:43 -0600 Andreas Dilger <adilger@dilger.ca> wrote:
> >>> 
> >>> At this point, my main questions are:
> >>> 
> >>> 1) does this look useful, particularly for fileserver implementors?
> > 
> > Yes from the Samba perspective. We'll have to keep the old
> > code around for compatibility with non-Linux OS'es, but this
> > will allow Linux Samba to short-circuit a bunch of logic
> > we have to get around the insane POSIX locking semantics
> > on close.
> > 
> > Jeremy.
> 
> From the peanut gallery, IIRC from college a few years back, wasn't the POSIX file locking stuff passed by all parties because they intended to do their own thing regardless of the standard?  The reason that all locks are blown on a release is mostly because there were already implementations and no one wanted to push the issue, or am I misunderstanding/forgetting the history of file locks in POSIX?

This blog post of Jeremy's explains some of the history:

    http://www.samba.org/samba/news/articles/low_point/tale_two_stds_os2.html

See the section entitled "First Implementation Past the Post".

-- 
Jeff Layton <jlayton@redhat.com>

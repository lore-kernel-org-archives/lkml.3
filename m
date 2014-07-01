Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757564AbaGAJyB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 05:54:01 -0400
Received: from mail-wi0-f202.google.com ([209.85.212.202]:36441 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755541AbaGAJx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 05:53:58 -0400
Date: Tue, 1 Jul 2014 10:53:56 +0100
From: David Drysdale <drysdale@google.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Meredydd Luff <meredydd@senatehouse.org>,
        Kees Cook <keescook@chromium.org>,
        James Morris <james.l.morris@oracle.com>, linux-api@vger.kernel.org
Subject: Re: [PATCH 01/11] fs: add O_BENEATH_ONLY flag to openat(2)
Message-ID: <20140701095356.GC2242@google.com>
References: <1404124096-21445-1-git-send-email-drysdale@google.com>
 <1404124096-21445-2-git-send-email-drysdale@google.com>
 <87mwcuw2pj.fsf@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mwcuw2pj.fsf@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2014 at 01:40:40PM -0700, Andi Kleen wrote:
> David Drysdale <drysdale@google.com> writes:
> 
> > Add a new O_BENEATH_ONLY flag for openat(2) which restricts the
> > provided path, rejecting (with -EACCES) paths that are not beneath
> > the provided dfd.  In particular, reject:
> >  - paths that contain .. components
> >  - paths that begin with /
> >  - symlinks that have paths as above.
> 
> How about bind mounts?
> 
> -Andi
> 
> -- 
> ak@linux.intel.com -- Speaking for myself only

Bind mounts won't get rejected because they just look like normal
path components.  In other words, if dir/subdir is a bind mount to
/root/dir then:
  fd = openat(AT_FDCWD, "dir/subdir", O_RDONLY|O_BENEATH_ONLY);
will work fine.

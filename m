Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932129Ab3CUVw7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 17:52:59 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38278 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992Ab3CUVw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 17:52:57 -0400
Date: Thu, 21 Mar 2013 21:52:55 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: VFS deadlock ?
Message-ID: <20130321215255.GB21522@ZenIV.linux.org.uk>
References: <20130321192935.GY21522@ZenIV.linux.org.uk>
 <CA+55aFyvwJK99YvDLDsazD4tWT6sNQO6kGM_1WyDdvwPNDxbLw@mail.gmail.com>
 <20130321202635.GA16406@redhat.com>
 <CA+55aFwyK4uDgSKUpXBGS5zi16qd8STtrGi3kndunYi40dnj+A@mail.gmail.com>
 <20130321203639.GC16406@redhat.com>
 <20130321204704.GZ21522@ZenIV.linux.org.uk>
 <20130321210255.GD16406@redhat.com>
 <CA+55aFxysZEw6fw8+LobMgfzeHuGSSs+hyrUr_frTOjaCGJFLQ@mail.gmail.com>
 <20130321212617.GA21522@ZenIV.linux.org.uk>
 <20130321214118.GA25517@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130321214118.GA25517@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 05:41:18PM -0400, Dave Jones wrote:
> fs/namei.c:2342:3: warning: passing argument 1 of ???d_absolute_path??? from incompatible pointer type [enabled by default]
>    d_absolute_path(p1, path, 4096);
>    ^
> In file included from include/linux/fs.h:8:0,
>                  from fs/namei.c:21:
> include/linux/dcache.h:337:14: note: expected ???const struct path *??? but argument is of type ???struct dentry *???
>  extern char *d_absolute_path(const struct path *, char *, int);
>               ^
> 
> 
> How do I go from the dentry in p1 to the path d_absolute_path expects ?

Ugh...  s/d_absolute_path/dentry_path/, of course.  Sorry about the braino...

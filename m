Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756354Ab3CMLwB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 07:52:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65084 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755585Ab3CMLwA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 07:52:00 -0400
Date: Wed, 13 Mar 2013 07:51:55 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Joe Perches <joe@perches.com>
Cc: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cifs: Rename cERROR and cifserror to cifs_vfs_err
Message-ID: <20130313075155.7464a34a@tlielax.poochiereds.net>
In-Reply-To: <1363174614.2031.9.camel@joe-AO722>
References: <1363128287.23052.21.camel@joe-AO722>
	<1363174614.2031.9.camel@joe-AO722>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Mar 2013 04:36:54 -0700
Joe Perches <joe@perches.com> wrote:

> On Tue, 2013-03-12 at 15:44 -0700, Joe Perches wrote:
> > The cERROR macro is always used as cERROR(1, and cifserror
> > is just a printk(KERN_ERR "CIFS VFS: ".
> > 
> > Make a cifs_vfs_err function that uses the vsprintf %pV
> > extension to avoid duplicating the "CIFS VFS: " prefix.
> > 
> > Remove the cERROR macro and use cifs_vfs_err directly.
> 
> Perhaps a better idea than this patch is to
> change both the cERROR and cFYI macros to
> a new use of cifs_dbg(type, fmt, ...)
> 
> cERROR(set, fmt, ...)   -> cifs_dbg(VFS, fmt, ...)
> cFYI(set, fmt, ...)     -> cifs_dbg(FYI, fmt, ...)
> 
> This conversion would mark both these macros
> as debug stataments as they are only enabled
> with CONFIG_CIFS_DEBUG.
> 
> Also CONFIG_CIFS_DEBUG2 use of DBG could also
> be integrated with the same style.
> 
> cFYI(DBG2, fmt, ...)    -> cifs_dbg(NOISY, fmt, ...)
> 
> The reduced object size would still apply.
> 
> This would also enable an easier conversion to
> dynamic debugging of these debug macros.
> 
> I'd prefer to move the newline from the macro
> to the format as that is more consistent with
> the rest of the kernel.
> 
> Thoughts?
> 

I like this change overall, but the size of the patch is pretty
daunting. If you could change the code that underlies cERROR() and
cFYI() without needing to touch all of their call sites, it might be
a simpler initial step.

OTOH, I would also prefer to move the newline into the format and
that's impossible without touching most of these call sites.

-- 
Jeff Layton <jlayton@redhat.com>

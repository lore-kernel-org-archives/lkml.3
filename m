Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756253Ab3CMLg6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 07:36:58 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:45808 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751187Ab3CMLg4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 07:36:56 -0400
Message-ID: <1363174614.2031.9.camel@joe-AO722>
Subject: Re: [PATCH] cifs: Rename cERROR and cifserror to cifs_vfs_err
From: Joe Perches <joe@perches.com>
To: Steve French <sfrench@samba.org>
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 13 Mar 2013 04:36:54 -0700
In-Reply-To: <1363128287.23052.21.camel@joe-AO722>
References: <1363128287.23052.21.camel@joe-AO722>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-03-12 at 15:44 -0700, Joe Perches wrote:
> The cERROR macro is always used as cERROR(1, and cifserror
> is just a printk(KERN_ERR "CIFS VFS: ".
> 
> Make a cifs_vfs_err function that uses the vsprintf %pV
> extension to avoid duplicating the "CIFS VFS: " prefix.
> 
> Remove the cERROR macro and use cifs_vfs_err directly.

Perhaps a better idea than this patch is to
change both the cERROR and cFYI macros to
a new use of cifs_dbg(type, fmt, ...)

cERROR(set, fmt, ...)   -> cifs_dbg(VFS, fmt, ...)
cFYI(set, fmt, ...)     -> cifs_dbg(FYI, fmt, ...)

This conversion would mark both these macros
as debug stataments as they are only enabled
with CONFIG_CIFS_DEBUG.

Also CONFIG_CIFS_DEBUG2 use of DBG could also
be integrated with the same style.

cFYI(DBG2, fmt, ...)    -> cifs_dbg(NOISY, fmt, ...)

The reduced object size would still apply.

This would also enable an easier conversion to
dynamic debugging of these debug macros.

I'd prefer to move the newline from the macro
to the format as that is more consistent with
the rest of the kernel.

Thoughts?


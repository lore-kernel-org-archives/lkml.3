Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754442AbbAUPGt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 10:06:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59021 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753601AbbAUPGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 10:06:40 -0500
From: Paul Moore <pmoore@redhat.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Guenter Roeck <linux@roeck-us.net>, Sabrina Dubroca <sd@queasysnail.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-audit@redhat.com, Richard Guy Briggs <rgb@redhat.com>
Subject: Re: linux-next: Tree for Jan 20 -- Kernel panic - Unable to mount root fs
Date: Wed, 21 Jan 2015 10:06:18 -0500
Message-ID: <7861867.gzT8obfGnK@sifl>
Organization: Red Hat
User-Agent: KMail/4.14.3 (Linux/3.16.7-gentoo; KDE/4.14.3; x86_64; ; )
In-Reply-To: <20150121043637.GO29656@ZenIV.linux.org.uk>
References: <20150120165655.GA10904@kria> <54BF2496.4000807@roeck-us.net> <20150121043637.GO29656@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, January 21, 2015 04:36:38 AM Al Viro wrote:
> Another thing I really do not understand is
> +               if (inode->i_ino) {
> +                       /* valid inode number, use that for the ...
> +                       if (n->ino != inode->i_ino ||
> +                           n->dev != inode->i_sb->s_dev)
> +                               continue;
> in __audit_inode().  We don't *have* dentries with dentry->d_inode->i_ino ==
> 0. Ever.  WTF is that about?  Paul?

Likely stupidity on my part.  It looks like a typo, that first if conditional 
should check "n->ino" instead of "inode->i_ino"; in __audit_getname() we 
record names without any inode numbers, so we need to see if this is one of 
those records.  Interesting that it passed my testing; either my testing is 
crap (always a strong possibility) or something else came to the rescue.  I'm 
still coming up to speed on the audit/VFS code ...

I'll fix that up and include in the next patchset once we resolve this issue.

-- 
paul moore
security @ redhat


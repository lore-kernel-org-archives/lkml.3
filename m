Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207AbbAULFw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 06:05:52 -0500
Received: from smtp4-g21.free.fr ([212.27.42.4]:25481 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917AbbAULFo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 06:05:44 -0500
Date: Wed, 21 Jan 2015 12:05:39 +0100
From: Sabrina Dubroca <sd@queasysnail.net>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Guenter Roeck <linux@roeck-us.net>, Paul Moore <pmoore@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-audit@redhat.com, Richard Guy Briggs <rgb@redhat.com>
Subject: Re: linux-next: Tree for Jan 20 -- Kernel panic - Unable to mount
 root fs
Message-ID: <20150121110539.GA8924@kria>
References: <20150120165655.GA10904@kria>
 <20150120232726.GA16913@kria>
 <1517211.UYLV49hvpg@sifl>
 <1528536.jyty2pu4Mz@sifl>
 <20150121004117.GM29656@ZenIV.linux.org.uk>
 <54BF1292.2080902@roeck-us.net>
 <20150121033600.GN29656@ZenIV.linux.org.uk>
 <54BF2496.4000807@roeck-us.net>
 <20150121043637.GO29656@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20150121043637.GO29656@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2015-01-21, 04:36:38 +0000, Al Viro wrote:
> On Tue, Jan 20, 2015 at 08:01:26PM -0800, Guenter Roeck wrote:
> > With this patch:
> > 
> > sys_mkdir .:40775 returned -17
> > sys_mkdir usr:40775 returned 0
> > sys_mkdir usr/lib:40775 returned 0
> > sys_mkdir usr/share:40755 returned 0
> > sys_mkdir usr/share/udhcpc:40755 returned 0
> > sys_mkdir usr/bin:40775 returned 0
> > sys_mkdir usr/sbin:40775 returned 0
> > sys_mkdir mnt:40775 returned 0
> > sys_mkdir proc:40775 returned 0
> > sys_mkdir root:40775 returned 0
> > sys_mkdir lib:40775 returned 0
> > sys_mkdir lib/modules:40775 returned 0
> > ...
> > 
> > and the problem is fixed.

This patch also works for me.


> ... except that it simply confirms that something's fishy with getname_kernel()
> of ->name of struct filename returned by getname().  IOW, I still do not
> understand the mechanism of breakage there.

I'm not so sure about that.  I tried to copy name to a new string in
do_path_lookup and that didn't help.

Now, I've removed the

        putname(filename);

line from do_path_lookup and I don't get the panic.


And BTW, I added Guenter's debugging to init/initramfs.c and got:
sys_mkdir dev:40755 returned 0
sys_mkdir root:40700 returned 0

even if it ends up panic'ing.

-- 
Sabrina

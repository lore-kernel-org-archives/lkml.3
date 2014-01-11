Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219AbaAKOM1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 09:12:27 -0500
Received: from tn-76-7-162-101.sta.embarqhsd.net ([76.7.162.101]:47109 "EHLO
	animx.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751316AbaAKOMY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 09:12:24 -0500
Date: Sat, 11 Jan 2014 09:12:09 -0500
From: Wakko Warner <wakko@animx.eu.org>
To: Dominique Martinet <dominique.martinet@cea.fr>
Cc: Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net,
        Rusty Russell <rusty@rustcorp.com.au>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [V9fs-developer] Unable to load modules from 9p filesystem with
 kmod 16
Message-ID: <20140111141209.GA26811@animx.eu.org>
References: <20140110023543.GA6131@animx.eu.org>
 <20140110230303.GA19369@animx.eu.org>
 <52D097DB.3020101@infradead.org>
 <20140111121914.GA12907@nautica>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140111121914.GA12907@nautica>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dominique Martinet wrote:
> Hi,

Hi.

The following was trimmed.

> > On 01/10/2014 03:03 PM, Wakko Warner wrote:
> > > Wakko Warner wrote:
> > >> Kernel 3.12.7 from kernel.org
> > >> With kmod-16, I'm unable to load any modules on my guest kvm machines.

> > >> open("/lib/modules/3.12.7/kernel/crypto/af_alg.ko", O_RDONLY|O_CLOEXEC) = 3
> > >> fstat(3, {st_mode=S_IFREG|0644, st_size=13822, ...}) = 0
> > >> mmap(NULL, 13822, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7f199aebd000
> > >> syscall_313(0x3, 0x7f199aaa2de0, 0, 0x3, 0, 0x7f199b7b2010, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) = -1 (errno 8)
> > >> munmap(0x7f199aebd000, 13822)           = 0
> > >> close(3)                                = 0
> 
> I didn't look at the patch very closely because the mail apparently
> never reached v9fs-developer (although it looks in copy), but I got
> pointed out this patch recently:
> http://www.spinics.net/lists/linux-virtualization/msg21716.html

I applied the patch on that page.  Here's my result:

# df -T /lib/modules/3.12.7/kernel              
Filesystem     Type 1K-blocks   Used Available Use% Mounted on
kernel         9p     2015056 721356   1172460  39% /kernel
# uname -r
3.12.7
# modprobe -V
kmod version 16
# lsmod
Module                  Size  Used by
nfsd                  217278  2 
auth_rpcgss            41307  1 nfsd
oid_registry            2179  1 auth_rpcgss
exportfs                3499  1 nfsd
nfs                   111109  0 
...

> Which quotes "This patch enables 9p-virtio to correctly handle this
> case. This not only enables us to load Linux kernel modules off virtfs,"
> 
> Perhaps would it be what you need to support this syscall_313?

Looks like that's the fix.

-- 
 Microsoft has beaten Volkswagen's world record.  Volkswagen only created 22
 million bugs.

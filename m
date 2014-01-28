Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966AbaA1VKh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 16:10:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39578 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755927AbaA1VKc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 16:10:32 -0500
Date: Tue, 28 Jan 2014 16:10:21 -0500
From: Dave Jones <davej@redhat.com>
To: Sage Weil <sage@inktank.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        ceph-devel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [GIT PULL] Ceph updates for -rc1
Message-ID: <20140128211021.GB1377@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Sage Weil <sage@inktank.com>, torvalds@linux-foundation.org,
	linux-kernel@vger.kernel.org, ceph-devel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
References: <alpine.DEB.2.00.1401281032560.16427@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.DEB.2.00.1401281032560.16427@cobra.newdream.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 28, 2014 at 10:40:16AM -0800, Sage Weil wrote:
 > Hi Linus,
 > 
 > Please pull the following Ceph updates from
 > 
 >   git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git for-linus
 > 
 > This is a big batch.  From Ilya we have:
 > 
 >  - rbd support for more than ~250 mapped devices (now uses same scheme 
 >    that SCSI does for device major/minor numbering)
 >  - crush updates for new mapping behaviors (will be needed for coming 
 >    erasure coding support, among other things)
 >  - preliminary support for tiered storage pools
 > 
 > There is also a big series fixing a pile cephfs bugs with clustered MDSs 
 > from Yan Zheng, ACL support for cephfs from Guangliang Zhao, ceph fscache 
 > improvements from Li Wang, improved behavior when we get ENOSPC from Josh 
 > Durgin, some readv/writev improvements from Majianpeng, and the usual mix 
 > of small cleanups.

This breaks the build for me.

fs/ceph/acl.c: In function ‘ceph_init_acl’:
fs/ceph/acl.c:216:3: warning: passing argument 1 of ‘posix_acl_create’ from incompatible pointer type [enabled by default]
   ret = posix_acl_create(&acl, GFP_NOFS, &inode->i_mode);
   ^
In file included from include/linux/posix_acl_xattr.h:12:0,
                 from fs/ceph/acl.c:25:
include/linux/posix_acl.h:96:12: note: expected ‘struct inode *’ but argument is of type ‘struct posix_acl **’
 extern int posix_acl_create(struct inode *, umode_t *, struct posix_acl **,
            ^
fs/ceph/acl.c:216:3: warning: passing argument 2 of ‘posix_acl_create’ makes pointer from integer without a cast [enabled by default]
   ret = posix_acl_create(&acl, GFP_NOFS, &inode->i_mode);
   ^
In file included from include/linux/posix_acl_xattr.h:12:0,
                 from fs/ceph/acl.c:25:
include/linux/posix_acl.h:96:12: note: expected ‘umode_t *’ but argument is of type ‘unsigned int’
 extern int posix_acl_create(struct inode *, umode_t *, struct posix_acl **,
            ^
fs/ceph/acl.c:216:3: warning: passing argument 3 of ‘posix_acl_create’ from incompatible pointer type [enabled by default]
   ret = posix_acl_create(&acl, GFP_NOFS, &inode->i_mode);
   ^
In file included from include/linux/posix_acl_xattr.h:12:0,
                 from fs/ceph/acl.c:25:
include/linux/posix_acl.h:96:12: note: expected ‘struct posix_acl **’ but argument is of type ‘umode_t *’
 extern int posix_acl_create(struct inode *, umode_t *, struct posix_acl **,
            ^
fs/ceph/acl.c:216:3: error: too few arguments to function ‘posix_acl_create’
   ret = posix_acl_create(&acl, GFP_NOFS, &inode->i_mode);
   ^
In file included from include/linux/posix_acl_xattr.h:12:0,
                 from fs/ceph/acl.c:25:
include/linux/posix_acl.h:96:12: note: declared here
 extern int posix_acl_create(struct inode *, umode_t *, struct posix_acl **,
            ^
fs/ceph/acl.c: In function ‘ceph_acl_chmod’:
fs/ceph/acl.c:252:2: warning: passing argument 1 of ‘posix_acl_chmod’ from incompatible pointer type [enabled by default]
  ret = posix_acl_chmod(&acl, GFP_KERNEL, inode->i_mode);
  ^
In file included from include/linux/posix_acl_xattr.h:12:0,
                 from fs/ceph/acl.c:25:
include/linux/posix_acl.h:95:12: note: expected ‘struct inode *’ but argument is of type ‘struct posix_acl **’
 extern int posix_acl_chmod(struct inode *, umode_t);
            ^
fs/ceph/acl.c:252:2: error: too many arguments to function ‘posix_acl_chmod’
  ret = posix_acl_chmod(&acl, GFP_KERNEL, inode->i_mode);
  ^
In file included from include/linux/posix_acl_xattr.h:12:0,
                 from fs/ceph/acl.c:25:
include/linux/posix_acl.h:95:12: note: declared here
 extern int posix_acl_chmod(struct inode *, umode_t);


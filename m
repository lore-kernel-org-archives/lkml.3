Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755702AbaCZReH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 13:34:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21942 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751906AbaCZReE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 13:34:04 -0400
Date: Wed, 26 Mar 2014 13:33:56 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: fs: remove now stale label in anon_inode_init()
Message-ID: <20140326173356.GA16013@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <20140326004510.D4C236604A2@gitolite.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140326004510.D4C236604A2@gitolite.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2014 at 12:45:10AM +0000, Linux Kernel wrote:
 > Gitweb:     http://git.kernel.org/linus/;a=commit;h=fce7fc79c8f7188dfc5eafa1b937bcc3c5a4c2f5
 > Commit:     fce7fc79c8f7188dfc5eafa1b937bcc3c5a4c2f5
 > Parent:     d6f2589ad561aa5fa39f347eca6942668b7560a1
 > Author:     Linus Torvalds <torvalds@linux-foundation.org>
 > AuthorDate: Tue Mar 25 17:43:34 2014 -0700
 > Committer:  Linus Torvalds <torvalds@linux-foundation.org>
 > CommitDate: Tue Mar 25 17:43:34 2014 -0700
 > 
 >     fs: remove now stale label in anon_inode_init()
 >     
 >     The previous commit removed the register_filesystem() call and the
 >     associated error handling, but left the label for the error path that no
 >     longer exists.  Remove that too.
 >     
 >     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
 > ---
 >  fs/anon_inodes.c |    1 -
 >  1 files changed, 0 insertions(+), 1 deletions(-)
 > 
 > diff --git a/fs/anon_inodes.c b/fs/anon_inodes.c
 > index 4b4543b..42fcc46 100644
 > --- a/fs/anon_inodes.c
 > +++ b/fs/anon_inodes.c
 > @@ -186,7 +186,6 @@ static int __init anon_inode_init(void)
 >  
 >  err_unregister_filesystem:
 >  	unregister_filesystem(&anon_inode_fs_type);
 > -err_exit:
 >  	panic(KERN_ERR "anon_inode_init() failed (%d)\n", error);
 
If we're about to panic, is there any point in doing the unregister ?
Looks like that function could just be..

        anon_inode_mnt = kern_mount(&anon_inode_fs_type);
        if (IS_ERR(anon_inode_mnt)) { 
                error = PTR_ERR(anon_inode_mnt);
                panic(KERN_ERR "anon_inode_init() failed (%d)\n", error);
        }       
        return 0;


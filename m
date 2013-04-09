Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936523Ab3DIHIY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 03:08:24 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:50085 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S935161Ab3DIHIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 03:08:22 -0400
Message-ID: <1365491284.2482.19.camel@slavad-ubuntu>
Subject: Re: [PATCH 0/2] hfs/hfsplus: Modernize logging styles
From: Vyacheslav Dubeyko <slava@dubeyko.com>
Reply-To: slava@dubeyko.com
To: Joe Perches <joe@perches.com>
Cc: Hin-Tak Leung <htl10@users.sourceforge.net>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 09 Apr 2013 11:08:04 +0400
In-Reply-To: <cover.1365438493.git.joe@perches.com>
References: <1365401315.2673.11.camel@slavad-ubuntu>
	 <cover.1365438493.git.joe@perches.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Identified-User: {2172:host202.hostmonster.com:dubeykoc:dubeyko.com} {sentby:smtp auth 109.188.127.125 authed with slava@dubeyko.com}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-04-08 at 09:37 -0700, Joe Perches wrote:
> Joe Perches (2):
>   hfs/hfsplus: Convert dprint to hfs_dbg
>   hfs/hfsplus: Convert printks to pr_<level>
> 

Thank you for your efforts. It is a good work.

But I have some additional suggestions:
(1) I think that it makes sense to use no_printk() for the case when we
don't need in debug output.
(2) I think that it is really necessary to add info about file and line
number for the case of debug output.

As I know Hin Tak has some code for dynamic debugging. I think that it
is a time for publish this work also. But I suppose that we can have
opportunity to choose old-fashioned HFS debugging output or dynamic
debug by means of declaration of special macro definition for every
case. I mean constant for every case (static debug, dynamic debug, no
debug).

Thanks,
Vyacheslav Dubeyko.

>  fs/hfs/bfind.c          | 10 +++++----
>  fs/hfs/bitmap.c         |  4 ++--
>  fs/hfs/bnode.c          | 39 ++++++++++++++++++----------------
>  fs/hfs/brec.c           | 19 +++++++++--------
>  fs/hfs/btree.c          | 31 ++++++++++++++-------------
>  fs/hfs/catalog.c        | 12 ++++++-----
>  fs/hfs/dir.c            | 12 +++++------
>  fs/hfs/extent.c         | 20 ++++++++++--------
>  fs/hfs/hfs_fs.h         | 20 ++++++++++++++++--
>  fs/hfs/inode.c          |  4 ++--
>  fs/hfs/mdb.c            | 23 ++++++++++----------
>  fs/hfs/super.c          | 43 +++++++++++++++++++------------------
>  fs/hfsplus/attributes.c | 26 +++++++++++------------
>  fs/hfsplus/bfind.c      |  6 +++---
>  fs/hfsplus/bitmap.c     | 12 +++++------
>  fs/hfsplus/bnode.c      | 36 +++++++++++++++----------------
>  fs/hfsplus/brec.c       | 14 ++++++-------
>  fs/hfsplus/btree.c      | 29 +++++++++++++------------
>  fs/hfsplus/catalog.c    | 11 +++++-----
>  fs/hfsplus/dir.c        | 14 ++++++-------
>  fs/hfsplus/extents.c    | 32 ++++++++++++++--------------
>  fs/hfsplus/hfsplus_fs.h | 20 +++++++++++++++---
>  fs/hfsplus/inode.c      |  4 ++--
>  fs/hfsplus/options.c    | 22 +++++++++----------
>  fs/hfsplus/super.c      | 56 +++++++++++++++++++------------------------------
>  fs/hfsplus/wrapper.c    |  8 +++----
>  fs/hfsplus/xattr.c      | 41 ++++++++++++++++++------------------
>  27 files changed, 296 insertions(+), 272 deletions(-)
> 



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755747AbaJVQCy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 12:02:54 -0400
Received: from mail2.tiolive.com ([94.23.229.207]:48420 "EHLO
	mail2.tiolive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754711AbaJVQCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 12:02:51 -0400
X-Greylist: delayed 482 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Oct 2014 12:02:50 EDT
Date: Wed, 22 Oct 2014 19:54:46 +0400
From: Kirill Smelkov <kirr@nexedi.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Ken Chen <kenchen@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH,RESEND] hugetlbfs: document that sticky mounts are allowed
Message-ID: <20141022155446.GA20240@teco.navytux.spb.ru>
References: <1409836833-4320-1-git-send-email-kirr@nexedi.com>
 <CABQzsv_9K0WrddMW60DkUbsv2B5BwLNFCES2TNvfVNaG-ym6YA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABQzsv_9K0WrddMW60DkUbsv2B5BwLNFCES2TNvfVNaG-ym6YA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 (resending to new documentation maintainer, as the original patch
  seemingly got lost)

Jonathan,

Please apply the below patch documenting that hugetlbfs can be sticky-mounted.

Thanks beforehand,
Kirill

On Thu, Sep 04, 2014 at 10:14:31AM -0700, Ken Chen wrote:
> On Thu, Sep 4, 2014 at 6:20 AM, Kirill Smelkov <kirr@nexedi.com> wrote:
> > Commit 75897d60 (hugetlb: allow sticky directory mount option) added
> > support for mounting hugetlbfs with sticky option set, like /tmp is
> > usually mounted, but forgot to document that.
> >
> > Cc: Ken Chen <kenchen@google.com>
> > Signed-off-by: Kirill Smelkov <kirr@nexedi.com>
> > ---
> >  Documentation/vm/hugetlbpage.txt | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/Documentation/vm/hugetlbpage.txt b/Documentation/vm/hugetlbpage.txt
> > index bdd4bb9..b64e0af 100644
> > --- a/Documentation/vm/hugetlbpage.txt
> > +++ b/Documentation/vm/hugetlbpage.txt
> > @@ -274,7 +274,7 @@ This command mounts a (pseudo) filesystem of type hugetlbfs on the directory
> >  /mnt/huge.  Any files created on /mnt/huge uses huge pages.  The uid and gid
> >  options sets the owner and group of the root of the file system.  By default
> >  the uid and gid of the current process are taken.  The mode option sets the
> > -mode of root of file system to value & 0777.  This value is given in octal.
> > +mode of root of file system to value & 01777.  This value is given in octal.
> >  By default the value 0755 is picked. The size option sets the maximum value of
> >  memory (huge pages) allowed for that filesystem (/mnt/huge). The size is
> >  rounded down to HPAGE_SIZE.  The option nr_inodes sets the maximum number of
> 
> Acked-by: Ken Chen <kenchen@google.com>

---- 8< ----
From: Kirill Smelkov <kirr@nexedi.com>
Date: Thu, 4 Sep 2014 17:13:00 +0400
Subject: [PATCH] hugetlbfs: document that sticky mounts are allowed

Commit 75897d60 (hugetlb: allow sticky directory mount option) added
support for mounting hugetlbfs with sticky option set, like /tmp is
usually mounted, but forgot to document that.

Cc: Ken Chen <kenchen@google.com>
Signed-off-by: Kirill Smelkov <kirr@nexedi.com>
Acked-by: Ken Chen <kenchen@google.com>
---
 Documentation/vm/hugetlbpage.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/vm/hugetlbpage.txt b/Documentation/vm/hugetlbpage.txt
index bdd4bb9..b64e0af 100644
--- a/Documentation/vm/hugetlbpage.txt
+++ b/Documentation/vm/hugetlbpage.txt
@@ -274,7 +274,7 @@ This command mounts a (pseudo) filesystem of type hugetlbfs on the directory
 /mnt/huge.  Any files created on /mnt/huge uses huge pages.  The uid and gid
 options sets the owner and group of the root of the file system.  By default
 the uid and gid of the current process are taken.  The mode option sets the
-mode of root of file system to value & 0777.  This value is given in octal.
+mode of root of file system to value & 01777.  This value is given in octal.
 By default the value 0755 is picked. The size option sets the maximum value of
 memory (huge pages) allowed for that filesystem (/mnt/huge). The size is
 rounded down to HPAGE_SIZE.  The option nr_inodes sets the maximum number of
-- 
2.1.0.61.g11be0d6

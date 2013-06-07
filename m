Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752152Ab3FGGnQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 02:43:16 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:64563 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004Ab3FGGnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 02:43:15 -0400
MIME-Version: 1.0
In-Reply-To: <51AF9D77.2000901@canonical.com>
References: <1369781410-24473-1-git-send-email-chiluk@canonical.com>
	<51A918B8.20303@canonical.com>
	<CA+i2_De5HHw2H9SvZ=W+QAOcy0M7jFac88OK6aeYdJVCGL6b+A@mail.gmail.com>
	<51AF9D77.2000901@canonical.com>
Date: Thu, 6 Jun 2013 23:43:13 -0700
X-Google-Sender-Auth: QLpyp3wqZuKKI80WS1SyBzwj_tg
Message-ID: <CA+i2_DfEhn_CPRBmyy4scG7UEL5bGsjodcq00Nyx4JZjnuSBGQ@mail.gmail.com>
Subject: Re: [PATCH] ncpfs: fix rmdir returns Device or resource busy
From: Petr Vandrovec <petr@vandrovec.name>
To: Dave Chiluk <chiluk@canonical.com>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 5, 2013 at 1:20 PM, Dave Chiluk <chiluk@canonical.com> wrote:
> Petr do you still have commit rights to ncpfs?  Can you please commit it
> to upstream or do I have to get Al to do that?

Hi,
  only thing I can do is to add

Signed-off-by: Petr Vandrovec <petr@vandrovec.name>

on your patch and forward it to Al.  Unfortunately patch below is
already whitespace-damaged :-(  So you can either send it to me, and
I'll resend it to Al, or you can do that directly...

Petr

> Dave.
>
>
> On 05/31/2013 05:22 PM, Petr Vandrovec wrote:
>> Looks OK to me.
>>
>> As I said elsewhere, I do not use ncpfs for years so I cannot provide
>> any sensible maintainership for it anymore :-(
>>
>> Petr
>>
>> On May 31, 2013 2:40 PM, "Dave Chiluk" <chiluk@canonical.com
>> <mailto:chiluk@canonical.com>> wrote:
>>
>>     Any thoughts on this?  NCPFS seems to be the forgotten, left-behind,
>>     red-headed stepchild of the fs community.
>>
>>     Dave.
>>
>>     On 05/28/2013 05:50 PM, Dave Chiluk wrote:
>>     > 1d2ef5901483004d74947bbf78d5146c24038fe7 caused a regression in
>>     ncpfs such that
>>     > directories could no longer be removed.  This was because
>>     ncp_rmdir checked
>>     > to see if a dentry could be unhashed before allowing it to be
>>     removed. Since
>>     > 1d2ef5901483004d74947bbf78d5146c24038fe7 introduced a change that
>>     incremented
>>     > dentry->d_count causing it to always be greater than 1 unhash
>>     would always
>>     > fail.  Thus causing the error path in ncp_rmdir to always be
>>     taken.  Removing
>>     > this error path is safe as unhashing is still accomplished by
>>     calls to dput
>>     > from vfs_rmdir.
>>     > ---
>>     >  fs/ncpfs/dir.c |    9 ---------
>>     >  1 file changed, 9 deletions(-)
>>     >
>>     > diff --git a/fs/ncpfs/dir.c b/fs/ncpfs/dir.c
>>     > index 8163260..6792ce1 100644
>>     > --- a/fs/ncpfs/dir.c
>>     > +++ b/fs/ncpfs/dir.c
>>     > @@ -1029,15 +1029,6 @@ static int ncp_rmdir(struct inode *dir,
>>     struct dentry *dentry)
>>     >       DPRINTK("ncp_rmdir: removing %s/%s\n",
>>     >               dentry->d_parent->d_name.name <http://d_name.name>,
>>     dentry->d_name.name <http://d_name.name>);
>>     >
>>     > -     /*
>>     > -      * fail with EBUSY if there are still references to this
>>     > -      * directory.
>>     > -      */
>>     > -     dentry_unhash(dentry);
>>     > -     error = -EBUSY;
>>     > -     if (!d_unhashed(dentry))
>>     > -             goto out;
>>     > -
>>     >       len = sizeof(__name);
>>     >       error = ncp_io2vol(server, __name, &len, dentry->d_name.name
>>     <http://d_name.name>,
>>     >                          dentry->d_name.len, !ncp_preserve_case(dir));
>>     >
>>
>

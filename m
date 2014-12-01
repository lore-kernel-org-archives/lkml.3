Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932549AbaLAVLV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 16:11:21 -0500
Received: from mail-qc0-f169.google.com ([209.85.216.169]:57039 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932112AbaLAVLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 16:11:16 -0500
Date: Mon, 1 Dec 2014 16:11:06 -0500
From: Jerome Glisse <j.glisse@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org,
        =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
        linux-kbuild@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] scripts/package: binrpm-pkg do not build source tar file
Message-ID: <20141201211103.GA32057@gmail.com>
References: <1414782331-7987-1-git-send-email-j.glisse@gmail.com>
 <54773645.5010401@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <54773645.5010401@suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2014 at 03:33:41PM +0100, Michal Marek wrote:
> On 2014-10-31 20:05, j.glisse@gmail.com wrote:
> > From: Jérôme Glisse <jglisse@redhat.com>
> > 
> > When doing make binrpm-pkg we do not want to build the source tar
> > file. This patch avoid doing the gigantic tar file.
> > 
> > Signed-off-by: Jérôme Glisse <jglisse@redhat.com>
> > Cc: linux-kbuild@vger.kernel.org
> > Cc: Michal Marek <mmarek@suse.cz>
> > Cc: Linus Torvalds <torvalds@linux-foundation.org>
> > ---
> >  scripts/package/mkspec | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/scripts/package/mkspec b/scripts/package/mkspec
> > index 1395760..b6f5e31 100755
> > --- a/scripts/package/mkspec
> > +++ b/scripts/package/mkspec
> > @@ -119,8 +119,10 @@ echo "%endif"
> >  
> >  echo 'rm -f $RPM_BUILD_ROOT'"/lib/modules/$KERNELRELEASE/{build,source}"
> >  echo "mkdir -p "'$RPM_BUILD_ROOT'"/usr/src/kernels/$KERNELRELEASE"
> > +if ! $PREBUILT; then
> >  echo "EXCLUDES=\"$RCS_TAR_IGNORE --exclude .tmp_versions --exclude=*vmlinux* --exclude=*.o --exclude=*.ko --exclude=*.cmd --exclude=Documentation --exclude=firmware --exclude .config.old --exclude .missing-syscalls.d\""
> >  echo "tar "'$EXCLUDES'" -cf- . | (cd "'$RPM_BUILD_ROOT'"/usr/src/kernels/$KERNELRELEASE;tar xvf -)"
> > +fi
> 
> This does not generate any tar file, but a /usr/src/kernels/... tree to
> be packaged in the kernel-devel package. I'm not says we should be doing
> this in make binrpm-pkg, but the change should also remove the
> kernel-devel package in the binrpm-pkg case.

Sent a v2 that also avoid building the devel package for binrpm-pkg target.

Cheers,
Jérôme

> 
> Michal

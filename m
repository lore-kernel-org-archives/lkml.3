Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727AbbAVQWx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 11:22:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60395 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752625AbbAVQWv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 11:22:51 -0500
From: Paul Moore <pmoore@redhat.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-fsdevel@vger.kernel.org, linux-audit@redhat.com, rgb@redhat.com,
        sd@queasysnail.net, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk
Subject: Re: [PATCH v2 0/5] Overhaul the audit filename handling
Date: Thu, 22 Jan 2015 11:22:43 -0500
Message-ID: <3252765.lrITUkIS9l@sifl>
Organization: Red Hat
User-Agent: KMail/4.14.3 (Linux/3.16.7-gentoo; KDE/4.14.3; x86_64; ; )
In-Reply-To: <54C08C62.8010609@roeck-us.net>
References: <20150122045303.1347.98054.stgit@localhost> <54C08C62.8010609@roeck-us.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, January 21, 2015 09:36:34 PM Guenter Roeck wrote:
> On 01/21/2015 08:59 PM, Paul Moore wrote:
> > This patchset has some important changes from the previous revision,
> > namely a fix from Al Viro (included in 2/5) that resolves a boot panic
> > on some systems as well as some smaller, less noteworthy fixes found
> > in the linux-next announcement thread from January 20th (refcount bump
> > in __audit_reusename() and a inode type in __audit_inode()).
> > 
> > This patchset still needs some additional testing to verify that the
> > audit code still functions properly (the minor fixes mentioned above)
> > and there is an additional patch from Al that should be included as
> > well, but I wanted to post this and push the series to the audit next
> > branch quickly since a number of folks were affected by the boot panic.
> > 
> > ---
> > 
> > Paul Moore (5):
> >        fs: rework getname_kernel to handle up to PATH_MAX sized filenames
> >        fs: create proper filename objects using getname_kernel()
> >        audit: enable filename recording via getname_kernel()
> >        audit: fix filename matching in __audit_inode() and
> >        __audit_inode_child()
> >        audit: replace getname()/putname() hacks with reference counters
> 
> Hi Paul,
> 
> What is the baseline for this patch set ? Obviously -next won't work,
> and it does not apply to mainline either.

This patchset currently lives, along with one other unrelated patch, in the 
audit next branch:

 * git://git.infradead.org/users/pcmoore/audit

I'm currently testing these in combination with the patch Al posted last 
night.  Assuming all goes well I'll drop them from the audit next branch and 
toss all six patches (these plus Al's) into another branch in case Al wants to 
pull them for the VFS tree.

-- 
paul moore
security @ redhat


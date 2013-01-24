Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755690Ab3AXUAp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:00:45 -0500
Received: from mail-da0-f47.google.com ([209.85.210.47]:49337 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755367Ab3AXUAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:00:37 -0500
Date: Thu, 24 Jan 2013 12:00:34 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Robin Holt <holt@sgi.com>
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: How should I proceed to get commit 891348c to 3.0.y?
Message-ID: <20130124200034.GB24705@kroah.com>
References: <20130124152851.GF3460@sgi.com>
 <20130124181535.GB12106@kroah.com>
 <20130124183010.GF3438@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130124183010.GF3438@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2013 at 12:30:10PM -0600, Robin Holt wrote:
> On Thu, Jan 24, 2013 at 10:15:35AM -0800, Greg KH wrote:
> > On Thu, Jan 24, 2013 at 09:28:51AM -0600, Robin Holt wrote:
> > > 
> > > I missed the email from 12/31 indicating commit 891348c was pulled from
> > > the 3.0.y stable tree due to a build breakage.
> > > 
> > > That commit requires the enum defined in traps.h by commit c940826.  That,
> > > in turn depends on commit 228bdaa95f which depends upon earlier commits.
> > > 
> > > How should I proceed?  Should I give you a patch that uses the constants
> > > in xpc_main.c? Should I add a patch which just pulls the enum portion of
> > > commit c940826 into traps.h? Any other direction you think this should go?
> > 
> > I think the last one makes the most sense as that makes it all
> > self-contained and sensible, right?
> 
> git diff c940826~..c940826 -- arch/x86/include/asm/traps.h | patch -p1
> git commit -a -c c940826
> 
> Then fixed it up to add a Signed-off-by: Robin Holt <holt@sgi.com>
> 
> I then did a make x86_64_defconfig, make menuconfig to get SGI_XP
> selected.  I ran into a compile error where traps.h line 56 was failing
> on __kprobes not being defined.  I added the #include <linux/kprobes.h>
> and now it builds.
> 
> Here is the munged commit I currently have.  With that 891348c can be
> cherry-picked and will build.  How should I proceed?  Is this enough
> for you to make progress?  Should I clear out those Signed-off-by
> lines for the submitter and HPA or should those stay?

They should stay.  resend this saying where the patch came from, and I
will be glad to apply it.  Also tell me what the original patch you
wanted me to apply was as well, I forgot it :)

thanks,

greg k-h

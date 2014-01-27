Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477AbaA0VTQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 16:19:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23790 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754118AbaA0VTP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 16:19:15 -0500
Date: Mon, 27 Jan 2014 16:18:45 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org,
        greg@kroah.com, jkosina@suse.cz
Subject: Re: [PATCH 03/11] bin2c: Move bin2c in scripts/basic
Message-ID: <20140127211845.GD22256@redhat.com>
References: <1390849071-21989-1-git-send-email-vgoyal@redhat.com>
 <1390849071-21989-4-git-send-email-vgoyal@redhat.com>
 <52E6CBAA.1080405@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52E6CBAA.1080405@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 27, 2014 at 10:12:10PM +0100, Michal Marek wrote:
> Dne 27.1.2014 19:57, Vivek Goyal napsal(a):
> > Kexec wants to use bin2c and it wants to use it really early in the build
> > process. See arch/x86/purgatory/ code in later patches.
> > 
> > So move bin2c in scripts/basic so that it can be built very early and
> > be usable by arch/x86/purgatory/
> > 
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > ---
> [...]
> > diff --git a/scripts/basic/Makefile b/scripts/basic/Makefile
> > index 4fcef87..afbc1cd 100644
> > --- a/scripts/basic/Makefile
> > +++ b/scripts/basic/Makefile
> > @@ -9,6 +9,7 @@
> >  # fixdep: 	 Used to generate dependency information during build process
> >  
> >  hostprogs-y	:= fixdep
> > +hostprogs-$(CONFIG_IKCONFIG)     += bin2c
> 
> Is the CONFIG_IKCONFIG dependency still correct, now that you found
> another use of bin2c?

In the next patch I changed depedency too. (CONFIG_BUILD_BIN2C). And
now CONFIG_IKCONFIG and CONFIG_KEXEC will select CONFIG_BUILD_BIN2C.

Thanks
Vivek

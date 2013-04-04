Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933504Ab3DDISH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 04:18:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54783 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933081Ab3DDISE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 04:18:04 -0400
Date: Thu, 4 Apr 2013 10:18:02 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Michal Marek <mmarek@suse.cz>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [RFC PATCH] Use target compiler for user binaries in samples/
In-Reply-To: <20130331165327.GA28591@merkur.ravnborg.org>
Message-ID: <alpine.LNX.2.00.1304041017040.30938@pobox.suse.cz>
References: <20130331165327.GA28591@merkur.ravnborg.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 31 Mar 2013, Sam Ravnborg wrote:

> The user-space binaries build in samples/ uses the installed
> headers for the kernel.
> Therefore it is wrong that they use the host compiler
> to build the samples.
> 
> Following is an attempt to create some infrastructure
> for building user-space binaries that uses the uapi headers.
> 
> As my sparc cross toolchain does not supporting building
> user-space I have not been able to test this as good as I hoped...
> 
> But faking that my native gcc is a cross gcc seems to work.
> 
> This adds two new variables to the top-level Makefile:
> UAPICC and UAPICFLAGS
> 
> The architectures that supports both 32 and 64 bit set the
> appropriate flags in UAPICFLAGS.
> 
> scripts/Makefile.uapiprogs cantains all the infrastructure.
> 
> I updated the samples for hidraw and seccomp to use the new
> infrastructure.
> 
> The file says:
> +# Sample syntax (see Documentation/kbuild/makefiles.txt for reference)
> 
> But I did not bother to write this yet - awaiting feedback.

I generally like the idea.

It'd be nice to know whether this fixes the ARCH=sparc allyesconfig builds 
Fengguang has been reporting. Fengguang ... ?

Thanks,

-- 
Jiri Kosina
SUSE Labs

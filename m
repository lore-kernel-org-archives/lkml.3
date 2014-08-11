Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499AbaHKSDK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 14:03:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3918 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752717AbaHKSDJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 14:03:09 -0400
Date: Mon, 11 Aug 2014 14:02:14 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Shaun Ruffell <sruffell@digium.com>, linux-kernel@vger.kernel.org,
        kexec@lists.infradead.org, ebiederm@xmission.com, mjg59@srcf.ucam.org,
        greg@kroah.com, bp@alien8.de, dyoung@redhat.com, chaowang@redhat.com,
        bhe@redhat.com, akpm@linux-foundation.org
Subject: Re: [PATCH 11/15] purgatory: Core purgatory functionality
Message-ID: <20140811180213.GC1863@redhat.com>
References: <1403814824-7587-1-git-send-email-vgoyal@redhat.com>
 <1403814824-7587-12-git-send-email-vgoyal@redhat.com>
 <20140811174017.GD12610@digium.com>
 <53E9028E.2070709@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53E9028E.2070709@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2014 at 10:51:10AM -0700, H. Peter Anvin wrote:
> On 08/11/2014 10:40 AM, Shaun Ruffell wrote:
> > FYI, it looks like the following patch (committed in
> > 8fc5b4d4121c95482b2583) adds a new requirement to use at least gcc
> > 4.4 to build the kernel?
> 
> Well, to build the kernel with that particular new functionality
> enabled, yes.
> 
> However...
> 
> > The above "-mcmodel=large" compiler flag produces the following output on GCC 4.1.2.
> > 
> >   $ make modules_prepare ; gcc --version
> >     CHK     include/config/kernel.release
> >     CHK     include/generated/uapi/linux/version.h
> >     CHK     include/generated/utsrelease.h
> >     CC      arch/x86/purgatory/purgatory.o
> >   arch/x86/purgatory/purgatory.c:1: sorry, unimplemented: code model ‘large’ not supported yet
> >   make[1]: *** [arch/x86/purgatory/purgatory.o] Error 1
> >   make: *** [archprepare] Error 2
> >   gcc (GCC) 4.1.2 20080704 (Red Hat 4.1.2-54)
> >   Copyright (C) 2006 Free Software Foundation, Inc.
> >   This is free software; see the source for copying conditions.  There is NO
> >   warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
> > 
> > I did a quick search for a discussion the indicates this compiler is now
> > officially too old to build the kernel but did not find one.
> > 
> > If this is required, maybe Documentation/Changes needs to be updated
> > with the new minimum required version?
> 
> ... I'm having a very, very hard time to picture a reason why the
> "large" model would be necessary or even desirable for the purgatory
> code.  The "small PIC" model seem to fit much better...

Hi hpa,

I took it because kexec-tools uses it and in one of the committs Eric
gave following reasoning.

    On x86_64 use -mcmodel=large so that the code is built without
    any 32bit assumptions.  -mcmodel=medium and -mcmodel=small
    result int code that has 32bit relocations against variables
    that can live anywhere in the address space

We do want to load purgatory anywhere in the address space. 

But if there are other ways to achieve the same thing, I will do that
change.

So when you say "small PIC", I need to use -mcmodel=small and -fPIC?

I can give that a try.

Thanks
Vivek

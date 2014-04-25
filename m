Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788AbaDYJnW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 05:43:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39885 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750719AbaDYJnR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 05:43:17 -0400
Date: Fri, 25 Apr 2014 17:44:45 +0800
From: Dave Young <dyoung@redhat.com>
To: Kees Cook <keescook@chromium.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: kaslr should avoid setup_data region
Message-ID: <20140425094444.GA1896@darkstar.nay.redhat.com>
References: <20140424023544.GA2180@darkstar.nay.redhat.com>
 <CAGXu5j+TP2=iVYj=a6YGiGdOUqznb1MxdLLz5tjL8Hwwcq2K0Q@mail.gmail.com>
 <20140424025016.GB2180@darkstar.nay.redhat.com>
 <CAGXu5jKaog6X+jw6Zh3iHSHS8KFUbLEHm75=HbVORJ-crpr7Fw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jKaog6X+jw6Zh3iHSHS8KFUbLEHm75=HbVORJ-crpr7Fw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/14 at 03:50pm, Kees Cook wrote:
> Ah, it sounds like boot_params.hdr.setup_data contains a series of
> e820-like entries chained together as a linked list? Which loaders
> currently populate that? Looks like EFI? Seems like
> arch/x86/boot/compressed/eboot.c works on setup_data at least.

AFAIK efi stub, kexec, also as HPA mentioned syslinux use it as well.

kexec use setup_data for passing e820 ext ranges, also use it for efi boot.

> 
> I won't be in a position to test EFI booting for a while. If someone
> else took this, that would make it get fixed much faster.

Because kaslr is randomizing the base, it's hard to produce the failure.

>From the code itself, maybe just iterate the setup_data regions and add them
to avoid list, not necessary to care about the setup_data type..

> 
> Do you have examples where this is actually causing failures?

As mentioned above I have no idea how to test. Probably need manually hack
the code to create a failure? 

> 
> -Kees
> 
> On Wed, Apr 23, 2014 at 7:50 PM, Dave Young <dyoung@redhat.com> wrote:
> > On 04/23/14 at 07:43pm, Kees Cook wrote:
> >> On Wed, Apr 23, 2014 at 7:35 PM, Dave Young <dyoung@redhat.com> wrote:
> >> > Hello Kees
> >> >
> >> > I'm worrying that setup_data regions could be overwitten by randomize
> >> > kernel base. Would you like to fix it in kaslr code?
> >> >
> >> > One problem is there could be a lot of setup_data regions but current
> >> > mem_avoid is an fixed array.
> >>
> >> Sure, can you give me some examples? Seems like it shouldn't be too
> >> hard to have the mem_avoid logic walk additional areas.
> >
> > Great, To walk through the list just like the function parse_setup_data in
> > arch/x86/kernel/setup.c
> >
> > Thanks
> > Dave
> 
> 
> 
> -- 
> Kees Cook
> Chrome OS Security

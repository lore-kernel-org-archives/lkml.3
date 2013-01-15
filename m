Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756310Ab3AOTtZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 14:49:25 -0500
Received: from mail.skyhub.de ([78.46.96.112]:40220 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750698Ab3AOTtV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 14:49:21 -0500
Date: Tue, 15 Jan 2013 20:49:18 +0100
From: Borislav Petkov <bp@alien8.de>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>,
        Matt Fleming <matt.fleming@intel.com>,
        Gokul Caushik <caushik1@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Joe Millenbach <jmillenbach@gmail.com>
Subject: Re: [PATCH v7u1 22/31] x86, boot: add fields to support load bzImage
 and ramdisk above 4G
Message-ID: <20130115194918.GD8101@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jan Kiszka <jan.kiszka@web.de>,
	Jason Wessel <jason.wessel@windriver.com>,
	linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>,
	Matt Fleming <matt.fleming@intel.com>,
	Gokul Caushik <caushik1@gmail.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Joe Millenbach <jmillenbach@gmail.com>
References: <CAE9FiQXkgoLKp3ZnOcM9gLDJNGNxUE8WSRXiQy1G_v5Os5_v2A@mail.gmail.com>
 <50F455A3.4070706@zytor.com>
 <CAE9FiQUtbpo0njyPjPED=esKKnSdFs9ry4pFjG1y0LvHxkqV4w@mail.gmail.com>
 <50F46304.3010108@zytor.com>
 <CAE9FiQU_8ngBbXbwrqC1SaR3fScoDNvO_nKOhDYBV_bjOzjwJg@mail.gmail.com>
 <CAE9FiQWxWdeGB-DZp7W2rmukG-KPahF8SQbBcHUWbbUAJA2MhA@mail.gmail.com>
 <20130115155053.GA8101@liondog.tnic>
 <CAE9FiQUyinyu_DxLF_kXO82cMnRmt0fmbkh11vEw2Wr0SAWw_A@mail.gmail.com>
 <20130115164843.GB8101@liondog.tnic>
 <CAE9FiQUz6t_hK11X9ra5pj2DwJsNCu=cZJ7TYGR1ry-rvwSmjg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAE9FiQUz6t_hK11X9ra5pj2DwJsNCu=cZJ7TYGR1ry-rvwSmjg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2013 at 10:43:38AM -0800, Yinghai Lu wrote:
> I only change lines according to the response that i could understand
> and i think that is right.

And those you don't understand and/or don't think are right, you simply
ignore? How about asking if you don't understand them? How about saying
that you don't agree with them so that we can talk it out as it is the
case on lkml normally?

> are you looking wrong place?
> 
> http://git.kernel.org/?p=linux/kernel/git/yinghai/linux-yinghai.git;a=commitdiff;h=fd6da054a055aea9cf265a005563073ada6e1af0
> 
>  x86, 64bit, realmode: Use init_level4_pgt to set trapmoline_pgd directly
> author	Yinghai Lu <yinghai@kernel.org>	
> 	Tue, 15 Jan 2013 05:11:07 +0000 (21:11 -0800)
> committer	Yinghai Lu <yinghai@kernel.org>	
> 	Tue, 15 Jan 2013 05:11:07 +0000 (21:11 -0800)
> with #PF handler way to set early page table, level3_ident will go away with
> 64bit native path.
> 
> So just use entries in init_level4_pgt to set them in tramopline_pgd
							^^^^^^^^^^^^^^
No, I'm looking at the right place, you're not seeing it:

Let me show you once again:

tramopline_pgd
trapmoline_pgd

See the letter swap?

> > * [PATCH 08/31] x86, 64bit: early #PF handler set page table
> >         - almost no changes, SOB chain still wrong
> 
> HPA and I have explained that to you.

No, hpa commented only on the handful commits without SOB. But if he's
fine with having only your SOB, then ok.

> http://lkml.org/lkml/2013/1/12/115
> 
> >
> > * [PATCH 12/31] x86: add get_ramdisk_image/size()
> >        - no change
> 
> I respond: will insert other lines between them.

Again: I'm not talking about spacing the functions (but that would be
good too). Here's what I would like to see (btw, I'm explaining this for
the third time):

static u64 __init get_ramdisk_image(void)
{
       return (u64)boot_params.hdr.ramdisk_image;
}

static u64 __init get_ramdisk_size(void)
{
       return (u64)boot_params.hdr.ramdisk_size;
}

No need for the useless variable declaration and improved readability -
a win-win situation.

> > * [PATCH 13/31] x86, boot: add get_cmd_line_ptr()
> >         - no change
> 
> same above

And I say too "same as above".

> > * [PATCH 14/31] x86, boot: move checking of cmd_line_ptr out of common path
> >         - no change
> 
> same above

No, this is not same as above - I'd simply like to have the comment
explaining why we do the >= 0x100000 check in the code.

> > * [PATCH 20/31] x86, kexec: replace ident_mapping_init and init_level4_page
> >         - no change
> 
> https://patchwork.kernel.org/patch/1930741/
> 
> I pointed you about the grammar. ...

And I said:

"And yet, this is not the point - the point is that this code is
complicated enough as it is so why not make the easy things trivial so
that people looking at it months or even years from now can still try to
understand it.

So what it is defined by the standard?! Just add that line anyway! Then
there's no need to go check what was meant. This way it is *there*,
*explicit* and everyone *knows* what is meant - even people who don't
sleep with C99std under their pillow."

IOW, add the initialization *anyways*!

> > * [PATCH 21/31] x86, kexec: only set ident mapping for ram.
> >         - almost
> 
> almost what?

That it is almost fixed:

"This patch exposes THE pfn_mapped array..."

"This patch relies on new THE kernel_ident_mapping_init..."

The "THE" in capital letters are missing.

This is what I mean: you take my comments but not really - you still
change them on the way and make the text funny.

> > * [PATCH 22/31] x86, boot: add fields to support load bzImage and ramdisk above 4G
> >         - except sentinel, almost no change
> 
> ?

Well, I'm not going to repeat myself ad infinitum and ad absurdum - go
look at the mail thread and read my comments I had and then look at your
commit message again.

> > * [PATCH 23/31] x86, boot: update comments about entries for 64bit image
> >         - almost no change
> 
> I explained that i copied that from 32bit, and if you want to change
> with 32bit need to do that later.

You're adding new text and we want it to be as clean as possible.
According to your logic, if you copy/paste code from the kernel and it
has a bug, the newly pasted portion would have that same bug too and you
won't fix it and let someone else fix it? Even though I told you how to
fix it?

So why don't you simply integrate my suggestions verbatim into the text
instead of opposing so much? I'm not forcing you to do anything bad -
I'm simply commenting on your work so that it can get better. Why the
hell are you still opposing to that?

> >> +The memory for struct boot_params should be allocated under or above
> >> +4G and initialized to all zero.
> >
> > I suggested:
> >
> > "Memory for struct boot_params may be allocated anywhere (even above
> > 4G). This memory must be zeroed out."
> >
> > You changed it to:
> >
> > "The memory for struct boot_params could be allocated anywhere (even
> > above 4G) and initialized to all zero."
> >
> > which still reads funny and has a couple of issues.
> 
> did not see anything wrong.

That's why I'M POINTING IT TO YOU! TO FUCKING SEE IT! So if you still
don't see anything wrong, simply take my suggestions as they are,
without changing them on the fly and stop debating.

Btw, if you'd taken the time to simply add those requested changes
instead of stubbornly and uselessy debating, we would've been done by
now.

Thanks.. but no thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755709Ab3KVPdv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 10:33:51 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48210 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755651Ab3KVPdt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 10:33:49 -0500
Date: Fri, 22 Nov 2013 16:33:46 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Vivek Goyal <vgoyal@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kexec@lists.infradead.org, "H. Peter Anvin" <hpa@zytor.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Greg Kroah-Hartman <greg@kroah.com>
Subject: Re: [PATCH 0/6] kexec: A new system call to allow in kernel
 loading
In-Reply-To: <CAMuHMdV4=Z8i0u_rWpQU0HHW0mvyv1k-acW1MyT9ZYy=iNwrfg@mail.gmail.com>
Message-ID: <alpine.LRH.2.00.1311221631100.9932@twin.jikos.cz>
References: <1384969851-7251-1-git-send-email-vgoyal@redhat.com> <8761rl73s7.fsf@xmission.com> <20131122015518.GA31921@redhat.com> <CAMuHMdUVvhKLBfZo2gBf=FoQxMEM42yzBjYS8r5sVfXgp940ng@mail.gmail.com> <20131122134317.GA4046@redhat.com>
 <CAMuHMdV4=Z8i0u_rWpQU0HHW0mvyv1k-acW1MyT9ZYy=iNwrfg@mail.gmail.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Nov 2013, Geert Uytterhoeven wrote:

> >> Only arm, i386, ppc, ppc64, sh, and x86_64 support zImage.
> >> It's not clear to me what alpha supports (if it supports anything at all?).
> >
> > Motiviation behind this patchset is secureboot. That is x86 specific
> > only and bzImage is most commonly used format on that platform. So it
> > makes sense to implement bzImage loader first, IMO.
> 
> While secureboot(TM) may be x86-centric

And ARM, right?

> IIRC actually loading signed kernels and modules didn't originate on 
> x86. Anything can have a bootloader that accepts signed kernel images 
> only.

Yes, but if you don't have the whole secure boot security model (i.e. root 
is implicitly untrusted), it's all just a game really.

If you are playing this "signed kernel and modules" game, but have trusted 
root, he's free to replace the bootloader by one that wouldn't be 
verifying the kernel signature, and reboot into arbitrary kernel.

-- 
Jiri Kosina
SUSE Labs


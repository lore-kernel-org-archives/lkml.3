Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756530Ab3IMMQI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 08:16:08 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54574 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755917Ab3IMMQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 08:16:05 -0400
Date: Fri, 13 Sep 2013 13:15:29 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Chris Mason <chris.mason@fusionio.com>, Mark Fasheh <mfasheh@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: [GIT PULL] Btrfs
Message-ID: <20130913121529.GA1437@flint.arm.linux.org.uk>
Mail-Followup-To: Josh Boyer <jwboyer@fedoraproject.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Chris Mason <chris.mason@fusionio.com>,
	Mark Fasheh <mfasheh@suse.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	"Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
	Linux-Arch <linux-arch@vger.kernel.org>
References: <20130912153629.16487.88969@localhost.localdomain> <CA+5PVA5GogJnewWvdmVo03oZRZDerE=H7BR49Xi1DZQyE_CG4Q@mail.gmail.com> <CAMuHMdWgzQvKkASycHSzpTwi2c3qG+wn52YSr-=c8cDtro7NyQ@mail.gmail.com> <CA+5PVA6Hm6XLdJa=x9TmZnjSH160337i-CM2HGHBpQMf06Bv9w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+5PVA6Hm6XLdJa=x9TmZnjSH160337i-CM2HGHBpQMf06Bv9w@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 07:53:21AM -0400, Josh Boyer wrote:
> I'm not an ARM expert, so I don't know if ARM should use the
> asm-generic implementations, or just use __get_user/__put_user in all
> cases.  I've CC'd rmk.

Why do we have uaccess-unaligned.h ?  Normally, these kinds of things
are spawned by architectures which have problems with unaligned accesses,
ARM being one of them, but afaik we've never need this.

With the kernel-side trapping of unaligned accesses on older hardware,
we've always dealt with the normal accessor faulting.

>From what I can tell in the git history, these unaligned put_user and
get_user have existed all the way back to the dawn of git use.

Can someone enlighten me why we have them?

-- 
Russell King

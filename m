Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755709AbaDKLy7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 07:54:59 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:58096 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754209AbaDKLy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 07:54:56 -0400
Date: Fri, 11 Apr 2014 12:54:21 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-arch <linux-arch@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>
Subject: Re: [PATCH 02/15] arm: __NR_syscalls fix
Message-ID: <20140411115421.GL16119@n2100.arm.linux.org.uk>
References: <1397211951-20549-1-git-send-email-miklos@szeredi.hu> <1397211951-20549-3-git-send-email-miklos@szeredi.hu> <20140411103351.GJ16119@n2100.arm.linux.org.uk> <CAJfpegvZ-n4sT0ojj9iUg_R5gMZHT0caad6TpOdcmF=pdiXkqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegvZ-n4sT0ojj9iUg_R5gMZHT0caad6TpOdcmF=pdiXkqg@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2014 at 01:50:50PM +0200, Miklos Szeredi wrote:
> On Fri, Apr 11, 2014 at 12:33 PM, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
> > On Fri, Apr 11, 2014 at 12:25:38PM +0200, Miklos Szeredi wrote:
> >> From: Miklos Szeredi <mszeredi@suse.cz>
> >>
> >> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> >> Cc: Russell King <linux@arm.linux.org.uk>
> >> ---
> >
> > This has me wondering...
> >
> > (a) what you think it fixes
> > (b) whether you tried to build-test this
> >
> > The ARM instruction set supports 8-bit immediate constants with an even
> > power of two shift.  384 fits that (0x180), 382 does not (0x17e), and
> > in your following patch, 383 definitely doesn't (0x17f).
> >
> > Having this constant larger than necessary does not cause any problem
> > for the syscall table: we explicitly pad it with calls to sys_ni_syscall
> > to make up the difference.
> 
> Yes, and the padding will be of wrong length if NR_syscalls is
> incorrect (which may be Oopsable?).  At least that is my impression
> from a casual glance.

Please explain.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.

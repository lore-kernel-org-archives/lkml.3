Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756507AbaHVNdy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 09:33:54 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:20825 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756283AbaHVNdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 09:33:53 -0400
Date: Fri, 22 Aug 2014 14:33:16 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] arm/smp: Absorb boot_secondary()
Message-ID: <20140822133315.GC20583@arm.com>
References: <1404918119-3676-1-git-send-email-geert+renesas@glider.be>
 <CAMuHMdXp0ruZjjJLXmWyCdfAXs9_9xFHDcmJ08M9_SbZqqq04g@mail.gmail.com>
 <201408202130.28389.arnd@arndb.de>
 <CAMuHMdVp3xeJ2nDYJ00tLc7HuZ5v+jC-T8omWV5+G_3C8XoyoA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdVp3xeJ2nDYJ00tLc7HuZ5v+jC-T8omWV5+G_3C8XoyoA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2014 at 08:55:33PM +0100, Geert Uytterhoeven wrote:
> Has anyone already written a "git-send-email"-compatible script to
> submit patches there?

You can send patches as usual to patches@arm.linux.org.uk, just add
KernelVersion: v3.?? after the --- line in your patch (maybe this could
be automate as well but I didn't bother).

For series, because the arrival order is not guaranteed, I use the git
alias below to trick it into sleeping 60s between patches:

ksend-rmk-patch = !git send-email --annotate --no-thread --suppress-cc=all --to-cmd='sleep 60 && echo patches@arm.linux.org.uk "#"'

For stgit, I have a dedicated template:

From: %(sender)s
To: patches@arm.linux.org.uk
Subject: %(prefix)s%(shortdescr)s

%(longdescr)s
PATCH FOLLOWS
KernelVersion:%(version)s
%(diff)s

And there is always git pull request that Russell is happy with.

-- 
Catalin

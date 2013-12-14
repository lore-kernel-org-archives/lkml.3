Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099Ab3LNUmn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 15:42:43 -0500
Received: from mail.skyhub.de ([78.46.96.112]:33174 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753862Ab3LNUmm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 15:42:42 -0500
Date: Sat, 14 Dec 2013 21:42:28 +0100
From: Borislav Petkov <bp@alien8.de>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
        Doug Thompson <dougthompson@xmission.com>, linux-edac@vger.kernel.org,
        Josh Triplett <josh@joshtriplett.org>
Subject: Re: [PATCH 1/3] drivers: edac: Mark the function
 amd64_decode_bus_error() as static in amd64_edac.c
Message-ID: <20131214204228.GA12100@pd.tnic>
References: <7cddbd4c69ed493f183383e98853181aaf75b26b.1387029387.git.rashika.kheria@gmail.com>
 <20131214170104.GD29362@pd.tnic>
 <CAMpEsFF2RjRYUvG7MivvWUmEV1kTn493=oNa30ASfQ+n+19akw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAMpEsFF2RjRYUvG7MivvWUmEV1kTn493=oNa30ASfQ+n+19akw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 14, 2013 at 11:47:10PM +0530, Rashika Kheria wrote:
> My gcc version is 4.6.3. You can trigger these warnings by adding
> -Wmissing-prototypes to KBUILD_CFLAGS in the top-level Makefile, and

Actually, you don't even have to do that - you only need to build with
W=1:

make W=1 drivers/edac/amd64_edac.o

We already enable -Wmissing-prototypes as an additional compiler warning
when building objects with the W= switch.

> do a build with defconfig or allyesconfig. It will show all warnings
> of missing prototype.

Ok, gcc man page says this detects global functions without prototypes
in a header but I guess it can be used to detect needlessly global
functions too. :)

I'll pick up your three patches,

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--

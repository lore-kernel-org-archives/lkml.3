Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755546Ab3CGJct (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 04:32:49 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56496 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754114Ab3CGJcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 04:32:48 -0500
Date: Thu, 7 Mar 2013 09:32:02 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: "'Paul Bolle'" <pebolle@tiscali.nl>, "'Ben Dooks'" <ben-linux@fluff.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: S3C24XX: drop "select MACH_N35"
Message-ID: <20130307093202.GC17833@n2100.arm.linux.org.uk>
References: <1362609234.28137.2.camel@x61.thuisdomein> <013a01ce1ac7$11b287d0$35179770$%kim@samsung.com> <1362615081.28137.5.camel@x61.thuisdomein> <014601ce1acd$bc63d480$352b7d80$%kim@samsung.com> <20130307005206.GZ17833@n2100.arm.linux.org.uk> <015001ce1ad1$185e66d0$491b3470$%kim@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <015001ce1ad1$185e66d0$491b3470$%kim@samsung.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 07, 2013 at 10:14:19AM +0900, Kukjin Kim wrote:
> Russell King - ARM Linux wrote:
> > And deleting entries from it is pointless if they've ever been in the
> > kernel.
> 
> OK, I see and agree.

The issue is that the database system "locks" an entry into the file as
soon as support is merged into mainline for the platform.  The reason
for this is that as soon as the support gets merged into a kernel verison,
that symbol is then referenced.

If anyone goes to the website to download a new copy of the file, it then
must continue to contain that symbol because they may be using the file
with any kernel version - maybe a version of the kernel with your platform
support in - and maybe they're using something that references the
generated ID/macros from your entry.

Updates to the file in the mainline kernel are merely re-downloads of the
file from the website and committed.

So, deleting entries once used in mainline is extremely problematical.  If
someone commits such a patch, my next update from the website/database to
the file will put it back.  Hence the problem.

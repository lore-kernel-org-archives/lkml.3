Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750Ab3AXLL4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 06:11:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35384 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754412Ab3AXLK7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 06:10:59 -0500
Date: Thu, 24 Jan 2013 12:13:40 +0100
From: Borislav Petkov <bp@suse.de>
To: Michal Marek <mmarek@suse.cz>
Cc: Alec Bickerton <alec@theangrymob.co.uk>, linux-kbuild@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add Intel Ivy bridge CPU flags
Message-ID: <20130124111340.GB13471@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@suse.de>,
	Michal Marek <mmarek@suse.cz>,
	Alec Bickerton <alec@theangrymob.co.uk>,
	linux-kbuild@vger.kernel.org, x86@kernel.org,
	linux-kernel@vger.kernel.org
References: <51002135.2060302@theangrymob.co.uk>
 <20130124105343.GA30701@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130124105343.GA30701@sepie.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2013 at 11:53:43AM +0100, Michal Marek wrote:
> On Wed, Jan 23, 2013 at 06:43:17PM +0100, Alec Bickerton wrote:
> > Hi,
> > 
> > I'd like to submit the attached patch to add Ivy Bridge processor support to the
> > processor type menu in menuconfig. Setting this configures the appropriate
> > CFLAGS (core-avx-i) for ivy bridge.
> > 
> > As this is my first kbuild patch, could somebody review it and let me know what
> > I've done wrong. ;-)
> 
> You sent it to linux-kbuild instead of x86@kernel.org. The kbuild
> maintainer is not really knowledgeable about gcc optimisation options ;).
> Nevertheless, some random comments are below. Note that I am not
> saying if the config option is useful or not.

Normally, such optimizations have a little effect on the kernel because
it doesn't normally use fpu stuff and the rest of the instructions
we need, we add ourselves (see arch/x86/include/asm/archrandom.h for
RDRAND, for example).

So, first we'd need persuasive benchmark numbers which show that a
kernel built with core-avx-i is faster at some representative workload
than mtune=generic one...

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--

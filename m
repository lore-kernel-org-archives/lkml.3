Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933092AbaDVPTB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 11:19:01 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:49812 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757080AbaDVPS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 11:18:56 -0400
Date: Tue, 22 Apr 2014 16:18:09 +0100
From: Will Deacon <will.deacon@arm.com>
To: Michal Simek <monstr@monstr.eu>
Cc: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "broonie@linaro.org" <broonie@linaro.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 18/18] asm-generic: io: define relaxed accessor macros
 unconditionally
Message-ID: <20140422151809.GF9820@arm.com>
References: <1397742261-15621-1-git-send-email-will.deacon@arm.com>
 <1397742261-15621-19-git-send-email-will.deacon@arm.com>
 <5356782A.9050809@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5356782A.9050809@monstr.eu>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

On Tue, Apr 22, 2014 at 03:09:46PM +0100, Michal Simek wrote:
> On 04/17/2014 03:44 PM, Will Deacon wrote:
> > Now that no architectures using asm-generic/io.h define their own relaxed
> > accessors, the dummy definitions can be used unconditionally.
> > 
> > Cc: Arnd Bergmann <arnd@arndb.de>
> > Signed-off-by: Will Deacon <will.deacon@arm.com>
> > ---
> >  include/asm-generic/io.h | 18 ------------------
> >  1 file changed, 18 deletions(-)
> 
> Do we need this? I think there could be a need to overwrite them.
> Currently we are just lucky that architecture which uses asm-generic/io.h
> don't need to overwrite it.
> But I expect that all archs should use asm-generic/io.h to clean
> architecture io.h exactly I have done it for Microblaze.

I'm open to keeping the conditional definitions, but it introduces a
discrepancy with the non-relaxed versions, which are defined unconditionally
(although the underlying __raw_* accessors can be overridden).

Will

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755059Ab3KFQww (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 11:52:52 -0500
Received: from mail.skyhub.de ([78.46.96.112]:34562 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753140Ab3KFQwu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 11:52:50 -0500
Date: Wed, 6 Nov 2013 17:54:38 +0100
From: Borislav Petkov <bp@alien8.de>
To: Rob Herring <robherring2@gmail.com>
Cc: linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Doug Thompson <dougthompson@xmission.com>,
        Robert Richter <rric@kernel.org>, linux-edac@vger.kernel.org
Subject: Re: [PATCH] edac, highbank: remove dependency on ARCH_HIGHBANK
Message-ID: <20131106165437.GA21870@x1.alien8.de>
References: <1383708352-19527-1-git-send-email-robherring2@gmail.com>
 <20131106142025.GB16072@x1.alien8.de>
 <527A6B08.5020302@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <527A6B08.5020302@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 06, 2013 at 10:15:04AM -0600, Rob Herring wrote:
> Other maintainers disagree because it reduces build coverage.

What possible build coverage are we talking about when building highbank
on x86, for example? And what does a build failure in that configuration
tell you if it builds and boots fine on your hardware?

> Having done some cross arch clean-up, I have to agree with that
> position. Iterating builds over different arches is bad enough, but
> iterating over all configs for each arch is a pain.

So make highbank depend only on the arches for which it is supposed to
work but not for *all* arches. Look at how the other edac drivers do it,
x86 ones depend on X86, tile on tile, etc, etc. Why should highbank be
special?

> It would be nice to have a uniform policy here.

Simple: drivers should be selectable/buildable only on the arches
they're supposed to run on.

-- 
Regards/Gruss,
Boris.

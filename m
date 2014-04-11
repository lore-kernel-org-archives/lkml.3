Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028AbaDKLzZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 07:55:25 -0400
Received: from classic.fenleys.co.uk ([83.67.51.87]:35758 "EHLO
	classic.fenleys.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755364AbaDKLzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 07:55:21 -0400
X-Greylist: delayed 1738 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Apr 2014 07:55:21 EDT
Date: Fri, 11 Apr 2014 12:26:11 +0100
From: Michael Fyles <mf@vorston.net>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] initramfs: remove "compression mode" choice
Message-ID: <20140411112611.GA508@dev0.mafconsulting.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1396958857.26620.35.camel@x220>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-04-08 14:07:37+0200, Paul Bolle wrote:
> Commit 9ba4bcb64589 ("initramfs: read CONFIG_RD_ variables for
> initramfs compression") removed the users of the various
> INITRAMFS_COMPRESSION_* Kconfig symbols. So since v3.13 the entire
> "Built-in initramfs compression mode" choice is a set of knobs connected
> to nothing. The entire choice can safely be removed.

Whilst I agree (for my use-cases) with INITRAMFS_COMPRESSION and
RD being merged, I think it has happened the wrong way round.

Commit 9ba4bcb64589 mistakenly forced the logic in usr/Makefile
to prioritise the selection of RD options such that selecting
more than one supported compression pretty much rail-roads you
into having your initrd compressed with gzip. This happends
because because suffix-y gets updated once for each supported
compression and, by default (on x86, at least) all compressions
are supported.

I think that either:
1. the options should be merged (with whatever name gets chosen)
   and pick both the run-time supported and the build-time
   compressions
2. both options should remain, with one choosing the supported
   run-time compressions and the other choosing the build-time
   compression

If 1 is chosen, it would be advantageous to have RD as a
mutually-exclusive choice -- this would be the place to put all
the help texts that your patch removes.

I currently have a patch that performs 2, if you decide that
might be better.

-- 
Michael Fyles

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756464AbaDKMDb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 08:03:31 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:51602 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755784AbaDKMD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 08:03:29 -0400
Message-ID: <1397217807.13525.21.camel@x220>
Subject: Re: [PATCH] initramfs: remove "compression mode" choice
From: Paul Bolle <pebolle@tiscali.nl>
To: Michael Fyles <mf@vorston.net>
Cc: "Prasad J. Pandit" <ppandit@redhat.com>, linux-kernel@vger.kernel.org
Date: Fri, 11 Apr 2014 14:03:27 +0200
In-Reply-To: <20140411112611.GA508@dev0.mafconsulting.com>
References: <20140411112611.GA508@dev0.mafconsulting.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Apr 2014 12:03:27.0570 (UTC) FILETIME=[0C2F4B20:01CF557E]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-04-11 at 12:26 +0100, Michael Fyles wrote:
> Whilst I agree (for my use-cases) with INITRAMFS_COMPRESSION and
> RD being merged, I think it has happened the wrong way round.
> 
> Commit 9ba4bcb64589 mistakenly forced the logic in usr/Makefile
> to prioritise the selection of RD options such that selecting
> more than one supported compression pretty much rail-roads you
> into having your initrd compressed with gzip. This happends
> because because suffix-y gets updated once for each supported
> compression and, by default (on x86, at least) all compressions
> are supported.
> 
> I think that either:
> 1. the options should be merged (with whatever name gets chosen)
>    and pick both the run-time supported and the build-time
>    compressions
> 2. both options should remain, with one choosing the supported
>    run-time compressions and the other choosing the build-time
>    compression
> 
> If 1 is chosen, it would be advantageous to have RD as a
> mutually-exclusive choice -- this would be the place to put all
> the help texts that your patch removes.
> 
> I currently have a patch that performs 2, if you decide that
> might be better.

This patch is a straightforward cleanup. It can't possibly change
anything for anyone.

My local .config tracks what Fedora uses for their kernel builds. I
don't think Fedora ever set one of the INITRAMFS_COMPRESSION_* options.
I didn't even knew these options became unused before grepping tree for
something entirely different.

But, of course, it's possible that 9ba4bcb64589 ("initramfs: read
CONFIG_RD_ variables for initramfs  compression") broke stuff. If so,
that should probably be fixed. But you're likely better off discussing
that with Prasad (added as Cc).


Paul Bolle


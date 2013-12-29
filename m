Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751030Ab3L2GrL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Dec 2013 01:47:11 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:21248 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750819Ab3L2GrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Dec 2013 01:47:09 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+aPqrDlMi8w7jFeBeVWsvOkxKglmiiCwY=
X-DKIM: OpenDKIM Filter v2.0.1 titan 714774FD99A
Date: Sun, 29 Dec 2013 01:47:07 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Gene Heskett <gheskett@wdtv.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Git puzzle
Message-ID: <20131229064707.GP19878@titan.lakedaemon.net>
References: <201312282141.40725.gheskett@wdtv.com>
 <201312290011.26801.gheskett@wdtv.com>
 <20131229052556.GM19878@titan.lakedaemon.net>
 <201312290127.05858.gheskett@wdtv.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201312290127.05858.gheskett@wdtv.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 29, 2013 at 01:27:05AM -0500, Gene Heskett wrote:
> On Sunday 29 December 2013, Jason Cooper wrote:
...
> >You may want to try the opposite approach.  x86_64_defconfig, then add
> >just what is necessary to boot and reproduce the bug.
> 
> Did that, then added some stuff for my hdwe, made sure the Makefile version 
> and my makeit script versions matched. Fired off my build/install script, 
> But it bailed out at the mkinitramfs stage, couldn't find 
> /lib/modules/3.8.2 because it was named "3.8.2+".

For this bisect run, can you do without the initramfs?  Just build the
sata driver and the fs driver into the kernel.  You may want to drop
makeit and just do the bare minimum, 'make bzImage && make modules &&
make modules_install' or similar.

The '+' means the kernel build system (using git) determined that there
were changes to the source tree from the most recent tagged version.  If
there weren't, it would just use the tag 3.8.2.  You can take a look at
scripts/setlocalversion to see how it figures it out.

hth,

Jason.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248Ab3JCFFa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 01:05:30 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:58636 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751740Ab3JCFF0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 01:05:26 -0400
Date: Wed, 2 Oct 2013 23:05:04 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Peter H?we <PeterHuewe@gmx.de>
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Ashley Lai <ashley@ashleylai.com>, Rajiv Andrade <mail@srajiv.net>,
        Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
        Marcel Selhorst <tpmdd@selhorst.net>, Sirrix AG <tpmdd@sirrix.com>
Subject: Re: [PATCH 08/13] tpm: Pull everything related to /dev/tpmX into
 tpm-dev.c
Message-ID: <20131003050504.GA2247@obsidianresearch.com>
References: <1379960083-8942-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <201310020052.40497.PeterHuewe@gmx.de>
 <20131001225733.GA5286@obsidianresearch.com>
 <201310020114.18624.PeterHuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201310020114.18624.PeterHuewe@gmx.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 02, 2013 at 01:14:18AM +0200, Peter H?we wrote:

> > I botched the makefile changes for the new .c files.
> > 
> > I believe it should be like this:
> > 
> > obj-$(CONFIG_TCG_TPM) += tpm-core.o
> > tpm-core-y := tpm.o tpm-dev.o tpm-sysfs.o
> > 
> > > I added a suitable patch with the appropriate EXPORT_SYMBOL_GPL
> > > declarations to my testing branch. (also see next message)
> > 
> > EXPORT_SYMBOL_GPL is not correct, these are in-module references, not
> > cross module references, and I've deliberately not exported them to
> > prevent drivers from trying to use them inappropriately.

> Of course you're right - I just wanted to get it compile as fast as
> possible ;)

It looks like my solution changes the tpm module name to tpm-core.o.
This should be noted in the commit log:

 In doing so we also change the core tpm module name from 'tpm' to 'tpm-core',
 this is because kbuild does not like it if a multi-file module has a .c
 file of the same name.

Is that OK? It follows the pattern other systems have in the kernel.

If this is not OK, then I think we have to rename tpm.c to tpm-XX.c to
make the build system work.

I've consolidated all the remarks and changes thus far on my github:
 https://github.com/jgunthorpe/linux/commits/tpm-devel
 ec94ce9d29298ba75cec83a136fd841f8da9d528

(plus 1 more untested patch to remove the tpm-bios module)

Jason

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799Ab3JFUPo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 16:15:44 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:50348 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754362Ab3JFUPm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 16:15:42 -0400
Date: Sun, 6 Oct 2013 14:15:29 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Joe Perches <joe@perches.com>
Cc: Peter H?we <PeterHuewe@gmx.de>, tpmdd-devel@lists.sourceforge.net,
        Ashley Lai <ashley@ashleylai.com>,
        Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, Rajiv Andrade <mail@srajiv.net>,
        Sirrix AG <tpmdd@sirrix.com>
Subject: Re: [PATCH 1/2] tpm: Rename tpm.c to tpm-interface.c
Message-ID: <20131006201529.GA10426@obsidianresearch.com>
References: <20131006193824.GA19123@obsidianresearch.com>
 <1381089202.2081.157.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381089202.2081.157.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 06, 2013 at 12:53:22PM -0700, Joe Perches wrote:
> On Sun, 2013-10-06 at 13:38 -0600, Jason Gunthorpe wrote:
> > This is preparation for making the tpm module multi-file. kbuild does
> > not like having a .c file with the same name as a module. We wish to
> > keep the tpm module name so that userspace doesn't see this change.
> 
> If that's true, and I don't believe it is,
> then Kbuild should be fixed instead.
> 
> There are a lot of examples of .c files named
> the same as the directory they reside in.

That isn't the trouble, it is having a module named tpm, comprised of
tpm.c, tpm-foo.c, and tpm-bar.c

The issue is that assembling the tpm module uses tpm.o as an
intermediate file, and compiling tmp.c uses tpm.o as a intermediate
file - they conflict, things don't work right and make throws a
circular dependency warning.

The Makefile I started with looks like this:

obj-m += tpm.o
tpm-y := tpm.o tpm-foo.o tpm-bar.o

Is there some other solution?

In any event, this patch is part of a series that splits tpm.c up,
renaming it at this point in the series is to make kbuild work, but
at the end of the series it should be renamed anyhow :)

Regards,
Jason

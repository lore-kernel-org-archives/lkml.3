Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751457Ab3JTRAb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 13:00:31 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:42184 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751261Ab3JTRAa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 13:00:30 -0400
Date: Sun, 20 Oct 2013 11:00:17 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Ashley Lai <adlai@linux.vnet.ibm.com>
Cc: Ashley Lai <ashley@ashleylai.com>,
        Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, Rajiv Andrade <mail@srajiv.net>,
        tpmdd-devel@lists.sourceforge.net, Peter H?we <PeterHuewe@gmx.de>,
        Sirrix AG <tpmdd@sirrix.com>
Subject: Re: [tpmdd-devel] TPM patches for 2.13
Message-ID: <20131020170017.GA32542@obsidianresearch.com>
References: <20131006193120.GA26137@obsidianresearch.com>
 <20131017145724.GA6528@obsidianresearch.com>
 <1382260018.11008.5.camel@fishsauce>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382260018.11008.5.camel@fishsauce>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 20, 2013 at 04:06:58AM -0500, Ashley Lai wrote:

> Hi Jason,
>   Patch 0008-tpm-Rename-tpm.c-to-tpm-interface.c.patch does not meet the
> Linux kernel's coding standards.  Please fix the errors found by
> checkpatch.pl and let me know when it's ready.  Thanks.

Please use format-patch -M when you run checkpatch on this one:

$ ^scripts/checkpatch.pl `git format-patch -M 890e46c0abf49b6a9bddeab9de8625b71db648ad^\!`
total: 0 errors, 0 warnings, 8 lines checked

0001-tpm-Rename-tpm.c-to-tpm-interface.c.patch has no obvious style problems and is ready for submission.

All the errors it reports without -M are pre-existing in tpm.c, and a
pure rename patch should not clean up pre-existing checkpatch errors,
IMHO..

My strategy to deal with this is to make things checkpatch clean
as they get moved out of tpm-interface.c, so in the follow up patches
tpm-sysfs.c and tpm-dev.c are both checkpatch clean even though the
original code from tpm.c was not.

Jason

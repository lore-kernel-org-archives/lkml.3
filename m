Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433Ab3IWWXg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 18:23:36 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:58642 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754330Ab3IWWXd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 18:23:33 -0400
Date: Mon, 23 Sep 2013 16:23:24 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Daniel De Graaf <dgdegra@tycho.nsa.gov>
Cc: tpmdd-devel@lists.sourceforge.net,
        Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, Rajiv Andrade <mail@srajiv.net>,
        Sirrix AG <tpmdd@sirrix.com>
Subject: Re: [tpmdd-devel] [PATCH 09/13] tpm: Pull everything related to
 sysfs into tpm-sysfs.c
Message-ID: <20130923222324.GA9533@obsidianresearch.com>
References: <1379960083-8942-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1379960083-8942-10-git-send-email-jgunthorpe@obsidianresearch.com>
 <52408E5D.4020904@tycho.nsa.gov>
 <20130923193633.GA9194@obsidianresearch.com>
 <5240A2A3.4040102@tycho.nsa.gov>
 <20130923204232.GB16345@obsidianresearch.com>
 <5240BA0E.3000304@tycho.nsa.gov>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5240BA0E.3000304@tycho.nsa.gov>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 23, 2013 at 06:00:46PM -0400, Daniel De Graaf wrote:

> In a PC client TPM, normal OS code (as opposed to firmware or microcode)
> is already restricted to locality 0-2. It may make sense to restrict
> locality 2 to the kernel, which would allow an in-kernel TPM seal
> command to be able to bind data so that userspace cannot unseal it.
> However, only allowing localities 0 and 1 to userspace may be too
> restrictive if userspace also wishes to use locality for separation,
> since locality 1 does not have the ability to reset any PCRs that
> locality 0 cannot also reset.
> The kernel could reserve only locality 1 for its own use, giving it the
> ability to seal data but not interfering with the ability to reset PCRs.
> This would be my preference, although it is less intuitive to allow code
> of lower privilege (userspace) to control the higher numbered locality
> 2.

This matches my vague understanding (we don't use localities here)

>> Perhaps a .config option would be useful to allow the system designer to
>> choose what, if any, locality to reserve for kernel use?

A runtime sysfs seems reasonable..

Would:
 user_default_locality
 kernel_default_locality
 user_allowed_localities (bitmask)
 supported_localities (bitmask)
 a GET_LOCALITY/SET_LOCALITY IOCTL to change localities of an open'd
  /dev/tpmX

Do the job?

At first glance anyhow. I wonder what in-kernel users would be
impacted by localities..

Any thoughts on root vs not-root? Would middelware want to use
localities?

Do you know anyone on the userspace SW side who could look at this?

Jason

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922Ab3I3VUN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 17:20:13 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:55268 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755171Ab3I3VUM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 17:20:12 -0400
Date: Mon, 30 Sep 2013 15:20:03 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Daniel De Graaf <dgdegra@tycho.nsa.gov>
Cc: tpmdd-devel@lists.sourceforge.net,
        Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, Rajiv Andrade <mail@srajiv.net>,
        Sirrix AG <tpmdd@sirrix.com>
Subject: Re: [tpmdd-devel] [PATCH 09/13] tpm: Pull everything related to
 sysfs into tpm-sysfs.c
Message-ID: <20130930212003.GA10393@obsidianresearch.com>
References: <1379960083-8942-10-git-send-email-jgunthorpe@obsidianresearch.com>
 <52408E5D.4020904@tycho.nsa.gov>
 <20130923193633.GA9194@obsidianresearch.com>
 <5240A2A3.4040102@tycho.nsa.gov>
 <20130923204232.GB16345@obsidianresearch.com>
 <5240BA0E.3000304@tycho.nsa.gov>
 <20130923222324.GA9533@obsidianresearch.com>
 <5241A199.1080505@tycho.nsa.gov>
 <20130930181005.GG28898@obsidianresearch.com>
 <5249E0CB.2070106@tycho.nsa.gov>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5249E0CB.2070106@tycho.nsa.gov>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 30, 2013 at 04:36:27PM -0400, Daniel De Graaf wrote:

> >I think using CONFIG_ options would make this feature unavaiable to
> >distro kernel users...
> 
> This just moves the problem - now you need a custom initrd instead of
> a custom kernel. Other TPM options like IMA's PCR selection also must
> be changed at CONFIG_ time, although that seems to be more justified
> since IMA in TCB mode is not usable on any distro kernel that makes
> the TPM driver a module (i.e. most or all of them).

A 'custom' initrd is something a distro can automate. Eg a distro's
initrd generation script could read /etc/tpm.cfg and generate an
initrd with the module load and correct sysfs writes. This is more
accessible than recompiling the kernel.

My comments would apply to IMA as well, it should work with standard
distros, meaning the initrd must be able to set it up. So, load the
module in the initrd, setup localities, select the PCR, then enable
IMA.

The bootloader should measure the kernel and initrd together.

IMHO, distros are not making it easy to enable TPM features, and
requiring a kernel recompile is not helping :)

> There is also the fact that the driver may not be able to tell if a
> locality is available without doing some kind of test command. The
> Xen

Make sense.

> Or, for more flexibility (I actually like this one better):
> 
>  - CONFIG_TPM_KERNEL_DEFAULT_LOCALITY = [int]
>  - CONFIG_TPM_KERNEL_LOCALITY_FIXED = [bool]
> 
> And sysfs contains:
>  - kernel_locality [0644, int; 0444 if FIXED=y or when locked(?)]
>  - lock_kernel_locality [write-once; only exists if FIXED=n]

Yes, this looks simple and sane.

But if there isn't really a need to have a hardwired kernel, the
defaults can be DEFAULT_LOCALITY=0, LOCALITY_FIXED=n and we can
recommend distros rely on the initrd.

> So far, nobody I have talked to has offered any strong opinions on
> what locality should be used or how it should be set. I think finding
> a developer of trousers may be the most useful to talk about how the
> ioctl portion of this would need to be set up - if someone is actually
> needed.

It would be nice to have a user! As I said, we don't use it here.

Jason

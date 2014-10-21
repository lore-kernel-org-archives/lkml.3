Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933334AbaJUQ4S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 12:56:18 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:36217 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932382AbaJUQ4R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 12:56:17 -0400
Date: Tue, 21 Oct 2014 10:55:51 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [tpmdd-devel] [PATCH] tpm: fix multiple race conditions in
 tpm_ppi.c
Message-ID: <20141021165551.GA28382@obsidianresearch.com>
References: <1413879761-25392-1-git-send-email-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413879761-25392-1-git-send-email-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 11:22:41AM +0300, Jarkko Sakkinen wrote:
> * Traversal of the ACPI device tree was not done right. It should lookup
>   PPI only under the ACPI device that it is associated. Otherwise, it could
>   match to a wrong PPI interface if there are two TPM devices in the device
>   tree.
> * Removed global ACPI handle and version string from tpm_ppi.c as this
>   is racy. Instead they should be associated with the chip.
> * Moved code just a tiny bit towards two-phase allocation to implement
>   fix for the PPI race conditions.
> * Added missing copyright platter in tpm_ppi.c.

The PPI parts of this look fine to me, and are a really nice cleanup,
thanks!

Personally, I'd sequence this commit right after your 'tpm: two-phase
chip management functions' commit because it makes it much saner (no
half step toward the new functions). I assume this is a theoretical
problem? Or do you have a two TPM system?

Jason

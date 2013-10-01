Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394Ab3JAW5s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 18:57:48 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:51077 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751303Ab3JAW5q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 18:57:46 -0400
Date: Tue, 1 Oct 2013 16:57:33 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Peter H?we <PeterHuewe@gmx.de>
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Ashley Lai <ashley@ashleylai.com>, Rajiv Andrade <mail@srajiv.net>,
        Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
        Marcel Selhorst <tpmdd@selhorst.net>, Sirrix AG <tpmdd@sirrix.com>
Subject: Re: [PATCH 08/13] tpm: Pull everything related to /dev/tpmX into
 tpm-dev.c
Message-ID: <20131001225733.GA5286@obsidianresearch.com>
References: <1379960083-8942-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1379960083-8942-9-git-send-email-jgunthorpe@obsidianresearch.com>
 <201310020052.40497.PeterHuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201310020052.40497.PeterHuewe@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 02, 2013 at 12:52:40AM +0200, Peter H?we wrote:
> Am Montag, 23. September 2013, 20:14:38 schrieb Jason Gunthorpe:
> > CLASS-dev.c is a common idiom for Linux subsystems
> > 
> > This pulls all the code related to the miscdev into tpm-dev.c and makes it
> > static. The identical file_operation structs in the drivers are purged and
> > the tpm common code unconditionally creates the miscdev.
> > 
> > Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> >  drivers/char/tpm/Makefile           |   2 +-
> >  drivers/char/tpm/tpm-dev.c          | 199
> 
> When compiling the tpm drivers as modules I get
> ERROR: "tpm_sysfs_del_device" [drivers/char/tpm/tpm.ko] undefined!
> ERROR: "tpm_dev_add_device" [drivers/char/tpm/tpm.ko] undefined!
> ERROR: "tpm_dev_del_device" [drivers/char/tpm/tpm.ko] undefined!
> ERROR: "tpm_sysfs_add_device" [drivers/char/tpm/tpm.ko] undefined!
> ERROR: "tpm_transmit" [drivers/char/tpm/tpm-sysfs.ko] undefined!
> ERROR: "tpm_pcr_read_dev" [drivers/char/tpm/tpm-sysfs.ko] undefined!
> ERROR: "tpm_getcap" [drivers/char/tpm/tpm-sysfs.ko] undefined!
> ERROR: "tpm_transmit" [drivers/char/tpm/tpm-dev.ko] undefined!

Oh, I am glad you can test modules..

I botched the makefile changes for the new .c files.

I believe it should be like this:

obj-$(CONFIG_TCG_TPM) += tpm-core.o
tpm-core-y := tpm.o tpm-dev.o tpm-sysfs.o

> I added a suitable patch with the appropriate EXPORT_SYMBOL_GPL declarations 
> to my testing branch. (also see next message)

EXPORT_SYMBOL_GPL is not correct, these are in-module references, not
cross module references, and I've deliberately not exported them to
prevent drivers from trying to use them inappropriately.

Let me know if you want me to respin things.

Regards,
Jason

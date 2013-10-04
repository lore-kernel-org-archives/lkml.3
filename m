Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755154Ab3JDPsO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 11:48:14 -0400
Received: from mout.gmx.net ([212.227.15.18]:64860 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754729Ab3JDPsM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 11:48:12 -0400
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: tpmdd-devel@lists.sourceforge.net, Ashley Lai <ashley@ashleylai.com>
Subject: TPM.ko module rename (was tpm: Pull everything related to /dev/tpmX into tpm-dev.c)
Date: Fri, 4 Oct 2013 17:50:01 +0200
User-Agent: KMail/1.13.7 (Linux/3.10.9; KDE/4.10.5; x86_64; ; )
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, Rajiv Andrade <mail@srajiv.net>,
        Sirrix AG <tpmdd@sirrix.com>
References: <1379960083-8942-1-git-send-email-jgunthorpe@obsidianresearch.com> <201310020114.18624.PeterHuewe@gmx.de> <20131003050504.GA2247@obsidianresearch.com>
In-Reply-To: <20131003050504.GA2247@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201310041750.01145.PeterHuewe@gmx.de>
X-Provags-ID: V03:K0:iGFsrWLrAwi9vA8UEPAGPGJ0NrgujSWP7Qt9UTgItAarZPilKeU
 DoX8Zm916rnByCSMv8NxlkKzSTDMiy2etYu1j1x2Z91gQs5tO+kQS1OiC8Jcc8JDchcZzE0
 GNRmcMon0wrYrIiShvP595FRFFb4Ogasoq9alw6nOTzrEmHUyzJs61qjH37A4T53vDh9Hdh
 SBPteo2b0dTObs/B8migA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 3. Oktober 2013, 07:05:04 schrieb Jason Gunthorpe:
> On Wed, Oct 02, 2013 at 01:14:18AM +0200, Peter H?we wrote:
> > > I botched the makefile changes for the new .c files.
> > > 
> > > I believe it should be like this:
> > > 
> > > obj-$(CONFIG_TCG_TPM) += tpm-core.o
> > > tpm-core-y := tpm.o tpm-dev.o tpm-sysfs.o
> > > 
> 
> It looks like my solution changes the tpm module name to tpm-core.o.
> This should be noted in the commit log:
> 
>  In doing so we also change the core tpm module name from 'tpm' to
> 'tpm-core', this is because kbuild does not like it if a multi-file module
> has a .c file of the same name.
> 
> Is that OK? It follows the pattern other systems have in the kernel.


Hmm,
I'm not 100% sure what's the usual procedure for module renames, especially 
since this is visible in userspace.

For users the easiest way would be to rename tpm.c to tpm-core.c and leave the 
module name as it is.
In git that's just a simple rename operation.

Thanks,
Peter

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154Ab3JAWvB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 18:51:01 -0400
Received: from mout.gmx.net ([212.227.17.22]:54434 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751783Ab3JAWu7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 18:50:59 -0400
From: Peter =?iso-8859-15?q?H=FCwe?= <PeterHuewe@gmx.de>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH 08/13] tpm: Pull everything related to /dev/tpmX into tpm-dev.c
Date: Wed, 2 Oct 2013 00:52:40 +0200
User-Agent: KMail/1.13.7 (Linux/3.10.9; KDE/4.10.5; x86_64; ; )
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Ashley Lai <ashley@ashleylai.com>, Rajiv Andrade <mail@srajiv.net>,
        Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
        Marcel Selhorst <tpmdd@selhorst.net>, Sirrix AG <tpmdd@sirrix.com>
References: <1379960083-8942-1-git-send-email-jgunthorpe@obsidianresearch.com> <1379960083-8942-9-git-send-email-jgunthorpe@obsidianresearch.com>
In-Reply-To: <1379960083-8942-9-git-send-email-jgunthorpe@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201310020052.40497.PeterHuewe@gmx.de>
X-Provags-ID: V03:K0:PoMyMOvcx2CaH2MEoeeCwlDFGXIZHPa6JY4pY38otTVj85nAolZ
 rw4375hTWqtAj0+bmlXbv/ZOBf8PJQw3Fq/jkiYFNFszCBv7qGRcPnfjlczOPpmk/mjgel6
 vCHUe4QoymShNWHGCFaS8S5XV62FTXaNqoJMn5cNgdu96byipoRrLK+yYAYID9Dil85Dem2
 5kaFEyoBhVQ2G0SGemWjg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 23. September 2013, 20:14:38 schrieb Jason Gunthorpe:
> CLASS-dev.c is a common idiom for Linux subsystems
> 
> This pulls all the code related to the miscdev into tpm-dev.c and makes it
> static. The identical file_operation structs in the drivers are purged and
> the tpm common code unconditionally creates the miscdev.
> 
> Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> ---
>  drivers/char/tpm/Makefile           |   2 +-
>  drivers/char/tpm/tpm-dev.c          | 199

When compiling the tpm drivers as modules I get
ERROR: "tpm_sysfs_del_device" [drivers/char/tpm/tpm.ko] undefined!
ERROR: "tpm_dev_add_device" [drivers/char/tpm/tpm.ko] undefined!
ERROR: "tpm_dev_del_device" [drivers/char/tpm/tpm.ko] undefined!
ERROR: "tpm_sysfs_add_device" [drivers/char/tpm/tpm.ko] undefined!
ERROR: "tpm_transmit" [drivers/char/tpm/tpm-sysfs.ko] undefined!
ERROR: "tpm_pcr_read_dev" [drivers/char/tpm/tpm-sysfs.ko] undefined!
ERROR: "tpm_getcap" [drivers/char/tpm/tpm-sysfs.ko] undefined!
ERROR: "tpm_transmit" [drivers/char/tpm/tpm-dev.ko] undefined!


I added a suitable patch with the appropriate EXPORT_SYMBOL_GPL declarations 
to my testing branch. (also see next message)


Thanks,
Peter

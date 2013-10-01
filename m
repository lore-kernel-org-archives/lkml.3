Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765Ab3JAXMk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 19:12:40 -0400
Received: from mout.gmx.net ([212.227.15.15]:49342 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751834Ab3JAXMh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 19:12:37 -0400
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH 08/13] tpm: Pull everything related to /dev/tpmX into tpm-dev.c
Date: Wed, 2 Oct 2013 01:14:18 +0200
User-Agent: KMail/1.13.7 (Linux/3.10.9; KDE/4.10.5; x86_64; ; )
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Ashley Lai <ashley@ashleylai.com>, Rajiv Andrade <mail@srajiv.net>,
        Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
        Marcel Selhorst <tpmdd@selhorst.net>, Sirrix AG <tpmdd@sirrix.com>
References: <1379960083-8942-1-git-send-email-jgunthorpe@obsidianresearch.com> <201310020052.40497.PeterHuewe@gmx.de> <20131001225733.GA5286@obsidianresearch.com>
In-Reply-To: <20131001225733.GA5286@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201310020114.18624.PeterHuewe@gmx.de>
X-Provags-ID: V03:K0:ecwd1wm5Jcrb+trZ3VbIQsqV6jcyxOpxptVE3KkDyiaafjeuFJX
 jA+XGmz4HjbFIaJN0wvo0vP/hhuUXtEdBX3ovHUJYcyYvtcdWUhdzvxKbnGnDV0VkepWNBb
 OqGYOg5CCyQ8RNaQ2oC9OlvUhHJCjjnahiVVCIAw/LXEgsglHbidjunDsL2rgapeD/zRBMc
 fxyJJsHOxw3xRZmn/4D8A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 2. Oktober 2013, 00:57:33 schrieb Jason Gunthorpe:
> > When compiling the tpm drivers as modules I get
> > ERROR: "tpm_sysfs_del_device" [drivers/char/tpm/tpm.ko] undefined!
> > ERROR: "tpm_dev_add_device" [drivers/char/tpm/tpm.ko] undefined!
> > ERROR: "tpm_dev_del_device" [drivers/char/tpm/tpm.ko] undefined!
> > ERROR: "tpm_sysfs_add_device" [drivers/char/tpm/tpm.ko] undefined!
> > ERROR: "tpm_transmit" [drivers/char/tpm/tpm-sysfs.ko] undefined!
> > ERROR: "tpm_pcr_read_dev" [drivers/char/tpm/tpm-sysfs.ko] undefined!
> > ERROR: "tpm_getcap" [drivers/char/tpm/tpm-sysfs.ko] undefined!
> > ERROR: "tpm_transmit" [drivers/char/tpm/tpm-dev.ko] undefined!
> 
> Oh, I am glad you can test modules..
> 
> I botched the makefile changes for the new .c files.
> 
> I believe it should be like this:
> 
> obj-$(CONFIG_TCG_TPM) += tpm-core.o
> tpm-core-y := tpm.o tpm-dev.o tpm-sysfs.o
> 
> > I added a suitable patch with the appropriate EXPORT_SYMBOL_GPL
> > declarations to my testing branch. (also see next message)
> 
> EXPORT_SYMBOL_GPL is not correct, these are in-module references, not
> cross module references, and I've deliberately not exported them to
> prevent drivers from trying to use them inappropriately.
Of course you're right - I just wanted to get it compile as fast as possible 
;)

The makefile patch did fix it.

Staged here 
https://github.com/PeterHuewe/linux-tpmdd/tree/testing-and-review
(along with a small fix for the tpm_i2c_atmel driver ;)


Thanks,
Peter

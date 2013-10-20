Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751390Ab3JTRrh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 13:47:37 -0400
Received: from mout.gmx.net ([212.227.17.20]:59301 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751051Ab3JTRrg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 13:47:36 -0400
MIME-Version: 1.0
Message-ID: <trinity-8f224018-6e4e-4683-921d-6d82d48f25d4-1382291254485@3capp-gmx-bs12>
From: "Peter Huewe" <PeterHuewe@gmx.de>
To: "Jason Gunthorpe" <jgunthorpe@obsidianresearch.com>
Cc: "Ashley Lai" <adlai@linux.vnet.ibm.com>,
        "Leonidas Da Silva Barbosa" <leosilva@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, "Rajiv Andrade" <mail@srajiv.net>,
        tpmdd-devel@lists.sourceforge.net, "Sirrix AG" <tpmdd@sirrix.com>
Subject: Aw: Re: [tpmdd-devel] TPM patches for 2.13
Content-Type: text/plain; charset=UTF-8
Date: Sun, 20 Oct 2013 19:47:34 +0200 (CEST)
Importance: normal
Sensitivity: Normal
In-Reply-To: <20131020170017.GA32542@obsidianresearch.com>
References: <20131006193120.GA26137@obsidianresearch.com>
 <20131017145724.GA6528@obsidianresearch.com>
 <1382260018.11008.5.camel@fishsauce>,
 <20131020170017.GA32542@obsidianresearch.com>
Content-Transfer-Encoding: 8BIT
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K0:Li9onnE7NVVibjl2FV8rvShwcTlFyusVogsFUTjgOUX
 /eISmZrGnVfnBysoMqJB6HI6aDXR/C+6iO2t8igiGTTocjobR3
 vsbGaoeYSKG4ZFUS2jvBy13VNAnzG3vUHihlWK6rj18PJB4Wmb
 Z0VoeAVW6Eqfd8AWRsy5mMXf/j2FnNbjHFDAedB2O3QH33WcJF
 hhSYDqxzUNaweZN77Py+B2GK6Uww2LXz7R7YTwQxlwGqz/xZPi
 Er8cbVvJkAKvmbANQ5RBF24oMG47sFwwG6K/77rBm6/EJyZ2lQ pxv71k=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 
Hi Jason, Ashley,
I think it's okay to leave the checkpatch complaints as they are as they aren't newly introduced.
I'm currently in the process of digging through the patches again and getting the pull request ready.
Maybe I'll fix them while at it.

Thanks,
Peter 
 

> Hi Jason,
> Patch 0008-tpm-Rename-tpm.c-to-tpm-interface.c.patch does not meet the
> Linux kernel's coding standards. Please fix the errors found by
> checkpatch.pl and let me know when it's ready. Thanks.

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

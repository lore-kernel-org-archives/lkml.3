Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785AbaD3AkW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 20:40:22 -0400
Received: from mail1.bemta8.messagelabs.com ([216.82.243.201]:32808 "EHLO
	mail1.bemta8.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755126AbaD3AkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 20:40:18 -0400
X-Greylist: delayed 375 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Apr 2014 20:40:17 EDT
X-Env-Sender: schivers@csc.com.au
X-Msg-Ref: server-9.tower-86.messagelabs.com!1398818039!46713101!1
X-Originating-IP: [20.137.2.180]
X-StarScan-Received: 
X-StarScan-Version: 6.11.1; banners=-,-,-
X-VirusChecked: Checked
In-Reply-To: <1398215901-25609-1-git-send-email-robherring2@gmail.com>
References: <1398215901-25609-1-git-send-email-robherring2@gmail.com>
To: Rob Herring <robherring2@gmail.com>
Cc: Aurelien Jacquiot <a-jacquiot@ti.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Chris Zankel <chris@zankel.net>, devicetree@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        "H. Peter Anvin" <hpa@zytor.com>, James Hogan <james.hogan@imgtec.co>,
        linux-kernel@vger.kernel.org, linux-kernel-owner@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, linuxppc-dev@lists.ozlabs.org
MIME-Version: 1.0
Subject: Re: [PATCH v2 00/21] FDT clean-ups and libfdt support
X-KeepSent: AA1D4E52:AF067B90-CA257CCA:0001CA91;
 type=4; name=$KeepSent
X-Mailer: Lotus Notes Release 8.5.2FP4 SHF97 March 26, 2012
From: Stephen N Chivers <schivers@csc.com.au>
Message-ID: <OFAA1D4E52.AF067B90-ONCA257CCA.0001CA91-CA257CCA.00031A7A@csc.com>
Date: Wed, 30 Apr 2014 11:33:53 +1100
X-MIMETrack: Serialize by Router on AMER-GW15/SRV/CSC(Release 8.5.2FP3 HF666|December 11, 2012) at
 04/29/2014 08:33:59 PM,
	Serialize complete at 04/29/2014 08:33:59 PM
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Rob Herring <robherring2@gmail.com>
> To: Grant Likely <grant.likely@linaro.org>, linux-
> kernel@vger.kernel.org, devicetree@vger.kernel.org
> Cc: Rob Herring <robh@kernel.org>, Aurelien Jacquiot <a-
> jacquiot@ti.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
> Chris Zankel <chris@zankel.net>, "H. Peter Anvin" <hpa@zytor.com>, 
> Ingo Molnar <mingo@redhat.com>, James Hogan <james.hogan@imgtec.co>
> Date: 04/30/2014 09:45 AM
> Subject: [PATCH v2 00/21] FDT clean-ups and libfdt support
> Sent by: linux-kernel-owner@vger.kernel.org
> 
> From: Rob Herring <robh@kernel.org>
> 
> This is a series of clean-ups of architecture FDT code and converts the
> core FDT code over to using libfdt functions. This is in preparation
> to add FDT based address translation parsing functions for early
> console support. This series removes direct access to FDT data from all
> arches except powerpc.
> 
> The current MIPS lantiq and xlp DT code is buggy as built-in DTBs need
> to be copied out of init section. Patches 2 and 3 should be applied to
> 3.15.
> 
> Changes in v2 are relatively minor. There was a bug in the unflattening
> code where walking up the tree was not being handled correctly (thanks
> to Michal Simek). I re-worked things a bit to avoid globally adding
> libfdt include paths.
> 
> A branch is available here[1], and I plan to put into linux-next in a 
few
> days. Please test! I've compiled on arm, arm64, mips, microblaze, 
xtensa,
> and powerpc and booted on arm and arm64.
I have tested this for PowerPC using a snapshot of libfdt[1] collected 
from
the today (30/04/2014).

The computers used were 32 bit, Freescale and IBM/AMCC CPUs:

        MVME5100 - Motorola/Fresscale CPU - PPCBug firmware
        SAM440EP - IBM/AMCC - U-Boot firmware

Tested-by: Stephen Chivers <schivers@csc.com>

Stephen Chivers,
CSC Australia Pty. Ltd.

[1] git://git.kernel.org/pub/scm/linux/kernel/git/robh/linux.git libfdt


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555Ab3DVMiV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 08:38:21 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:65432 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752840Ab3DVMiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 08:38:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Lars-Peter Clausen" <lars@metafoo.de>
Subject: Re: [PATCH 1/2] dma: of: Remove restriction that #dma-cells can't be 0
Date: Mon, 22 Apr 2013 14:38:15 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: Vinod Koul <vinod.koul@intel.com>, Jon Hunter <jon-hunter@ti.com>,
        linux-kernel@vger.kernel.org
References: <1366619613-30639-1-git-send-email-lars@metafoo.de>
In-Reply-To: <1366619613-30639-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201304221438.15945.arnd@arndb.de>
X-Provags-ID: V02:K0:Z8quxkAE6OVNzcRgtohF+oAWKkbS0zMDXnh3lpcsDwQ
 imp1kmhFvLAaY3iEjzQppfWAm9UlyriBWFGcWAbhHZEt4+YM5g
 I218P8Gy3AnLABOmTKUmzI2AFkLMQjVRXbVpIF46q303tOnd4P
 aLzlz7C2RxWW84KEMmHENq3pMKBzHqZTZZAEoq18EYWA4ptTE4
 AS25W2Hs8543iGFJ8SdAIMopG9qMMq/onTUyU1Zr9mIKtHwJ4N
 ZLPRPTbERQG3hyygHNg2oMJJJvF8ainhvesSQsGGWYNl7SrD2n
 trfSHNrSsBT/+5pysQZnsWhRhv/l2imrWGBudghou1fIaJTemW
 9RyXvbsX35+UDknkYpbI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 April 2013, Lars-Peter Clausen wrote:
> 
> There is no sensible reason why #dma-cells shouldn't be allowed to be 0. It is
> completely up to the DMA controller how many additional parameters, besides the
> phandle, it needs to identify a channel. E.g. for DMA controller with only one
> channel or for DMA controllers which don't have a restriction on which channel
> can be used for which peripheral it completely legitimate to not require any
> additional parameters.
> 
> Also fixes the following warning:
>         drivers/dma/of-dma.c: In function 'of_dma_controller_register':
>         drivers/dma/of-dma.c:67:7: warning: 'nbcells' may be used uninitialized in this function
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>

Do you have an example for this? If a dma engine has only one request line,
why would you even use the dmaengine subsystem for it, rather than including
the code to program it in the slave driver?

	Arnd

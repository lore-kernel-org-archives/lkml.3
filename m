Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121Ab3BDDXH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 22:23:07 -0500
Received: from ozlabs.org ([203.10.76.45]:39725 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754024Ab3BDDXB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 22:23:01 -0500
Message-ID: <1359948180.25414.11.camel@concordia>
Subject: Re: [PATCH 0/3] Enable multiple MSI feature in pSeries
From: Michael Ellerman <michael@ellerman.id.au>
To: Mike Qiu <qiudayu@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de
Date: Mon, 04 Feb 2013 14:23:00 +1100
In-Reply-To: <1358235536-32741-1-git-send-email-qiudayu@linux.vnet.ibm.com>
References: <1358235536-32741-1-git-send-email-qiudayu@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-01-15 at 15:38 +0800, Mike Qiu wrote:
> Currently, multiple MSI feature hasn't been enabled in pSeries,
> These patches try to enbale this feature.

Hi Mike,

> These patches have been tested by using ipr driver, and the driver patch
> has been made by Wen Xiong <wenxiong@linux.vnet.ibm.com>:

So who wrote these patches? Normally we would expect the original author
to post the patches if at all possible.

> [PATCH 0/7] Add support for new IBM SAS controllers

I would like to see the full series, including the driver enablement.

> Test platform: One partition of pSeries with one cpu core(4 SMTs) and 
>                RAID bus controller: IBM PCI-E IPR SAS Adapter (ASIC) in POWER7
> OS version: SUSE Linux Enterprise Server 11 SP2  (ppc64) with 3.8-rc3 kernel 
> 
> IRQ 21 and 22 are assigned to the ipr device which support 2 mutiple MSI.
> 
> The test results is shown by 'cat /proc/interrups':
>           CPU0       CPU1       CPU2       CPU3       
> 21:          6          5          5          5      XICS Level     host1-0
> 22:        817        814        816        813      XICS Level     host1-1

This shows that you are correctly configuring two MSIs.

But the key advantage of using multiple interrupts is to distribute load
across CPUs and improve performance. So I would like to see some
performance numbers that show that there is a real benefit for all the
extra complexity in the code.

cheers


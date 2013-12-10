Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337Ab3LJSuK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 13:50:10 -0500
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:17089 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071Ab3LJSuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 13:50:07 -0500
X-IronPort-AV: E=Sophos;i="4.93,866,1378882800"; 
   d="scan'208";a="1601084"
Subject: Re: [PATCH] net-tg3: Initialize REG_BASE_ADDR at PCI config offset
 120 to 0
From: Michael Chan <mchan@broadcom.com>
To: David Miller <davem@davemloft.net>
CC: <sergei.shtylyov@cogentembedded.com>, <natg@google.com>,
        <nsujir@broadcom.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
In-Reply-To: <20131210.134340.114603867817512238.davem@davemloft.net>
References: <52A633B4.9000307@cogentembedded.com>
	 <1386623253.1752.6.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
	 <1386658724.1752.19.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
	 <20131210.134340.114603867817512238.davem@davemloft.net>
Content-Type: text/plain; charset="cp1252"
Date: Tue, 10 Dec 2013 10:49:39 -0800
Message-ID: <1386701379.1752.26.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-12-10 at 13:43 -0500, David Miller wrote:

> What if the kernel is booted via kexec, and the driver in the kernel
> we are kexec'ing from left indirect access enabled in MISC_HOST_CTRL?

That should be ok.  The driver will only use valid register offsets in
indirect mode during run time, so register 0x78 should point to a valid
register.  If indirect mode is never used by the driver, it will point
to zero with this patch.  So register 0x78 will be valid (or zero) in
the kexec'ed kernel.



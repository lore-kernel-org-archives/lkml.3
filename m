Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929AbaIHWC4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 18:02:56 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:48924 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753724AbaIHWCz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 18:02:55 -0400
Date: Mon, 8 Sep 2014 16:02:38 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Scot Doyle <lkml14@scotdoyle.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>,
        Stefan Berger <stefanb@linux.vnet.ibm.com>,
        Luigi Semenzato <semenzato@google.com>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v6] tpm_tis: verify interrupt during init
Message-ID: <20140908220238.GB6204@obsidianresearch.com>
References: <20140827173142.GA11183@obsidianresearch.com>
 <alpine.LNX.2.11.1408271755470.4371@localhost.localdomain>
 <20140827214743.GC11183@obsidianresearch.com>
 <alpine.LNX.2.11.1408280017420.1064@localhost.localdomain>
 <20140828165348.GE11183@obsidianresearch.com>
 <alpine.LNX.2.11.1408290234060.1020@localhost.localdomain>
 <20140830174920.GA26218@obsidianresearch.com>
 <alpine.LNX.2.11.1408302229001.579@localhost.localdomain>
 <20140902172015.GD13956@obsidianresearch.com>
 <alpine.LNX.2.11.1409021954110.1026@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.11.1409021954110.1026@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02, 2014 at 08:22:58PM +0000, Scot Doyle wrote:

> It's spending that time (now 3 seconds) in tpm_tis_send_data.

Due to request_locality?

> > Looks really good to me, I can try and test the next version here this
> > week.
> 
> Thanks!

So, I forgot my TIS systems have no IRQ, can't really test it
properly, but it compiles and doesn't muck up the no irq specified
case at least.

> +		if (test_irq) {

Should be 

if (test_irq && !priv->irq_tested)

We don't need to msleep if we got an irq already.

Reviewed-By: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>

You should post a final version and try and get it tested on a normal
x86 system.

Jason

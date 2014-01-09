Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880AbaAIRf0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 12:35:26 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:42095 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755235AbaAIRfS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 12:35:18 -0500
Date: Thu, 9 Jan 2014 10:35:05 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: boris brezillon <b.brezillon@overkiz.com>
Cc: devicetree@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        linux-doc@vger.kernel.org, dev@linux-sunxi.org,
        linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
        Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        David Woodhouse <dwmw2@infradead.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 3/9] of: mtd: add NAND timings retrieval support
Message-ID: <20140109173505.GB8899@obsidianresearch.com>
References: <1389190924-26226-1-git-send-email-b.brezillon@overkiz.com>
 <1389190924-26226-4-git-send-email-b.brezillon@overkiz.com>
 <20140108183418.GA12358@obsidianresearch.com>
 <52CDA032.3010804@overkiz.com>
 <20140108191339.GB12358@obsidianresearch.com>
 <52CE5F82.6070802@overkiz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52CE5F82.6070802@overkiz.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 09, 2014 at 09:36:18AM +0100, boris brezillon wrote:

> >You might want to check if you can boil down the DT timings from the
> >huge list to just an ONFI mode number..
> 
> Sure, but the sunxi driver needs at least 19 of them...

So does mvebu's NAND driver..

What I ment was you could have a

  onfi,nand-timing-mode = 0

in the DT. Each of the modes defines all ~19 parameters, higher modes
are faster.

Pick a mode value that fits all the parameters of the connected
non-ONFI flash.

This would be instead of defining each parameter
individually.. Provide some helpers to convert from a onfi mode number
to all the onfi defined timing parameters so that drivers can
configure the HW..

Jason

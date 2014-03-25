Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872AbaCYRBI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 13:01:08 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:41815 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752779AbaCYRBG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 13:01:06 -0400
Date: Tue, 25 Mar 2014 11:01:02 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        angus.clark@st.com, kernel@stlinux.com, linux-mtd@lists.infradead.org,
        pekon@ti.com, computersforpeace@gmail.com, dwmw2@infradead.org,
        Boris BREZILLON <b.brezillon.dev@gmail.com>
Subject: Re: [RFC 02/47] mtd: nand: add ONFI NAND Timing Mode Specifications
Message-ID: <20140325170102.GC30641@obsidianresearch.com>
References: <1395735604-26706-1-git-send-email-lee.jones@linaro.org>
 <1395735604-26706-3-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395735604-26706-3-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2014 at 08:19:19AM +0000, Lee Jones wrote:
> This patch adds a new structure, 'nand_timing_spec', to capture the A/C
> timing characteristics of NAND devices.

Boris BREZILLON <b.brezillon.dev@gmail.com> has been working on a
similar patch for a time now, and I think has an implementation for
the sunxi driver.
 
> some of the major NAND manufacturers (e.g. Samsung, Toshiba). Here we
> have followed broadly the ONFI timing definitions.

Timing specifications that are not precisely defined are
useless.. I would stick entirely with the well defined ONFI ones
until a need arises..

> + * Note, 'tR' field (maximum page read time) is extracted from the ONFI
> + * parameter page during device probe.
> + */
> +struct nand_timing_spec nand_onfi_timing_specs[] = {

const?

> +	/*
> +	 * ONFI Timing Mode '0' (supported on all ONFI compliant devices)
> +	 */
> +	[0] = {
> +		.tCLS	= 50,
> +		.tCS	= 70,
> +		.tALS	= 50,

Use picoseconds, ns is already loosing precision at the higher timing
modes.

Cheers,
Jason

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682AbaG2CkS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 22:40:18 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:35007 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779AbaG2CkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 22:40:16 -0400
Date: Mon, 28 Jul 2014 08:39:35 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        Alex Duyck <alexander.h.duyck@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        Mitch Williams <mitch.a.williams@intel.com>,
        Linux NICS <linux.nics@intel.com>, e1000-devel@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ethernet: intel: ixgbe: ixgbe_main.c:  Cleaning up
 missing null-terminate in conjunction with strncpy
Message-ID: <20140728083935.6f4b77c1@samsung-9>
In-Reply-To: <1406384676-2606-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1406384676-2606-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Jul 2014 16:24:36 +0200
Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se> wrote:

> Replacing strncpy with strlcpy to avoid strings that lacks null terminate.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
			   hw->mac.type, hw->phy.type, hw->phy.sfp_type,

This patch doesn't change anything.
Netdev is already zeroed when allocated therefore doing strncpy() guarantees
it will be null terminated.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787Ab3AREMQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 23:12:16 -0500
Received: from mail.kernel.org ([198.145.19.201]:52833 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751869Ab3AREMP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 23:12:15 -0500
Date: Thu, 17 Jan 2013 20:13:22 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
        Jason Baron <jbaron@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: Re: linux-next: build failure after merge of the driver-core tree
Message-ID: <20130118041322.GA25106@kroah.com>
References: <20130118132904.ec0677175f1191290f060776@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130118132904.ec0677175f1191290f060776@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2013 at 01:29:04PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> After merging the driver-core tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> In file included from drivers/net/wireless/ath/wil6210/wil6210.h:24:0,
>                  from drivers/net/wireless/ath/wil6210/main.c:26:
> drivers/net/wireless/ath/wil6210/dbg_hexdump.h:21:0: error: "print_hex_dump_bytes" redefined [-Werror]
> include/linux/printk.h:322:0: note: this is the location of the previous definition
> 
> Caused by commit 7a555613eb77 ("dynamic_debug: dynamic hex dump")
> interacting with commit 2be7d22f0625 ("wireless: add new wil6210 802.11ad
> 60GHz driver") that was added to Linus' tree in the last few days.
> 
> I have applied the following merge fix patch for today:
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Fri, 18 Jan 2013 13:24:32 +1100
> Subject: [PATCH] wireless: remove conflicting version of print_hex_dump_bytes
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

Thanks, I've merged 3.9-rc4 into my tree and applied this patch to fix
the build breakage.

greg k-h

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241AbaHDLtz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 07:49:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57835 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751769AbaHDLty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 07:49:54 -0400
Date: Mon, 4 Aug 2014 13:49:48 +0200
From: Joerg Roedel <jroedel@suse.de>
To: Borislav Petkov <bp@alien8.de>
Cc: Joerg Roedel <joro@8bytes.org>, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Jiang Liu <jiang.liu@linux.intel.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] iommu/vt-d: Do not BUG_ON in intel_unmap if no domain
Message-ID: <20140804114948.GA8172@suse.de>
References: <1407151386-16467-1-git-send-email-joro@8bytes.org>
 <20140804114205.GA5545@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140804114205.GA5545@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2014 at 01:42:05PM +0200, Borislav Petkov wrote:
> It is always questionable when people remove BUG_ONs because relaxing
> assertions sound like a temporary fix more often than not. Sounds to me
> that the original commit which deals with BUS_NOTIFY_DEL_DEVICE needs to
> try again with the fix. :-)

Right, but the "real" fix would be to add a bus notifier that is called
after the device driver released the device and use this one instead of
BUS_NOTIFY_DEL_DEVICE.

But that change wouldn't be suitable for -stable and just removing the
event handler for BUS_NOTIFY_DEL_DEVICE would cause resource leakage
again on hotplug, so I think this "fix" is the best for now.

We can re-add the BUG_ON when we have a real fix upstream.


	Joerg


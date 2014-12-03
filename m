Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125AbaLCKfK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 05:35:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53653 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751593AbaLCKfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 05:35:09 -0500
Date: Wed, 3 Dec 2014 11:35:06 +0100
From: Joerg Roedel <jroedel@suse.de>
To: WANG Chao <chaowang@redhat.com>
Cc: Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] Fix kdump failures with crashkernel=high
Message-ID: <20141203103506.GN3156@suse.de>
References: <1417174149-31210-1-git-send-email-joro@8bytes.org>
 <20141203040123.GB23163@dhcp-17-37.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141203040123.GB23163@dhcp-17-37.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Dec 03, 2014 at 12:01:23PM +0800, WANG Chao wrote:
>From your experience It seems like swiotlb isn't working well with
> crashkernel=X,high alone. What about using crashkernel=X,low with
> crashkernel=X,high? Is there any reason you have to use
> crashkernel=X,high alone?

Sure, when I specify an additional crashkernel=X,low then I can get
things to work this way too. But my patch-set is about changing the
default, since the failure was seen on common server systems with the
defaults.

> crashkernel=X,high shouldn't automatically reserve 72M low at the first
> place. Now it's going insane if you increase it to 256M by default.

How should a kernel without some low memory (which has only memory above
4G available) handle any 32bit DMA devices? There would be no way to
allocate DMA-able memory for those devices.

And as I said, if people prefer it I can change the patch-set so that
the amount of low-memory allocated is subtracted from the amount of
high-memory. This way the overall memory usage for kdump would stay the
same while changing the defaults to work on more systems.


	Joerg


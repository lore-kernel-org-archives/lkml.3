Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528Ab3KNP0s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 10:26:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9210 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754177Ab3KNP0n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 10:26:43 -0500
Date: Thu, 14 Nov 2013 10:26:23 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: jerry.hoemann@hp.com, rob@landley.net, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, matt.fleming@intel.com,
        yinghai@kernel.org, penberg@kernel.org, akpm@linux-foundation.org,
        linux-doc@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] Early use of boot service memory
Message-ID: <20131114152623.GC3913@redhat.com>
References: <1384222558-38527-1-git-send-email-jerry.hoemann@hp.com>
 <d73ccce9-6a0d-4470-bda3-f0c6eb96b5e4@email.android.com>
 <20131113224503.GB25344@anatevka.fc.hp.com>
 <52840206.5020006@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52840206.5020006@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 13, 2013 at 02:49:42PM -0800, H. Peter Anvin wrote:

[..]
> In other words, allocating the crashkernel high has ALL the advantages,
> plus a few more, and NONE of the disadvantages.

It allocates low memory for swiotlb. So that extra 72M allocation is the
disadvantage. With so many virtual machines on a single host, I don't
want to reserve extra 72MB on each virtual machine while I could
easily do away with memory reservation below 4G. 

So I do think that first trying memory below 896M, then below 4G and then
above 4G makes sense and we should modify crashkernel=X to handle that.

Thanks
Vivek

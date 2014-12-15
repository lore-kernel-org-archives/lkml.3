Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751381AbaLOXcJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 18:32:09 -0500
Received: from ozlabs.org ([103.22.144.67]:38376 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751227AbaLOXcH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 18:32:07 -0500
Message-ID: <1418686323.3241.1.camel@ellerman.id.au>
Subject: Re: [PATCH 7/7] CXL: Unmap MMIO regions when detaching a context
From: Michael Ellerman <mpe@ellerman.id.au>
To: Ian Munsie <imunsie@au1.ibm.com>
Cc: benh <benh@kernel.crashing.org>, mikey <mikey@neuling.org>,
        anton <anton@samba.org>, linux-kernel <linux-kernel@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@ozlabs.org>, jk <jk@ozlabs.org>,
        cbe-oss-dev <cbe-oss-dev@lists.ozlabs.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Philippe Bergheaud <philippe.bergheaud@fr.ibm.com>
Date: Tue, 16 Dec 2014 10:32:03 +1100
In-Reply-To: <1418613792-sup-5165@delenn.ozlabs.ibm.com>
References: <1418026681-14787-1-git-send-email-imunsie@au.ibm.com>
	 <1418026681-14787-7-git-send-email-imunsie@au.ibm.com>
	 <1418613792-sup-5165@delenn.ozlabs.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-12-15 at 14:32 +1100, Ian Munsie wrote:
> Excerpts from Ian Munsie's message of 2014-12-08 19:18:01 +1100:
> > From: Ian Munsie <imunsie@au1.ibm.com>
> > 
> > If we need to force detach a context (e.g. due to EEH or simply force
> > unbinding the driver) we should prevent the userspace contexts from
> > being able to access the Problem State Area MMIO region further, which
> > they may have mapped with mmap().
> > 
> > This patch unmaps any mapped MMIO regions when detaching a userspace
> > context.
> 
> Might want to drop this one for now - Philippe found that it sometimes
> causes an issue when multiple contexts are using the afu. Seems that
> unmap_mapping_range() unmapped a bit more than I expected.

Sorry, it's already in next.

https://git.kernel.org/cgit/linux/kernel/git/mpe/linux.git/commit/?h=next&id=b123429e6a9e8d03aacf888d23262835f0081448

Send me a revert or a fixup.

cheers



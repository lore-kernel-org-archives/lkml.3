Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622AbbAZMH7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 07:07:59 -0500
Received: from 8bytes.org ([81.169.241.247]:46062 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752202AbbAZMH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 07:07:57 -0500
Date: Mon, 26 Jan 2015 13:07:56 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Baoquan He <bhe@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Joerg Roedel <jroedel@suse.de>
Subject: Re: [PATCH 3/3] x86, crash: Allocate enough low-mem when
 crashkernel=high
Message-ID: <20150126120756.GF30345@8bytes.org>
References: <1420555874-11506-1-git-send-email-joro@8bytes.org>
 <1420555874-11506-4-git-send-email-joro@8bytes.org>
 <20150123084453.GL2461@dhcp-16-105.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150123084453.GL2461@dhcp-16-105.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Baoquan,

thanks for your reply.

On Fri, Jan 23, 2015 at 04:44:53PM +0800, Baoquan He wrote:
> 2) increase low-mem when crashkernel=high. But we have to be careful to
> do this. We implement crashkernel=high not only for the unhappiness
> crashkernel reservation is limited below 4G, but dma/dma32 memory space
> is precious on some systems. If set crashkernel=high still too much low
> memory has to be reserved by default, it's important to find the
> balance. So if we have to increase the default low-mem, how much memory
> is enough, why 256M?  why not 128M/192M/320M/384M?  And if 256M works
> on your system, what if another person say it does't work because there
> are more devices on his system?
> 
> Anyway, I understand the requirement, but we need find out how much
> memory can satisfy most of systems.

Yes, I totally agree that it is tough to find a good default here. I
used 256MB because this is what was required on the system the  failed
kdumps were reported on.

But probably we can agree that 72MB is not enough (given that 64MB are
taken away by swiotlb already), and increase it to a value we think by
now is sufficient for most systems.

Btw, the issue was also reported on machines with only a few devices,
the reason there is that device drivers allocate more dma memory by
default on intilization. Maybe we should handle that as a driver
regression in the future, forcing them to allocate more dma-memory
on-demand and not on initialization.


	Joerg


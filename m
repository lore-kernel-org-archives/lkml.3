Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462AbaEOPaf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 11:30:35 -0400
Received: from smtp.citrix.com ([66.165.176.89]:62007 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751551AbaEOPae (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 11:30:34 -0400
X-IronPort-AV: E=Sophos;i="4.97,1060,1389744000"; 
   d="scan'208";a="131527407"
Message-ID: <5374DD84.20904@citrix.com>
Date: Thu, 15 May 2014 16:30:12 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: <xen-devel@lists.xenproject.org>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        <x86@kernel.org>, Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCHv6 0/9] x86/xen: fixes for mapping high MMIO regions (and
 remove _PAGE_IOMAP)
References: <1397571337-20409-1-git-send-email-david.vrabel@citrix.com>
In-Reply-To: <1397571337-20409-1-git-send-email-david.vrabel@citrix.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/04/14 15:15, David Vrabel wrote:
> This a fix for the problems with mapping high MMIO regions in certain
> cases (e.g., the RDMA drivers) as not all mappers were specifing
> _PAGE_IOMAP which meant no valid MFN could be found and the resulting
> PTEs would be set as not present, causing subsequent faults.

I've applied patches #1 to #6 to devel/for-linus-3.16.  These fix the
bug.  Patches #7 to #9 remove _PAGE_IOMAP but depend on an x86 change
which is not yet acked and I'm not going to delay (again) the bug fix
for this.

David

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096Ab3J1QbL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 12:31:11 -0400
Received: from mouse.start.ca ([64.140.120.56]:53474 "EHLO mouse.start.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756893Ab3J1QbI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 12:31:08 -0400
Message-ID: <526E9138.9090503@start.ca>
Date: Mon, 28 Oct 2013 12:30:48 -0400
From: Mark Lord <kernel@start.ca>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Alexander Gordeev <agordeev@redhat.com>,
        David Laight <David.Laight@ACULAB.COM>
CC: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ben Hutchings <bhutchings@solarflare.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pci@vger.kernel.org
Subject: Re: [PATCH RFC v2 12/29] PCI/MSI: Introduce pcim_enable_msi*() family
 helpers
References: <cover.1382103786.git.agordeev@redhat.com> <6bc575621ef70f72b206e4aa944acd32f1a75718.1382103786.git.agordeev@redhat.com> <20131024105158.GB13159@mtj.dyndns.org> <AE90C24D6B3A694183C094C60CF0A2F6026B73AA@saturn3.aculab.com> <20131024114133.GA26610@dhcp-26-207.brq.redhat.com> <5269D5D1.60103@start.ca> <AE90C24D6B3A694183C094C60CF0A2F6026B73B0@saturn3.aculab.com> <20131025100103.GA317@dhcp-26-207.brq.redhat.com>
In-Reply-To: <20131025100103.GA317@dhcp-26-207.brq.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-10-25 06:01 AM, Alexander Gordeev wrote:
>
> If this problem really exists anywhere besides pSeries?
> 
> I can imagine x86 hitting lack of vectors in interrupt table when
> number of CPUs exceeds hundreds, but do we have this problem now?

An awful lot of x86 hardware has a 256 (255?) vector limit for MSI/MSI-X.
Couple that with PCIe Virtual Functions, each wanting 16 vectors (for example),
and that limit is really simple to exceed today.

But this is more a problem for a sysadmin, and I am happy with the current
and the proposed methods.

Cheers

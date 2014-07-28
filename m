Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578AbaG1NY3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 09:24:29 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:51851 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbaG1NY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 09:24:26 -0400
X-IronPort-AV: E=Sophos;i="5.01,749,1400025600"; 
   d="scan'208";a="156894356"
Message-ID: <53D64F07.1070106@citrix.com>
Date: Mon, 28 Jul 2014 14:24:23 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Vitaly Kuznetsov <vkuznets@redhat.com>, <xen-devel@lists.xenproject.org>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Andrew Jones <drjones@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC 0/4] xen/pvhvm: fix shared_info and pirq issues with
 kexec
References: <1405431640-649-1-git-send-email-vkuznets@redhat.com>
In-Reply-To: <1405431640-649-1-git-send-email-vkuznets@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/07/14 14:40, Vitaly Kuznetsov wrote:
> With this patch series I'm trying to address several issues with kexec on pvhvm:
> - shared_info issue (1st patch, just sending Olaf's work with Konrad's fix)
> - create specific pvhvm shutdown handler for kexec (2nd patch)
> - GSI PIRQ issue (3rd patch, I'm pretty confident that it does the right thing)
> - MSI PIRQ issue (4th patch, and I'm not sure it doesn't break anything -> RFC)
> 
> This patch series can be tested on single vCPU guest. We still have SMP issues with
> pvhvm guests and kexec which require additional fixes.

In addition to the fixes for multi-VCPU guests, what else remains?

What's the plan for handling granted pages?

I don't think we want to accept a partial solution unless the known
non-working configurations fail fast on kexec load.

David

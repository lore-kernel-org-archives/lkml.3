Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987AbaKKRst (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 12:48:49 -0500
Received: from smtp.citrix.com ([66.165.176.89]:64999 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751274AbaKKRss (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 12:48:48 -0500
X-IronPort-AV: E=Sophos;i="5.07,362,1413244800"; 
   d="scan'208";a="190235669"
Message-ID: <54624BFC.6000205@citrix.com>
Date: Tue, 11 Nov 2014 17:48:44 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Juergen Gross <jgross@suse.com>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xensource.com>, <konrad.wilk@oracle.com>,
        <david.vrabel@citrix.com>, <boris.ostrovsky@oracle.com>,
        <x86@kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <hpa@zytor.com>
Subject: Re: [Xen-devel] [PATCH V3 8/8] xen: Speed up set_phys_to_machine()
 by using read-only mappings
References: <1415684626-18590-1-git-send-email-jgross@suse.com> <1415684626-18590-9-git-send-email-jgross@suse.com>
In-Reply-To: <1415684626-18590-9-git-send-email-jgross@suse.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/14 05:43, Juergen Gross wrote:
> Instead of checking at each call of set_phys_to_machine() whether a
> new p2m page has to be allocated due to writing an entry in a large
> invalid or identity area, just map those areas read only and react
> to a page fault on write by allocating the new page.
> 
> This change will make the common path with no allocation much
> faster as it only requires a single write of the new mfn instead
> of walking the address translation tables and checking for the
> special cases.

Reviewed-by: David Vrabel <david.vrabel@citrix.com>

David

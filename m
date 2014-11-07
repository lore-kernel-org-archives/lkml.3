Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751415AbaKGO6U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 09:58:20 -0500
Received: from smtp.citrix.com ([66.165.176.89]:11044 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141AbaKGO6T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 09:58:19 -0500
X-IronPort-AV: E=Sophos;i="5.07,332,1413244800"; 
   d="scan'208";a="189152120"
Message-ID: <545CDDF6.9080902@citrix.com>
Date: Fri, 7 Nov 2014 14:57:58 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Juergen Gross <jgross@suse.com>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xensource.com>, <konrad.wilk@oracle.com>,
        <david.vrabel@citrix.com>, <boris.ostrovsky@oracle.com>,
        <x86@kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <hpa@zytor.com>
Subject: Re: [Xen-devel] [PATCH V2 1/5] Xen: Delay remapping memory of pv-domain
References: <1415252853-7106-1-git-send-email-jgross@suse.com> <1415252853-7106-2-git-send-email-jgross@suse.com>
In-Reply-To: <1415252853-7106-2-git-send-email-jgross@suse.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/14 05:47, Juergen Gross wrote:
> Early in the boot process the memory layout of a pv-domain is changed
> to match the E820 map (either the host one for Dom0 or the Xen one)
> regarding placement of RAM and PCI holes. This requires removing memory
> pages initially located at positions not suitable for RAM and adding
> them later at higher addresses where no restrictions apply.
> 
> To be able to operate on the hypervisor supported p2m list until a
> virtual mapped linear p2m list can be constructed, remapping must
> be delayed until virtual memory management is initialized, as the
> initial p2m list can't be extended unlimited at physical memory
> initialization time due to it's fixed structure.
> 
> A further advantage is the reduction in complexity and code volume as
> we don't have to be careful regarding memory restrictions during p2m
> updates.

Reviewed-by: David Vrabel <david.vrabel@citrix.com>

But I would like a second reviewed-by.

David

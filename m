Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100AbaKCLBz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 06:01:55 -0500
Received: from smtp.citrix.com ([66.165.176.89]:8439 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753077AbaKCLBv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 06:01:51 -0500
X-IronPort-AV: E=Sophos;i="5.07,307,1413244800"; 
   d="scan'208";a="187467322"
Message-ID: <5457609D.2000200@citrix.com>
Date: Mon, 3 Nov 2014 11:01:49 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: <xen-devel@lists.xensource.com>, <Ian.Campbell@citrix.com>,
        <linux-kernel@vger.kernel.org>, <david.vrabel@citrix.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [Xen-devel] [PATCH v7 7/8] xen/arm/arm64: introduce xen_arch_need_swiotlb
References: <alpine.DEB.2.02.1410261621200.22875@kaball.uk.xensource.com>	<1414422568-19103-7-git-send-email-stefano.stabellini@eu.citrix.com> <alpine.DEB.2.02.1411031044480.22875@kaball.uk.xensource.com>
In-Reply-To: <alpine.DEB.2.02.1411031044480.22875@kaball.uk.xensource.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/14 10:45, Stefano Stabellini wrote:
> On Mon, 27 Oct 2014, Stefano Stabellini wrote:
>> Introduce an arch specific function to find out whether a particular dma
>> mapping operation needs to bounce on the swiotlb buffer.
>>
>> On ARM and ARM64, if the page involved is a foreign page and the device
>> is not coherent, we need to bounce because at unmap time we cannot
>> execute any required cache maintenance operations (we don't know how to
>> find the pfn from the mfn).
>>
>> No change of behaviour for x86.
>>
>> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
>> Acked-by: Ian Campbell <ian.campbell@citrix.com>
> 
> Konrad, David, are you OK with the swiotlb-xen changes?

Reviewed-by: David Vrabel <david.vrabel@citrix.com>

But swiotlb is Konrad's responsibility.

David

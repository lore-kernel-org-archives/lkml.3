Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924AbaJ0LCT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 07:02:19 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:30813 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbaJ0LCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 07:02:18 -0400
X-IronPort-AV: E=Sophos;i="5.04,795,1406592000"; 
   d="scan'208";a="186427766"
Message-ID: <544E2637.8000902@citrix.com>
Date: Mon, 27 Oct 2014 11:02:15 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Ian Campbell <Ian.Campbell@citrix.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "david.vrabel@citrix.com" <david.vrabel@citrix.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Xen-devel] [PATCH v4 3/7] [RFC] arm/arm64: introduce is_dma_coherent
References: <1412941908-5850-3-git-send-email-stefano.stabellini@eu.citrix.com>	<20141010120702.GI7755@arm.com>	<alpine.DEB.2.02.1410101401250.17038@kaball.uk.xensource.com>	<alpine.DEB.2.02.1410131215400.17038@kaball.uk.xensource.com>	<20141013125725.GA19156@arm.com>	<alpine.DEB.2.02.1410131358490.17038@kaball.uk.xensource.com>	<alpine.DEB.2.02.1410221703560.876@kaball.uk.xensource.com>	<alpine.DEB.2.02.1410231516450.876@kaball.uk.xensource.com>	<20141024104746.GC1955@localhost>	<alpine.DEB.2.02.1410241233080.22875@kaball.uk.xensource.com>	<20141024154353.GE20534@e104818-lin.cambridge.arm.com>	<alpine.DEB.2.02.1410241751160.22875@kaball.uk.xensource.com>	<alpine.DEB.2.02.1410241828110.22875@kaball.uk.xensource.com>	<alpine.DEB.2.02.1410251424350.22875@kaball.uk.xensource.com>	<1414251629.3584.20.camel@citrix.com> <alpine.DEB.2.02.1410251714450.22875@kaball.uk.xensource.com>
In-Reply-To: <alpine.DEB.2.02.1410251714450.22875@kaball.uk.xensource.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/10/14 17:15, Stefano Stabellini wrote:
> On Sat, 25 Oct 2014, Ian Campbell wrote:
>> On Sat, 2014-10-25 at 14:29 +0100, Stefano Stabellini wrote:
>>>  
>>> Your suggestions and looking more at the code gave me another idea, that
>>> I think is clean and at the same time suitable for 3.18.
>>> What do you think of the following? It is simple, self-contained and
>>> doesn't need a new flag in struct device.
>>
>> of_dma_is_coherent looks to be quite expensive though (walks up the
>> Device Tree doing strcmps on each property of each node until it finds
>> the one it is looking for.
> 
> It takes spin_locks too!
> Too bad, I think I'll have to ditch it. In that case I'l try the new
> flag in struct device approach.

If you're having to make changes to struct device, this is looking like
a series for 3.19 (not 3.18).

David

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647Ab3LCRKz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 12:10:55 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:63677 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754061Ab3LCRKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 12:10:53 -0500
X-IronPort-AV: E=Sophos;i="4.93,819,1378857600"; 
   d="scan'208";a="77823826"
Message-ID: <529E109A.7050700@citrix.com>
Date: Tue, 3 Dec 2013 17:10:50 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Julien Grall <julien.grall@linaro.org>
CC: <xen-devel@lists.xenproject.org>, <patches@linaro.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Roger Pau Monne <roger.pau@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: Re: [PATCH v2] xen/block: Correctly define structures in public headers
 on ARM32 and ARM64
References: <1386085237-8334-1-git-send-email-julien.grall@linaro.org>
In-Reply-To: <1386085237-8334-1-git-send-email-julien.grall@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/13 15:40, Julien Grall wrote:
> On ARM (32 bits and 64 bits), the double-word is 8-bytes aligned. This will
> result on different structure from Xen and Linux repositories.
> 
> As Linux is using __packed__ attribute, it must have a 4-bytes padding before
> each "id" field.
> 
> This change breaks guest block support with older kernel. IMHO, it's acceptable
> because Xen on ARM is still on Tech Preview and the hypercall ABI is not yet
> freezed.
> 
> Only one architecture (x86_32) doesn't have 64-bit ABI for the block interface.
> Don't add padding if Linux is compiled for this architecture.

I'm now satisfied that this is the right thing to do.

Acked-by: David Vrabel <david.vrabel@citrix.com>

David

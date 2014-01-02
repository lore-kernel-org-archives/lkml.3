Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751762AbaABOyu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 09:54:50 -0500
Received: from smtp.citrix.com ([66.165.176.89]:14068 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751136AbaABOyt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 09:54:49 -0500
X-IronPort-AV: E=Sophos;i="4.95,591,1384300800"; 
   d="scan'208";a="89239041"
Message-ID: <52C57D9A.8050804@citrix.com>
Date: Thu, 2 Jan 2014 14:54:18 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>,
        <annie.li@oracle.com>, <msw@amazon.com>
Subject: Re: [Xen-devel] [PATCH] xen/grant-table: Force to use v1 of grants.
References: <1388502919-8601-1-git-send-email-konrad.wilk@oracle.com> <1388502919-8601-2-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1388502919-8601-2-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/12/13 15:15, Konrad Rzeszutek Wilk wrote:
> We have the framework to use v2, but there are no backends that
> actually use it. The end result is that on PV we use v2 grants
> and on PVHVM v1. The v1 has a capacity of 512 grants per page while
> the v2 has 256 grants per page. This means we lose about 50%
> capacity - and if we want more than 16 VIFs (each VIF takes
> 512 grants), then we are hitting the max per guest of 32.
> 
> Oracle-bug: 16039922
> CC: annie.li@oracle.com
> CC: msw@amazon.com
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Reviewed-by: David Vrabel <david.vrabel@citrix.com>

What does v2 add anyway? Do we want to remove all v2 related code or are
we expecting to make use of it in the near future?

David

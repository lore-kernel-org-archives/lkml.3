Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751621AbaAXRUb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 12:20:31 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:26191 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbaAXRU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 12:20:29 -0500
X-IronPort-AV: E=Sophos;i="4.95,713,1384300800"; 
   d="scan'208";a="94221208"
Message-ID: <52E2A0C6.4030801@citrix.com>
Date: Fri, 24 Jan 2014 17:20:06 +0000
From: Zoltan Kiss <zoltan.kiss@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Matt Wilson <msw@linux.com>
CC: <ian.campbell@citrix.com>, <wei.liu2@citrix.com>,
        <xen-devel@lists.xenproject.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <jonathan.davies@citrix.com>,
        Anthony Liguori <aliguori@amazon.com>, Matt Wilson <msw@amazon.com>
Subject: Re: [PATCH v6] xen/grant-table: Avoid m2p_override during mapping
References: <1390512224-27296-1-git-send-email-zoltan.kiss@citrix.com> <20140124054828.GA18522@u109add4315675089e695.ant.amazon.com>
In-Reply-To: <20140124054828.GA18522@u109add4315675089e695.ant.amazon.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.133]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/01/14 05:48, Matt Wilson wrote:
> On Thu, Jan 23, 2014 at 09:23:44PM +0000, Zoltan Kiss wrote:
> Apologies for coming in late on this thread. I'm quite behind on
> xen-devel mail that isn't CC: to me.
>
> It seems to have been forgotten that Anthony and I proposed a similar
> change last November.
>
> https://lkml.kernel.org/r/1384307336-5328-1-git-send-email-anthony@codemonkey.ws
>
> Or am I misunderstanding the change?

I didn't know about this patch, but yes, both of them do basically the 
same. One subtle difference that you store the old mfn in page->private, 
while my patch keeps the original behaviour, and store it in 
page->index. page->private is used instead to store the new mfn we got 
from Xen, however I haven't checked where do we use that.
Your approach might be better, we also talked with David that we should 
stop using page->index, as e.g. with the netback grant mapping patches I 
spent a lot of time to figure out a packet drop issue, which eventually 
boiled down to the fact that index is in union with pfmemalloc, and if 
you don't set mapping, the local IP stack will think it is a pfmemalloc 
page. (see the comment in my second patch, xenvif_fill_frags)
However I think that should be a separate patch, I tried to keep the 
original behaviour as much as possible, and focus just on avoiding 
m2p_override when possible.

Regards,

Zoli

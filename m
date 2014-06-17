Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932094AbaFQB3h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 21:29:37 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:62821 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954AbaFQB3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 21:29:35 -0400
X-Original-SENDERIP: 10.177.220.145
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Tue, 17 Jun 2014 10:33:50 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Alexander Graf <agraf@suse.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: Re: [PATCH v3 -next 1/9] DMA, CMA: fix possible memory leak
Message-ID: <20140617013349.GB6825@js1304-P5Q-DELUXE>
References: <1402897251-23639-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1402897251-23639-2-git-send-email-iamjoonsoo.kim@lge.com>
 <20140616062719.GA18790@bbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140616062719.GA18790@bbox>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2014 at 03:27:19PM +0900, Minchan Kim wrote:
> Hi, Joonsoo
> 
> On Mon, Jun 16, 2014 at 02:40:43PM +0900, Joonsoo Kim wrote:
> > We should free memory for bitmap when we find zone mis-match,
> > otherwise this memory will leak.
> > 
> > Additionally, I copy code comment from PPC KVM's CMA code to inform
> > why we need to check zone mis-match.
> > 
> > * Note
> > Minchan suggested to add a tag for the stable, but, I don't do it,
> > because I found this possibility during code-review and, IMO,
> > this patch isn't suitable for stable tree.
> 
> Nice idea to put the comment in here. Thanks Joonsoo.
> 
> It seems you obey "It must fix a real bug that bothers people"
> on Documentation/stable_kernel_rules.txt but it's a really obvious
> bug and hard to get a report from people because limited user and
> hard to detect small such small memory leak.
> 
> In my experince, Andrew perfered stable marking for such a obvious
> problem but simple fix like this but not sure so let's pass the decision
> to him and will learn a lesson from him and will follow the decision
> from now on.

Yes, I intended to pass the decision to others. :)

> 
> Thanks.
> 
> Acked-by: Minchan Kim <minchan@kernel.org>

Thanks.

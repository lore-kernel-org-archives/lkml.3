Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872AbaCYSao (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 14:30:44 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:27865 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753434AbaCYSan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 14:30:43 -0400
X-IronPort-AV: E=Sophos;i="4.97,730,1389744000"; 
   d="scan'208";a="113474072"
Message-ID: <5331CB50.9000306@citrix.com>
Date: Tue, 25 Mar 2014 18:30:40 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <mgorman@suse.de>, <akpm@linux-foundation.org>, <steven@uplinklabs.net>,
        <boris.ostrovsky@oracle.com>, David Sutton <kantras@gmail.com>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 1/2] Revert "xen: properly account for _PAGE_NUMA
 during xen pte translations"
References: <CAPCj91+c8kE8dgp7U3N1ti=XOzFrgcg3Z3S9dYK4AG1tEMqsaA@mail.gmail.com> <5331B94F.9020601@citrix.com> <20140325181939.GA11073@phenom.dumpdata.com>
In-Reply-To: <20140325181939.GA11073@phenom.dumpdata.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/03/14 18:19, Konrad Rzeszutek Wilk wrote:
> 
> With that in mind I was wondering whether it would be possible to revert 
> Mel's 1667918b6483 ("mm: numa: clear numa hinting information on mprotect")
> so there is a bit more time in 3.15 to re-introduce his patch and also a
> proper fix so that Xen guests won't fall flat on their face?

Unfortunately, I think this can only be safely reverted on architectures
with ARCH_WANTS_PROT_NUMA_PROT_NONE (x86) and would cause regressions on
other architectures with only ARCH_SUPPORTS_NUMA_BALANCING (powerpc).

David

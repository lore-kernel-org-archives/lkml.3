Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753613AbaAIPmv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 10:42:51 -0500
Received: from smtp.citrix.com ([66.165.176.89]:46791 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752862AbaAIPmo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 10:42:44 -0500
X-IronPort-AV: E=Sophos;i="4.95,631,1384300800"; 
   d="scan'208";a="91322742"
Message-ID: <52CEC370.10503@citrix.com>
Date: Thu, 9 Jan 2014 15:42:40 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Wei Liu <wei.liu2@citrix.com>
CC: Zoltan Kiss <zoltan.kiss@citrix.com>, <ian.campbell@citrix.com>,
        <xen-devel@lists.xenproject.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <jonathan.davies@citrix.com>,
        =?ISO-8859-1?Q?Roger_Pau_Monn=E9?= <roger.pau@citrix.com>
Subject: Re: [PATCH net-next v3 1/9] xen-netback: Introduce TX grant map definitions
References: <1389139818-24458-1-git-send-email-zoltan.kiss@citrix.com> <1389139818-24458-2-git-send-email-zoltan.kiss@citrix.com> <20140109153010.GE12164@zion.uk.xensource.com>
In-Reply-To: <20140109153010.GE12164@zion.uk.xensource.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/14 15:30, Wei Liu wrote:
> On Wed, Jan 08, 2014 at 12:10:10AM +0000, Zoltan Kiss wrote:
>> This patch contains the new definitions necessary for grant mapping.
>>
>> v2:
>> - move unmapping to separate thread. The NAPI instance has to be scheduled
>>   even from thread context, which can cause huge delays
>> - that causes unfortunately bigger struct xenvif
>> - store grant handle after checking validity
>>
>> v3:
>> - fix comment in xenvif_tx_dealloc_action()
>> - call unmap hypercall directly instead of gnttab_unmap_refs(), which does
>>   unnecessary m2p_override. Also remove pages_to_[un]map members
> 
> Is it worthy to have another function call
> gnttab_unmap_refs_no_m2p_override in Xen core driver, or just add a
> parameter to control wether we need to touch m2p_override? I *think* it
> will benefit block driver as well?

add_m2p_override and remove_m2p_override calls should be moved into the
gntdev device as that should be the only user.

David

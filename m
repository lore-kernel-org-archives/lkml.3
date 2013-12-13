Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752965Ab3LMPoj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 10:44:39 -0500
Received: from smtp.citrix.com ([66.165.176.89]:18854 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752428Ab3LMPoh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 10:44:37 -0500
X-IronPort-AV: E=Sophos;i="4.95,479,1384300800"; 
   d="scan'208";a="84323725"
Date: Fri, 13 Dec 2013 15:44:35 +0000
From: Wei Liu <wei.liu2@citrix.com>
To: Zoltan Kiss <zoltan.kiss@citrix.com>
CC: <ian.campbell@citrix.com>, <wei.liu2@citrix.com>,
        <xen-devel@lists.xenproject.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <jonathan.davies@citrix.com>
Subject: Re: [PATCH net-next v2 9/9] xen-netback: Aggregate TX unmap
 operations
Message-ID: <20131213154435.GP21900@zion.uk.xensource.com>
References: <1386892097-15502-1-git-send-email-zoltan.kiss@citrix.com>
 <1386892097-15502-10-git-send-email-zoltan.kiss@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1386892097-15502-10-git-send-email-zoltan.kiss@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 12, 2013 at 11:48:17PM +0000, Zoltan Kiss wrote:
> Unmapping causes TLB flushing, therefore we should make it in the largest
> possible batches. However we shouldn't starve the guest for too long. So if
> the guest has space for at least two big packets and we don't have at least a
> quarter ring to unmap, delay it for at most 1 milisec.
> 

Is this solution temporary or permanent? If it is permanent would it
make sense to make these parameter tunable?

Wei.

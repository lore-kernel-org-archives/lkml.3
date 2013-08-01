Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754457Ab3HAKMm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 06:12:42 -0400
Received: from smtp.citrix.com ([66.165.176.89]:2386 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752459Ab3HAKMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 06:12:40 -0400
X-IronPort-AV: E=Sophos;i="4.89,793,1367971200"; 
   d="scan'208";a="40707909"
Message-ID: <51FA3496.6020803@citrix.com>
Date: Thu, 1 Aug 2013 11:12:38 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Roger Pau Monne <roger.pau@citrix.com>
CC: <xen-devel@lists.xen.org>, <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH 1/3] xen-gnt: prevent adding duplicate gnt callbacks
References: <1375282844-4314-1-git-send-email-roger.pau@citrix.com> <1375282844-4314-2-git-send-email-roger.pau@citrix.com>
In-Reply-To: <1375282844-4314-2-git-send-email-roger.pau@citrix.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/07/13 16:00, Roger Pau Monne wrote:
> With the current implementation, the callback in the tail of the list
> can be added twice, because the check done in
> gnttab_request_free_callback is bogus, callback->next can be NULL if
> it is the last callback in the list. If we add the same callback twice
> we end up with an infinite loop, were callback == callback->next.
> 
> Replace this check with a proper one that iterates over the list to
> see if the callback has already been added.

As a minimal fix suitable for stable,

Reviewed-by: David Vrabel <david.vrabel@citrix.com>

David

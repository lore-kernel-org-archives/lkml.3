Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074Ab3KFILi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 03:11:38 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:40019 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803Ab3KFILh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 03:11:37 -0500
Message-ID: <5279F9AE.303@ti.com>
Date: Wed, 6 Nov 2013 13:41:26 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        Tomasz Figa <t.figa@samsung.com>, Felipe Balbi <balbi@ti.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [patch] drivers: phy: tweaks to phy_create()
References: <20131106075412.GB13475@elgon.mountain>
In-Reply-To: <20131106075412.GB13475@elgon.mountain>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wednesday 06 November 2013 01:24 PM, Dan Carpenter wrote:
> If this was called with a NULL "dev" then it lead to a NULL dereference
> when we called dev_WARN().  I have changed it to WARN_ON() so that we
> get a stack dump and can fix the caller.
>
> If ida_simple_get() failed then there was a missing call to kfree(phy).

There was already a patch fixing it.
git://git.kernel.org/pub/scm/linux/kernel/git/kishon/linux-phy.git fixes
>
> The rest of this patch is just cleanup like returning directly instead
> of having do-nothing gotos.  Using descriptive labels instead of

Grouping the err returns in the end looked a bit cleaner to me. It's 
just a matter of preference I guess.
> GW-BASIC style "err0" and "err1".  I also flipped the order of
> put_device() and ida_remove() so they are a mirror reflection of the
> order they were allocated.
>

Thanks
Kishon

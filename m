Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281Ab3LMCiU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 21:38:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14809 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751805Ab3LMCiT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 21:38:19 -0500
Date: Fri, 13 Dec 2013 10:38:14 +0800
From: Dave Young <dyoung@redhat.com>
To: akpm@linux-foundation.org, rob@landley.net, gregkh@linuxfoundation.org,
        grant.likely@secretlab.ca, sebastian.capella@linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] use initmpfs even if there's root= cmdline
Message-ID: <20131213023814.GA5519@dhcp-16-126.nay.redhat.com>
References: <20131212092542.GA14218@dhcp-16-126.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131212092542.GA14218@dhcp-16-126.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/13 at 05:25pm, Dave Young wrote:
> 
> Current code use ramfs instead of tmpfs for stub when root= defined.
> 
> But for real use case with initramfs, usually there's like cmdline like
> root=UUID=$UUID the root dev is the real device. For that case we have
> no way to use initmpfs, thus this patch removes the limitation so tmpfs
> can benefit more people.
> 
> The logic become:
> if CONFIG_TMPFS && rootfstype is not ramfs
>     use tmpfs
> else
>     use ramfs
> 

Discussed with Vivek Goyal about the kdump use case, I missed one thing that
tmpfs has default size limit though we can tune it.

So I will think more about it, will address this later, please ignore this
patch.

Thanks
Dave

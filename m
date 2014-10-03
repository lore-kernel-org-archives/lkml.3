Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521AbaJCTAw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 15:00:52 -0400
Received: from b.a.painless.aa.net.uk ([81.187.30.65]:49430 "EHLO
	b.a.painless.aa.net.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbaJCTAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 15:00:49 -0400
X-Greylist: delayed 3563 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 Oct 2014 15:00:49 EDT
Message-ID: <542EE470.9050700@spamcop.net>
Date: Fri, 03 Oct 2014 19:01:20 +0100
From: Bronek Kozicki <brok@spamcop.net>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm: Test for PCI root bus to avoid NULL pointer dereference
References: <20140827185651.29388.16082.stgit@gimli.home>
In-Reply-To: <20140827185651.29388.16082.stgit@gimli.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/08/2014 19:57, Alex Williamson wrote:
> If we have a GPU on the PCI root bus that calls
> drm_pcie_get_speed_cap_mask() we end up with a NULL pointer
> dereference since pdev->bus->self is NULL.  We already protect
> against callers passing non-PCI devices, so let's also catch this
> case and return -EINVAL.
>
> Root complex graphics are not terribly likely outside of IGD, but
> when we assign a standard plugin GPU to a virtual machine, our
> assumption that we have a parent device quickly becomes invalid.


What happend to this patch? I don't see it applied on 
https://github.com/torvalds/linux/tree/master/drivers/gpu/drm


B.



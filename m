Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965551AbaH1JiO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 05:38:14 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:65380 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932685AbaH1JiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 05:38:13 -0400
Date: Thu, 28 Aug 2014 10:38:26 +0100
From: Will Deacon <will.deacon@arm.com>
To: "byungchul.park@lge.com" <byungchul.park@lge.com>
Cc: Sudeep Holla <Sudeep.Holla@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] Revert "arm64: use cpu_online_mask when using forced
 irq_set_affinity"
Message-ID: <20140828093826.GC22580@arm.com>
References: <1409131806-11276-1-git-send-email-byungchul.park@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409131806-11276-1-git-send-email-byungchul.park@lge.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2014 at 10:30:06AM +0100, byungchul.park@lge.com wrote:
> From: Byungchul Park <byungchul.park@lge.com>
> 
> This reverts commit 601c942176d8ad8334118bddb747e3720bed24f8.
> 
> This patch is designed to ensure that the cpu being offlined is not
> present in the affinity mask. But it is a bad idea to overwrite the
> affinity variable with cpu_online_mask, even in case that the current
> affinity already includes onlined cpus.
> 
> So revert this patch to replace it with another one doing exactly
> what it intends.

Sudeep: what's the right way forward for this? There seems to be general
agreement that the existing code is broken, but a bunch of different
`fixes'. Can we just take a straight port of what tglx proposed for ARM?
(changing force to false)

Will

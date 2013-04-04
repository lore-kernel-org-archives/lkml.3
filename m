Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761475Ab3DDOLg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 10:11:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28793 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761305Ab3DDOLf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 10:11:35 -0400
Date: Thu, 4 Apr 2013 10:11:16 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, WANG Chao <chaowang@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/4] x86, kdump: Set crashkernel_low automatically
Message-ID: <20130404141116.GC16459@redhat.com>
References: <1365035906-3208-1-git-send-email-yinghai@kernel.org>
 <1365035906-3208-2-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365035906-3208-2-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 03, 2013 at 05:38:23PM -0700, Yinghai Lu wrote:

[..]
> +	if (ret != 0) {
> +		/*
> +		 * two parts from lib/swiotlb.c:
> +		 *	swiotlb size: user specified with swiotlb= or default.
> +		 *	swiotlb overflow buffer: now is hardcoded to 32k,
> +		 *		round to 8M to cover more others.
> +		 */
> +		low_size = swiotlb_size_or_default() + (8UL<<20);
> +		auto_set = true;

What is the correlation between swiotlb size of first kernel and second
kernel. They might be completely different kernel and with different
default size for swiotlb buffers.

[..]
>  
> +	crashkernel_low=size[KMG]
> +			[KNL, x86_64] range under 4G. When crashkernel= is
> +			passed, kernel allocate physical memory region
> +			above 4G,
	
This is not right. "When crashkernel=X;high is passed kernel first tries
to allocate memory above 4G". crashkernel=X does not try to allocate 
memory above 4G.

Vivek

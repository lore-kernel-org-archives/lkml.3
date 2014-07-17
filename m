Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934202AbaGQPtS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 11:49:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55421 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756821AbaGQPtR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 11:49:17 -0400
Message-ID: <53C7F063.7030007@zytor.com>
Date: Thu, 17 Jul 2014 08:48:51 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Sasha Levin <sasha.levin@oracle.com>
CC: tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86-64, espfix: consider IRQs are off when initializing
References: <1405610015-27464-1-git-send-email-sasha.levin@oracle.com>
In-Reply-To: <1405610015-27464-1-git-send-email-sasha.levin@oracle.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2014 08:13 AM, Sasha Levin wrote:
> When going through our initialization code (init_espfix_ap() ) we need to
> keep in mind IRQs are off, and we need to handle it appropriately:
> 
>  - Do not allocate with __GFP_FS.
>  - No point in using a mutex.
> 
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>

I don't think this is safe.  The whole point was that if we do
GFP_ATOMIC we have to accept failure, and if we have a spin lock then
sleeping is not permitted.  It is unclear to me is sleeping is safe in
this context even so, so we may still have a problem, but calling
__get_free_page(GFP_ATOMIC) and then unconditionally use the results is
not right.

	-hpa


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965336AbaGQQQ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 12:16:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55712 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934286AbaGQQQ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 12:16:27 -0400
Message-ID: <53C7F6CB.4070606@zytor.com>
Date: Thu, 17 Jul 2014 09:16:11 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Sasha Levin <sasha.levin@oracle.com>
CC: tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86-64, espfix: consider IRQs are off when initializing
References: <1405610015-27464-1-git-send-email-sasha.levin@oracle.com> <53C7F063.7030007@zytor.com> <53C7F2B2.2000803@oracle.com>
In-Reply-To: <53C7F2B2.2000803@oracle.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2014 08:58 AM, Sasha Levin wrote:
> 
> This is the result of getting an error message for allocating with GFP_KERNEL
> saying that we can't do that with IRQs off.
> 
> My assumption after that was that we're not going to be sleeping at all, which
> is why spinlock/GFP_ATOMIC would be correct here.
> 

So we have a problem, but the proposed solution is wrong.  This is
messy... we need this code to be successfully executed before we can
safely schedule *user space* on that processor, but there is no
requirement that we execute it before we enable *interrupts* on that
processor, so maybe there is a way we can fulfill those requirements.

The alternative would be to fail to enable the processor or going into a
spin loop, but either of those would been rather toxic to me.

	-hpa


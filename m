Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758704Ab3EBPMX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 11:12:23 -0400
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:5661 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753409Ab3EBPMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 11:12:22 -0400
Date: Thu, 2 May 2013 15:12:21 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Pekka Enberg <penberg@kernel.org>
cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, glommer@parallels.com,
        linux-kernel@vger.kernel.org
Subject: Re: [linux-next-20130422] Bug in SLAB?
In-Reply-To: <5180CCC0.8070703@kernel.org>
Message-ID: <0000013e65cd1cf9-c331a323-ad53-45e0-bd3f-367456456777-000000@email.amazonses.com>
References: <0000013e564e0e5a-121c52f9-e489-470f-99d5-67a5ad42eb75-000000@email.amazonses.com> <201304300028.IAD13051.OHOVMJSLFFFQOt@I-love.SAKURA.ne.jp> <0000013e56e9304a-1042a95a-d4dd-43c5-8b8a-c670f50ac54e-000000@email.amazonses.com>
 <201304300645.FCE37285.tVHJLSOMQFOFFO@I-love.SAKURA.ne.jp> <0000013e5b56d067-7982dfa6-08a2-4c48-ad77-6888b5114c5f-000000@email.amazonses.com> <201305010101.CGB86424.JFQOtSFOVOLFHM@I-love.SAKURA.ne.jp> <0000013e5bfc7c4d-54fa9464-dccd-4157-b4a5-22594261eaf3-000000@email.amazonses.com>
 <5180CCC0.8070703@kernel.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 May 2013, Pekka Enberg wrote:

> > This behavior has been in there for years. Why try a kmalloc that
> > always fails since the size is too big?
>
> ...because want the extra protection for cases where size is controlled by
> userspace. This is consistent with kcalloc() that returns NULL on integer
> overflow.

The slab allocator behavior since SLUB was introduced has been to BUG() on
allocations that can never be satisfied.


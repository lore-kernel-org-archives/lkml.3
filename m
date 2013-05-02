Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758945Ab3EBPN5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 11:13:57 -0400
Received: from a9-42.smtp-out.amazonses.com ([54.240.9.42]:38745 "EHLO
	a9-42.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757955Ab3EBPN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 11:13:56 -0400
Date: Thu, 2 May 2013 15:13:54 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Pekka Enberg <penberg@kernel.org>
cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, glommer@parallels.com,
        linux-kernel@vger.kernel.org
Subject: Re: [linux-next-20130422] Bug in SLAB?
In-Reply-To: <5180CC5B.3010608@kernel.org>
Message-ID: <0000013e65ce8a9b-230978fb-2865-4b36-9575-3e1dddba6858-000000@email.amazonses.com>
References: <CAOJsxLFYDC+EDdJrXVnc1qfEyd56bhFLeGE+6Mbhwiq73KQQLQ@mail.gmail.com> <517E8758.9040803@parallels.com> <0000013e564e0e5a-121c52f9-e489-470f-99d5-67a5ad42eb75-000000@email.amazonses.com> <201304300028.IAD13051.OHOVMJSLFFFQOt@I-love.SAKURA.ne.jp>
 <0000013e56e9304a-1042a95a-d4dd-43c5-8b8a-c670f50ac54e-000000@email.amazonses.com> <201304300645.FCE37285.tVHJLSOMQFOFFO@I-love.SAKURA.ne.jp> <0000013e5b5de8c2-75b84016-0faf-4b7f-b5e5-e40eb67552ab-000000@email.amazonses.com> <5180CC5B.3010608@kernel.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.05.02-54.240.9.42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 May 2013, Pekka Enberg wrote:

	> Why is that? Historically it has returned NULL, hasn't it? We have had cases
> where kernel code (naively) uses size directly from userspace and we
> definitely don't want to BUG_ON on it.

In that case the size is dynamic and then we return an error. In this case
the size is static and known at compile time. The allocation can never
succeed.

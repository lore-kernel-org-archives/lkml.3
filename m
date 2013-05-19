Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576Ab3ESRDC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 13:03:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46957 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751950Ab3ESRDA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 13:03:00 -0400
Message-ID: <519905B6.3080101@redhat.com>
Date: Sun, 19 May 2013 19:02:46 +0200
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: David Miller <davem@davemloft.net>, netdev <netdev@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] x86: bpf_jit_comp: secure bpf jit against spraying
 attacks
References: <1368844623.3301.142.camel@edumazet-glaptop>
In-Reply-To: <1368844623.3301.142.camel@edumazet-glaptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/18/2013 04:37 AM, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
>
> hpa bringed into my attention some security related issues
> with BPF JIT on x86.
>
> This patch makes sure the bpf generated code is marked read only,
> as other kernel text sections.
>
> It also splits the unused space (we vmalloc() and only use a fraction of
> the page) in two parts, so that the generated bpf code not starts at a
> known offset in the page, but a pseudo random one.
>
> Refs:
> http://mainisusuallyafunction.blogspot.com/2012/11/attacking-hardened-linux-systems-with.html
>
> Reported-by: H. Peter Anvin <hpa@zytor.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Great work !

Probably other archs could later on follow-up with setting to read-only, too.

Reviewed-by: Daniel Borkmann <dborkman@redhat.com>

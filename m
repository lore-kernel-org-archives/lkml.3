Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349Ab3KYXxw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 18:53:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36448 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752098Ab3KYXxu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 18:53:50 -0500
Message-ID: <5293E2D0.4070206@redhat.com>
Date: Tue, 26 Nov 2013 00:52:48 +0100
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Cesar Eduardo Barros <cesarb@cesarb.eti.br>
CC: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        James Yonan <james@openvpn.net>, Florian Weimer <fw@deneb.enyo.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] crypto: more robust crypto_memneq
References: <1385418918-15901-1-git-send-email-cesarb@cesarb.eti.br>
In-Reply-To: <1385418918-15901-1-git-send-email-cesarb@cesarb.eti.br>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2013 11:35 PM, Cesar Eduardo Barros wrote:
> Disabling compiler optimizations can be fragile, since a new
> optimization could be added to -O0 or -Os that breaks the assumptions
> the code is making.
>
> Instead of disabling compiler optimizations, use a dummy inline assembly
> (based on RELOC_HIDE) to block the problematic kinds of optimization,
> while still allowing other optimizations to be applied to the code.
>
> The dummy inline assembly is added after every OR, and has the
> accumulator variable as its input and output. The compiler is forced to
> assume that the dummy inline assembly could both depend on the
> accumulator variable and change the accumulator variable, so it is
> forced to compute the value correctly before the inline assembly, and
> cannot assume anything about its value after the inline assembly.
>
> This change should be enough to make crypto_memneq work correctly (with
> data-independent timing) even if it is inlined at its call sites. That
> can be done later in a followup patch.
>
> Compile-tested on x86_64.
>
> Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.eti.br>

Acked-by: Daniel Borkmann <dborkman@redhat.com>

Looks good, thanks!

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678Ab3ILUiT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 16:38:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39851 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754243Ab3ILUiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 16:38:16 -0400
Message-ID: <52322621.3040908@zytor.com>
Date: Thu, 12 Sep 2013 13:37:53 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Torsten Duwe <duwe@lst.de>
CC: tytso@mit.edu, ingo.tuchscherer@de.ibm.com, linux-kernel@vger.kernel.org,
        Hans-Georg Markgraf <MGRF@de.ibm.com>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Joe Perches <joe@perches.com>
Subject: Re: [Resend PATCH 2/2] s390: provide hardware randomness from zcrypt
 card to /dev/random
References: <alpine.LNX.2.00.1309121139000.3818@linux.site>
In-Reply-To: <alpine.LNX.2.00.1309121139000.3818@linux.site>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2013 02:41 AM, Torsten Duwe wrote:
> 
> Running completely virtualised, system Z severely lacks good true random sources.
> Gathering entropy in a virtual environment is difficult. To compensate, there is
> specialised crypto hardware which includes a source for hardware randomness;
> the zcrypt driver is able to access this random source. This patch adds a kernel
> thread that feeds the random bits via the interface created with the previous patch.
> 
> Signed-off-by: Torsten Duwe <duwe@lst.de>

>From what I can gather from the patch this is too heavyweight (need
locks and so on) to use as arch_get_random*().  There has been a lot of
discussion about the pros and cons of allowing the kernel to bypass
rngd, but I would think that any such plumbing -- once it gets past the
fully synchronous low latency properties of arch_get_random*() -- really
should be implemented as an option in the existing hwrng device
infrastructure.

In other words, start by implementing a hwrng device.  That will work
right now with rngd running.  Then we can consider if we want to allow
bypass of rngd for certain hwrng devices -- which may include zcrypt,
virtio_rng and so on.

	-hpa



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751769Ab3KSOvf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 09:51:35 -0500
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:60653 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751071Ab3KSOve (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 09:51:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=message-id:date
	:from:mime-version:to:cc:subject:references:in-reply-to
	:content-type:content-transfer-encoding; q=dns; s=sasl; b=xXTQop
	qd87aA9CrlKOrUcV/BctiiryyWtPYHFCp0W4Y4vKZNFRMqqmitE8QcbIgusyGP5s
	g5urkZ8IFHqLptnRCeFj+1ym9lHtgceSzsrbVCCPj7emx4RE+CBmiOdA09xYmIrA
	cEFcWIKaYH4cE6nKMXslOXwKHMUPCCu6mXU/E=
Message-ID: <528B7AEF.7020805@pobox.com>
Date: Tue, 19 Nov 2013 23:51:27 +0900
From: Shinya Kuribayashi <skuribay@pobox.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: ralf@linux-mips.org, jbaron@akamai.com
CC: mingo@kernel.org, benh@kernel.crashing.org, paulus@samba.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mips@linux-mips.org, florian@openwrt.org, jchandra@broadcom.com,
        ganesanr@broadcom.com
Subject: Re: [PATCH v2] panic: Make panic_timeout configurable
References: <20131118210436.233B5202A@prod-mail-relay06.akamai.com> <20131119090211.GN10382@linux-mips.org>
In-Reply-To: <20131119090211.GN10382@linux-mips.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Pobox-Relay-ID: 14944822-512A-11E3-AA7F-D331802839F8-47602734!b-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/13 6:02 PM, Ralf Baechle wrote:> On Mon, Nov 18, 2013 at 09:04:36PM +0000, Jason Baron wrote:
> It's more complicated - MIPS was using the global default with five MIPS
> platforms overriding the default.
>
> I propose to kill these overrides for sanity unless somebody comes up
> with a good argument.  Patch below.
>
>    Ralf
>
> Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
>
>   arch/mips/ar7/setup.c           | 1 -
>   arch/mips/emma/markeins/setup.c | 3 ---
>   arch/mips/netlogic/xlp/setup.c  | 1 -
>   arch/mips/netlogic/xlr/setup.c  | 1 -
>   arch/mips/sibyte/swarm/setup.c  | 2 --
>   5 files changed, 8 deletions(-)
[...]
> diff --git a/arch/mips/emma/markeins/setup.c b/arch/mips/emma/markeins/setup.c
> index d710058..9100122 100644
> --- a/arch/mips/emma/markeins/setup.c
> +++ b/arch/mips/emma/markeins/setup.c
> @@ -111,9 +111,6 @@ void __init plat_mem_setup(void)
>   	iomem_resource.start = EMMA2RH_IO_BASE;
>   	iomem_resource.end = EMMA2RH_ROM_BASE - 1;
>
> -	/* Reboot on panic */
> -	panic_timeout = 180;
> -
>   	markeins_sio_setup();
>   }
>

IIRC we had set it to 180 seconds for some historical reasons, but
I'm afraid nobody can recall the reason why it's set so in 2013...
Anyway I was thinking it too long and reduced to a few seconds locally
when debugging, so there shouldn't be a problem with this change.

FWIW, for EMMA2RH portion:

Acked-by: Shinya Kuribayashi <skuribay@pobox.com>

Thank you always for your help, Ralf.

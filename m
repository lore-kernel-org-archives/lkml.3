Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053Ab3A3IkA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 03:40:00 -0500
Received: from mga12.intel.com ([143.182.124.36]:24021 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751303Ab3A3Ijy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 03:39:54 -0500
MIME-Version: 1.0
In-Reply-To: <783235259540e27e745f68316b1735e8d4ce9137.1359125652.git.dmitry.kasatkin@intel.com>
References: <783235259540e27e745f68316b1735e8d4ce9137.1359125652.git.dmitry.kasatkin@intel.com>
Date: Wed, 30 Jan 2013 10:39:52 +0200
Message-ID: <CALLzPKai_9SR2pBDe8fU1sGTf+fN=EDGGU1HKQ-LTdWuP0Ti5Q@mail.gmail.com>
Subject: Re: [PATCH 1/1] digsig: Fix memory leakage in digsig_verify_rsa()
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: James Morris <jmorris@namei.org>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 4:54 PM, Dmitry Kasatkin
<dmitry.kasatkin@intel.com> wrote:
> From: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
>
> digsig_verify_rsa() does not free kmalloc'ed buffer returned by
> mpi_get_buffer().
>
> Signed-off-by: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
> Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
> Cc: stable@vger.kernel.org
> ---
>  lib/digsig.c |    2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/lib/digsig.c b/lib/digsig.c
> index 8c0e629..dc2be7e 100644
> --- a/lib/digsig.c
> +++ b/lib/digsig.c
> @@ -162,6 +162,8 @@ static int digsig_verify_rsa(struct key *key,
>         memset(out1, 0, head);
>         memcpy(out1 + head, p, l);
>
> +       kfree(p);
> +
>         err = pkcs_1_v1_5_decode_emsa(out1, len, mblen, out2, &len);
>         if (err)
>                 goto err;
> --
> 1.7.10.4
>

James, can you please apply this patch.

- Dmitry

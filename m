Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596AbaCaSfi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 14:35:38 -0400
Received: from qmta01.emeryville.ca.mail.comcast.net ([76.96.30.16]:46515 "EHLO
	qmta01.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753074AbaCaSfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 14:35:37 -0400
Date: Mon, 31 Mar 2014 13:35:34 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@nuc
To: Mitchel Humpherys <mitchelh@codeaurora.org>
cc: Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Joe Perches <joe@perches.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm: convert some level-less printks to pr_*
In-Reply-To: <1395942859-11611-2-git-send-email-mitchelh@codeaurora.org>
Message-ID: <alpine.DEB.2.10.1403311334060.3313@nuc>
References: <1395942859-11611-1-git-send-email-mitchelh@codeaurora.org> <1395942859-11611-2-git-send-email-mitchelh@codeaurora.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Mar 2014, Mitchel Humpherys wrote:

> diff --git a/mm/slub.c b/mm/slub.c
> index 25f14ad8f8..9f109e6756 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -9,6 +9,8 @@
>   * (C) 2011 Linux Foundation, Christoph Lameter
>   */
>
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

This is implicitly used by some macros? If so then please define this
elsewhere. I do not see any use in slub.c of this one.


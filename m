Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756859AbaGNS7Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 14:59:24 -0400
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:58162 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756831AbaGNS7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 14:59:20 -0400
Message-ID: <1405364357.13661.15.camel@x220>
Subject: Re: [PATCH] title: no lookup_page for if statement
From: Paul Bolle <pebolle@tiscali.nl>
To: Nicholas Krause <xerofoify@gmail.com>
Cc: cmetcalf@tilera.com, hannes@cmpxchg.org, mhocko@suse.cz,
        akpm@linux-foundation.org, zlu@tilera.com,
        linux-kernel@vger.kernel.org
Date: Mon, 14 Jul 2014 20:59:17 +0200
In-Reply-To: <1405363782-6570-1-git-send-email-xerofoify@gmail.com>
References: <1405363782-6570-1-git-send-email-xerofoify@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Jul 2014 18:59:18.0230 (UTC) FILETIME=[B6C45F60:01CF9F95]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-07-14 at 14:49 -0400, Nicholas Krause wrote:
> This patch removes the if define statement for page_lookup in order
> to remove a fix me of this not being defined as of yet.
> 
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> ---
>  0001-title-no-lookup_page-for-if-statement.patch | 37 ++++++++++++++++++++++++
>  1 file changed, 37 insertions(+)
>  create mode 100644 0001-title-no-lookup_page-for-if-statement.patch
> 
> diff --git a/0001-title-no-lookup_page-for-if-statement.patch b/0001-title-no-lookup_page-for-if-statement.patch
> new file mode 100644
> index 0000000..f11c12e
> --- /dev/null
> +++ b/0001-title-no-lookup_page-for-if-statement.patch
> @@ -0,0 +1,37 @@
> +From 23c4afac6742d5df1d083ab6335a0a69f38c76b0 Mon Sep 17 00:00:00 2001
> +From: Nicholas Krause <xerofoify@gmail.com>
> +Date: Mon, 14 Jul 2014 14:39:02 -0400
> +Subject: [PATCH] title: no lookup_page for if statement
> +
> +This patch removes the if define statement for page_lookup in order
> +to remove a fix me of this not being defined as of yet.
> +
> +Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> +---
> + arch/tile/mm/fault.c | 3 ---
> + 1 file changed, 3 deletions(-)
> +
> +diff --git a/arch/tile/mm/fault.c b/arch/tile/mm/fault.c
> +index 6c05712..2297bf7 100644
> +--- a/arch/tile/mm/fault.c
> ++++ b/arch/tile/mm/fault.c
> +@@ -513,8 +513,6 @@ no_context:
> + 
> + 	bust_spinlocks(1);
> + 
> +-	/* FIXME: no lookup_address() yet */
> +-#ifdef SUPPORT_LOOKUP_ADDRESS

Nicholas, stop! Just stop.

> + 	if (fault_num == INT_ITLB_MISS) {
> + 		pte_t *pte = lookup_address(address);
> + 
> +@@ -523,7 +521,6 @@ no_context:
> + 			       " non-executable page - exploit attempt?"
> + 			       " (uid: %d)\n", current->uid);
> + 	}
> +-#endif
> + 	if (address < PAGE_SIZE)
> + 		pr_alert("Unable to handle kernel NULL pointer dereference\n");
> + 	else
> +-- 
> +1.9.1
> +

For those not yet familiar with this train wreck, please do
    git grep SUPPORT_LOOKUP_ADDRESS


Paul Bolle


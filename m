Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432AbaKEPOM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 10:14:12 -0500
Received: from mga09.intel.com ([134.134.136.24]:12351 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754004AbaKEPOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 10:14:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="484743898"
Message-ID: <1415200447.958.109.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 02/35] UBI: Fix stale pointers in ubi->lookuptbl
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Weinberger <richard@nod.at>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        tlinder@codeaurora.org
Date: Wed, 05 Nov 2014 17:14:07 +0200
In-Reply-To: <1414586758-9972-3-git-send-email-richard@nod.at>
References: <1414586758-9972-1-git-send-email-richard@nod.at>
	 <1414586758-9972-3-git-send-email-richard@nod.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-10-29 at 13:45 +0100, Richard Weinberger wrote:
> +			ubi->lookuptbl[e2->pnum] = NULL;
>  			kmem_cache_free(ubi_wl_entry_slab, e2);

Since these 2 must always go together, they really deserve a separate
helper function.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750AbaJCObo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 10:31:44 -0400
Received: from mga03.intel.com ([134.134.136.65]:8989 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752474AbaJCObm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 10:31:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,647,1406617200"; 
   d="scan'208";a="583050221"
Message-ID: <1412346676.3795.62.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 3/4] UBI: Fastmap: Care about the protection queue
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Weinberger <richard@nod.at>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Fri, 03 Oct 2014 17:31:16 +0300
In-Reply-To: <1412029248-22454-4-git-send-email-richard@nod.at>
References: <1412029248-22454-1-git-send-email-richard@nod.at>
	 <1412029248-22454-4-git-send-email-richard@nod.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-09-30 at 00:20 +0200, Richard Weinberger wrote:
> +
> +	for (i = 0; i < UBI_PROT_QUEUE_LEN; i++) {
> +		list_for_each_entry(wl_e, &ubi->pq[i], u.list) {
> +			fec = (struct ubi_fm_ec *)(fm_raw + fm_pos);

Similarly to my other posts, is it possible to not touch the WL-internal
things like 'ubi->pq[]' from fastmap.c? Can we come up with a function
at wl.c which fastmap.c could call instead?


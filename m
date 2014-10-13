Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778AbaJMNSG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 09:18:06 -0400
Received: from mga03.intel.com ([134.134.136.65]:6854 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753567AbaJMNSD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 09:18:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,710,1406617200"; 
   d="scan'208";a="588010225"
Message-ID: <1413206263.7906.18.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 3/4] UBI: Fastmap: Care about the protection queue
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Weinberger <richard@nod.at>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Mon, 13 Oct 2014 16:17:43 +0300
In-Reply-To: <542EF3BF.1070401@nod.at>
References: <1412029248-22454-1-git-send-email-richard@nod.at>
		 <1412029248-22454-4-git-send-email-richard@nod.at>
	 <1412346676.3795.62.camel@sauron.fi.intel.com> <542EF3BF.1070401@nod.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-10-03 at 21:06 +0200, Richard Weinberger wrote:
> Fastmap needs basically access to all internal state of UBI, which
> lives mostly
> within wl.c

Sounds like a very strong assertion, smells a bit fishy, need the
details.

> It needs to iterate over the used, free, erase, scrub RB-trees, the
> protection queue, etc. to
> collect the exact state of all PEBs.

When? In 'ubi_write_fastmap()' when forming the FM pool data structures?

I think you can just add a function like this to wl.c:

int ubi_wl_get_peb_info(int pnum, struct ubi_wl_peb_info *pebinfo)

Yoy will give it the PEB number you are interested in, it will return
you the information you need in 'pebinfo'. The information will contain
the EC, the state (used, free, etc).

If you need just the EC, then you do not even need the ubi_wl_peb_info
data structure.

Then you just iterate over all PEBs and fill the FM pool data
structures.

Would something like this work?

Artem.


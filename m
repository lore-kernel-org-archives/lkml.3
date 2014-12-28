Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896AbaL1QiG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 11:38:06 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:42140 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809AbaL1QiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 11:38:03 -0500
Date: Sun, 28 Dec 2014 17:30:58 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, Davidlohr Bueso <dbueso@suse.de>
Subject: Re: [PATCH 7/8] locking: Use [READ,ASSIGN]_ONCE() for non-scalar
 types
Message-ID: <20141228163058.GB12952@dyad.arnhem.chello.nl>
References: <1419757883-4423-1-git-send-email-dave@stgolabs.net>
 <1419757883-4423-8-git-send-email-dave@stgolabs.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419757883-4423-8-git-send-email-dave@stgolabs.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 28, 2014 at 01:11:22AM -0800, Davidlohr Bueso wrote:
> I guess everyone will eventually have to update, so lets
> do our part... and become the first users of ASSIGN_ONCE().

> -	ACCESS_ONCE(prev->next) = node;
> +	ASSIGN_ONCE(node, prev->next);

> -	struct mcs_spinlock *next = ACCESS_ONCE(node->next);
> +	struct mcs_spinlock *next = READ_ONCE(node->next);

That's disgusting and sad, doubly so because I was entirely unaware of that stuff.

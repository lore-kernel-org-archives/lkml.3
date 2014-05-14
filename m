Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546AbaENUIv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 16:08:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49167 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107AbaENUIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 16:08:50 -0400
Date: Wed, 14 May 2014 16:08:45 -0400 (EDT)
Message-Id: <20140514.160845.214090653562722244.davem@redhat.com>
To: joe@perches.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: Use a more standard macro for INET_ADDR_COOKIE
From: David Miller <davem@redhat.com>
In-Reply-To: <1400038207.24350.83.camel@joe-AO725>
References: <1400038207.24350.83.camel@joe-AO725>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Tue, 13 May 2014 20:30:07 -0700

> Missing a colon on definition use is a bit odd so
> change the macro for the 32 bit case to declare an
> __attribute__((unused)) and __deprecated variable.
> 
> The __deprecated attribute will cause gcc to emit
> an error if the variable is actually used.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

This is fine, applied, thanks Joe.

Perhaps it would have been nicer to make the macros be initializers,
so that it still would look like a proper variable declaration at
the use sites:

	const __addrpair var = INET_ADDR_COOKIE(x, y, z);

or something like that.

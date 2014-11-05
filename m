Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955AbaKEOh7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 09:37:59 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:44132 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754458AbaKEOh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 09:37:58 -0500
Date: Wed, 5 Nov 2014 14:37:54 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ying Xue <ying.xue@windriver.com>, linux-kernel@vger.kernel.org,
        jack@suse.cz
Subject: Re: [PATCH] acct: eliminate compile warning
Message-ID: <20141105143754.GR7996@ZenIV.linux.org.uk>
References: <1408586326-24579-1-git-send-email-ying.xue@windriver.com>
 <20140826162501.7c05fa936e79c07927681bad@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140826162501.7c05fa936e79c07927681bad@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2014 at 04:25:01PM -0700, Andrew Morton wrote:

> We could actually do
> 
> 	if (ACCT_VERSION == 3)
> 		...
> 
> in lots of places in acct.c.  The code would be less ugly and
> compilation coverage testing would improve.

... too much.  Finally got around to trying that; the problem is that
you can't do that in structure declarations.  acct_t is either struct
acct, or struct acct_v3, and while we could split fill_ac() into
v3 and v1/v2 versions, it still doesn't sort everything out.  So it
looks like that idea is no-go ;-/

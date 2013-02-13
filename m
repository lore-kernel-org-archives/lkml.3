Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759918Ab3BMTnv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 14:43:51 -0500
Received: from mail-da0-f47.google.com ([209.85.210.47]:40315 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753887Ab3BMTnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 14:43:49 -0500
Date: Wed, 13 Feb 2013 12:43:07 -0700
From: Jean Sacren <sakiwit@gmail.com>
To: James Hogan <james.hogan@imgtec.com>
Cc: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH -next 1/1] net: skbuff: fix compile error in skb_panic()
Message-ID: <20130213194307.GE13159@mail.gmail.com>
References: <1360754427-9051-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360754427-9051-1-git-send-email-james.hogan@imgtec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: James Hogan <james.hogan@imgtec.com>
Date: Wed, 13 Feb 2013 11:20:27 +0000
>
> I get the following build error on next-20130213 due to the following
> commit:
> 
> commit f05de73bf82fbbc00265c06d12efb7273f7dc54a ("skbuff: create
> skb_panic() function and its wrappers").
> 
> It adds an argument called panic to a function that uses the BUG() macro
> which tries to call panic, but the argument masks the panic() function
> declaration, resulting in the following error (gcc 4.2.4):
> 
> net/core/skbuff.c In function 'skb_panic':
> net/core/skbuff.c +126 : error: called object 'panic' is not a function
> 
> This is fixed by renaming the argument to msg.
> 
> Signed-off-by: James Hogan <james.hogan@imgtec.com>

Thanks, James.

I'm sorry I introduced this bug. Shame on me.

-- 
Jean Sacren

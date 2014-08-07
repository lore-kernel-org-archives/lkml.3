Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932294AbaHGNAM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 09:00:12 -0400
Received: from cassarossa.samfundet.no ([193.35.52.29]:54842 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932126AbaHGNAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 09:00:11 -0400
Date: Thu, 7 Aug 2014 15:00:04 +0200
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] avr32: fix error return code
Message-ID: <20140807130004.GA10918@samfundet.no>
References: <1407415749-19978-1-git-send-email-Julia.Lawall@lip6.fr>
 <1407415749-19978-2-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407415749-19978-2-git-send-email-Julia.Lawall@lip6.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Thu 07 Aug 2014 14:49:05 +0200 or thereabout, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Convert a zero return value on error to a negative one, as returned
> elsewhere in the function.

Excellent find, added to this for-linus branch.

> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> identifier ret; expression e1,e2;
> @@
> (
> if (\(ret < 0\|ret != 0\))
>  { ... return ret; }
> |
> ret = 0
> )
> ... when != ret = e1
>     when != &ret
> *if(...)
> {
>   ... when != ret = e2
>       when forall
>  return ret;
> }
> // </smpl>
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>

> ---
>  arch/avr32/boards/hammerhead/flash.c |   11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)

<snipp diff>

-- 
mvh
Hans-Christian Egtvedt

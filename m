Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192Ab3FQX4V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 19:56:21 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:51839 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361Ab3FQX4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 19:56:19 -0400
Date: Mon, 17 Jun 2013 16:56:17 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Zhang Yanfei <zhangyanfei.yes@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Linux MM <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: Remove unlikely from the current_order test
In-Reply-To: <51BF8860.7010909@gmail.com>
Message-ID: <alpine.DEB.2.02.1306171656050.24663@chino.kir.corp.google.com>
References: <51BF8860.7010909@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Jun 2013, Zhang Yanfei wrote:

> From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
> 
> In __rmqueue_fallback(), current_order loops down from MAX_ORDER - 1
> to the order passed. MAX_ORDER is typically 11 and pageblock_order
> is typically 9 on x86. Integer division truncates, so pageblock_order / 2
> is 4.  For the first eight iterations, it's guaranteed that
> current_order >= pageblock_order / 2 if it even gets that far!
> 
> So just remove the unlikely(), it's completely bogus.
> 
> Suggested-by: David Rientjes <rientjes@google.com>
> Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>

Acked-by: David Rientjes <rientjes@google.com>

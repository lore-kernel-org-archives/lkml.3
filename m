Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751686AbaFMEm3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 00:42:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39687 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbaFMEm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 00:42:28 -0400
Date: Thu, 12 Jun 2014 21:40:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Chen Yucong <slaoub@gmail.com>
Cc: mgorman@suse.de, hannes@cmpxchg.org, mhocko@suse.cz, riel@redhat.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/vmscan.c: wrap five parameters into shrink_result
 for reducing the stack consumption
Message-Id: <20140612214016.1beda952.akpm@linux-foundation.org>
In-Reply-To: <1402634191-3442-1-git-send-email-slaoub@gmail.com>
References: <1402634191-3442-1-git-send-email-slaoub@gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jun 2014 12:36:31 +0800 Chen Yucong <slaoub@gmail.com> wrote:

> @@ -1148,7 +1146,8 @@ unsigned long reclaim_clean_pages_from_list(struct zone *zone,
>  		.priority = DEF_PRIORITY,
>  		.may_unmap = 1,
>  	};
> -	unsigned long ret, dummy1, dummy2, dummy3, dummy4, dummy5;
> +	unsigned long ret;
> +	struct shrink_result dummy = { };

You didn't like the idea of making this static?

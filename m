Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044Ab3JHQOu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 12:14:50 -0400
Received: from www.sr71.net ([198.145.64.142]:48972 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752665Ab3JHQOp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 12:14:45 -0400
Message-ID: <52542F53.4020807@sr71.net>
Date: Tue, 08 Oct 2013 09:14:11 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Robert C Jennings <rcj@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
CC: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
        Matt Helsley <matt.helsley@gmail.com>,
        Anthony Liguori <anthony@codemonkey.ws>,
        Michael Roth <mdroth@linux.vnet.ibm.com>,
        Lei Li <lilei@linux.vnet.ibm.com>,
        Leonardo Garcia <lagarcia@linux.vnet.ibm.com>,
        Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH 1/2] vmsplice: unmap gifted pages for recipient
References: <1381177293-27125-1-git-send-email-rcj@linux.vnet.ibm.com> <1381177293-27125-2-git-send-email-rcj@linux.vnet.ibm.com>
In-Reply-To: <1381177293-27125-2-git-send-email-rcj@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2013 01:21 PM, Robert C Jennings wrote:
> +					} else {
> +						if (vma)
> +							zap_page_range(vma,
> +								user_start,
> +								(user_end -
> +								 user_start),
> +								NULL);
> +						vma = find_vma_intersection(
> +								current->mm,
> +								useraddr,
> +								(useraddr +
> +								 PAGE_SIZE));
> +						if (!IS_ERR_OR_NULL(vma)) {
> +							user_start = useraddr;
> +							user_end = (useraddr +
> +								    PAGE_SIZE);
> +						} else
> +							vma = NULL;
> +					}

This is pretty unspeakably hideous.  Was there truly no better way to do
this?

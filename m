Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157AbaCKAj6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 20:39:58 -0400
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:16080 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754083AbaCKAj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 20:39:56 -0400
Message-ID: <1394497958.6784.204.camel@misato.fc.hp.com>
Subject: Re: [PATCH v6 06/22] Replace XIP read and write with DAX I/O
From: Toshi Kani <toshi.kani@hp.com>
To: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, willy@linux.intel.com
Date: Mon, 10 Mar 2014 18:32:38 -0600
In-Reply-To: <1393337918-28265-7-git-send-email-matthew.r.wilcox@intel.com>
References: <1393337918-28265-1-git-send-email-matthew.r.wilcox@intel.com>
	 <1393337918-28265-7-git-send-email-matthew.r.wilcox@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-02-25 at 09:18 -0500, Matthew Wilcox wrote:
> Use the generic AIO infrastructure instead of custom read and write
> methods.  In addition to giving us support for AIO, this adds the missing
> locking between read() and truncate().
> 
 :
> +static void dax_new_buf(void *addr, unsigned size, unsigned first,
> +					loff_t offset, loff_t end, int rw)
> +{
> +	loff_t final = end - offset;	/* The final byte in this buffer */

I may be missing something, but shouldn't it take first into account?

	loff_t final = end - offset + first;

Thanks,
-Toshi


> +	if (rw != WRITE) {
> +		memset(addr, 0, size);
> +		return;
> +	}
> +
> +	if (first > 0)
> +		memset(addr, 0, first);
> +	if (final < size)
> +		memset(addr + final, 0, size - final);
> +}




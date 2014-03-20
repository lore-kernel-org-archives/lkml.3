Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759732AbaCTV6c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 17:58:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34824 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757263AbaCTV6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 17:58:31 -0400
Date: Thu, 20 Mar 2014 14:58:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] mm/filemap.c: ra_submit inline
Message-Id: <20140320145829.fa212e2f15c3199383f3fd11@linux-foundation.org>
In-Reply-To: <20140320225325.ab266ce4592446e33efd0caf@skynet.be>
References: <20140320225325.ab266ce4592446e33efd0caf@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Mar 2014 22:53:25 +0100 Fabian Frederick <fabf@skynet.be> wrote:

> f9acc8c7b35a10 ("readahead: sanify file_ra_state names")
> left ra_submit with a single function call.
> 
> Add 'inline' to save some stack (suggested by Andrew Morton).
> 
> --- a/mm/readahead.c
> +++ b/mm/readahead.c
> @@ -246,7 +246,7 @@ unsigned long max_sane_readahead(unsigned long nr)
>  /*
>   * Submit IO for the read-ahead request in file_ra_state.
>   */
> -unsigned long ra_submit(struct file_ra_state *ra,
> +inline unsigned long ra_submit(struct file_ra_state *ra,
>  		       struct address_space *mapping, struct file *filp)
>  {
>  	int actual;

The ra_submit() callsite in filemap.c will not be able to inline this
function because its definition is unavailable at compilation time.

ra_submit() should be made static inline and moved into a header file
which all callers include.  Probably in mm.h's /* readahead */ section.

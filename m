Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473Ab3KKCtg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 21:49:36 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:59096 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003Ab3KKCt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 21:49:29 -0500
X-AuditID: 9c93017d-b7ce0ae00000398c-63-528045b69d55
Date: Mon, 11 Nov 2013 11:49:25 +0900
From: Kyungsik Lee <kyungsik.lee@lge.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: linux-kernel@vger.kernel.org, Matthew Daley <mattjd@gmail.com>,
        akpm@linux-foundation.org, hyojun.im@lge.com, chan.jeong@lge.com
Subject: Re: [PATCH] unlz4: always set an error return code on failures
Message-ID: <20131111024924.GA23164@hulk>
References: <527CBC7D020000780010117C@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <527CBC7D020000780010117C@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jan,

Thanks for the patch.

On Fri, Nov 08, 2013 at 09:27:09AM +0000, Jan Beulich wrote:
> "ret", being set to -1 early on, gets cleared by the first invocation
> of lz4_decompress()/lz4_decompress_unknownoutputsize(), and hence
> subsequent failures wouldn't be noticed by the caller without setting
> it back to -1 right after those calls.
> 
> Reported-by: Matthew Daley <mattjd@gmail.com>
> Signed-off-by: Jan Beulich <jbeulich@suse.com>
> Cc: Kyungsik Lee <kyungsik.lee@lge.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> 
> --- a/lib/decompress_unlz4.c
> +++ b/lib/decompress_unlz4.c
> @@ -141,6 +141,7 @@ STATIC inline int INIT unlz4(u8 *input, 
>  			goto exit_2;
>  		}
>  
> +		ret = -1;
>  		if (flush && flush(outp, dest_len) != dest_len)
>  			goto exit_2;
>  		if (output)
>
What do you think of adding "ret2" for keeping "ret" error status
which is set by lz4_decompress*() like below.

{
	int ret2;

	ret2 = lz4_decompress(inp, &chunksize, outp, dest_len);
	if (ret2 < 0) {

	}

Thanks,
Kyungsik


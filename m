Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752293AbaESSIy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 14:08:54 -0400
Received: from kanga.kvack.org ([205.233.56.17]:54723 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751879AbaESSIw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 14:08:52 -0400
Date: Mon, 19 May 2014 14:08:51 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Sebastian Ott <sebott@linux.vnet.ibm.com>
Cc: Anatol Pomozov <anatol.pomozov@gmail.com>, linux-aio@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: hanging aio process
Message-ID: <20140519180851.GD2915@kvack.org>
References: <alpine.LFD.2.11.1405191908450.1847@denkbrett>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.11.1405191908450.1847@denkbrett>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 07:38:51PM +0200, Sebastian Ott wrote:
> Hello,
> 
> on the latest kernel a fio job with 4 workers using libaio hangs.

Is more than one process stuck in state D when the hang occurs?  If so, 
what does a backtrace show for the stuck processes (or are there any 
hung process warnings issued)?  It is entirely possible the bug isn't 
caused by the referenced commit, as the commit you're pointing to merely 
makes io_destroy() syscall wait for all aio outstanding to complete 
before returning.

		-ben

> git bisect points to:
> 	commit e02ba72aabfade4c9cd6e3263e9b57bf890ad25c
> 	Author: Anatol Pomozov <anatol.pomozov@gmail.com>
> 	Date:   Tue Apr 15 11:31:33 2014 -0700
> 
> 	    aio: block io_destroy() until all context requests are completed
> 
> 
> The fio workers are on the wait_for_completion in sys_io_destroy.
> 
> Regards,
> Sebastian
> [global]
> blocksize=4K
> size=256M
> rw=randrw
> verify=md5
> iodepth=32
> ioengine=libaio
> direct=1
> end_fsync=1
> 
> [file1]
> filename=/dev/scma
> 
> [file2]
> filename=/dev/scmbw
> 
> [file3]
> filename=/dev/scmc
> 
> [file4]
> filename=/dev/scmx


-- 
"Thought is the essence of where you are now."

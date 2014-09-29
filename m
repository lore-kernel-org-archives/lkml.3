Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630AbaI2S2g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 14:28:36 -0400
Received: from mail.kernel.org ([198.145.19.201]:35590 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753249AbaI2S2f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 14:28:35 -0400
Date: Mon, 29 Sep 2014 15:28:30 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Chang Hyun Park <heartinpiece@gmail.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com
Subject: Re: [PATCH 1/1] perf: Fixed perf trace, 32bit return values to 64bit
Message-ID: <20140929182830.GH3879@kernel.org>
References: <1411736041-8017-1-git-send-email-heartinpiece@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411736041-8017-1-git-send-email-heartinpiece@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Sep 26, 2014 at 09:54:01PM +0900, Chang Hyun Park escreveu:
> perf trace for syscalls resulted in mmap return values being stripped of
> the top 32 bits, and actually printing only the lower 32 bits. This was
> because the ret value was of an 'int' type and not a 'long' type.
> 
> The Problem:
> 991258501.244 ( 0.004 ms): mmap(len: 40001536, prot: READ|WRITE, flags:
> 		PRIVATE|ANONYMOUS, fd: -1) = 0x56691000
> 991258501.257 ( 0.000 ms): minfault [_int_malloc+0x1038] =>
> 			    //anon@0x7fa056691008 //(d.)
> 
> The first line shows an mmap, which succeeds and returns 0x56691000.
> However the next line shows a memory access to that virtual memory area,
> specifically to 0x7fa056691008. The upper 32 bit is lost due to the
> problem mentioned above, and thus mmap's return value didn't have the
> upper 0x7fa0.

Thanks, applied to my perf/core branch.

- Arnaldo

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755726Ab3CYHbw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 03:31:52 -0400
Received: from moltke.seatribe.se ([178.63.100.209]:55546 "EHLO
	moltke.seatribe.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755394Ab3CYHbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 03:31:51 -0400
Date: Mon, 25 Mar 2013 08:31:43 +0100 (CET)
From: Fredrik Tolf <fredrik@dolda2000.com>
To: Bart Van Assche <bvanassche@acm.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: I/O blocked while dirty pages are being flushed
In-Reply-To: <514ED516.4020009@acm.org>
Message-ID: <alpine.DEB.2.02.1303250827120.4028@shack.dolda2000.com>
References: <alpine.DEB.2.02.1303240543280.4028@shack.dolda2000.com> <514ED516.4020009@acm.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Mar 2013, Bart Van Assche wrote:
> On 03/24/13 06:12, Fredrik Tolf wrote:
>> While this flush is running, I find that many a process goes into disk
>> sleep waiting for the flush to complete. This includes the process
>> manipulating the mmapped file whenever it tries to redirty a page
>> currently waiting to be flushed, but also, for instance, programs that
>> write() to log files (since, I guess, the buffer page backing the last
>> written portion of the log file is being flushed).
>
> Had you already encountered this article: Jonathan Corbet, The trouble with 
> stable pages, March 13, 2012 (http://lwn.net/Articles/486311/) ?

I had not, but that certainly does seem to be the exact problem I'm 
having. Thanks for the link; it was a very interesting read! Does anyone 
know if any progress has been made since about any resolution of the 
situation?

I notice linked mail threads with people saying that they have simply 
removed the calls to wait_on_page_writeback to resolve their problems. Can 
this still be considered safe, or have other systems than this 
block-device checksumming started depending on stable pages since? Like 
software RAID, for instance?

--

Fredrik Tolf

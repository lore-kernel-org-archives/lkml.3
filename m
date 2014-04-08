Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756408AbaDHLcq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 07:32:46 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:35740 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755935AbaDHLcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 07:32:45 -0400
Date: Tue, 8 Apr 2014 12:22:29 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Xiao Jin <jin.xiao@intel.com>
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, david.a.cohen@linux.intel.com,
        yanmin.zhang@intel.com
Subject: Re: [PATCH] cdc-acm: some enhancement on acm delayed write
Message-ID: <20140408122229.67e2658e@alan.etchedpixels.co.uk>
In-Reply-To: <53436770.9090008@intel.com>
References: <53436770.9090008@intel.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> (2) acm tty port ASYNCB_INITIALIZED flag will be cleared when
> close. If acm resume callback run after ASYNCB_INITIALIZED flag
> cleared, there will have no chance for delayed write to start.
> That lead to acm_wb.use can't be cleared. If user space open
> acm tty again and try to setd, tty will be blocked in
> tty_wait_until_sent for ever.

If there is data pending when the close occurs the close path should
block until either the close timeout occurs or the buffer is written.
This sounds more like the implementation of the ACM chars_in_buffer
method is wrong and not counting the deferred bytes as unsent ?

Alan

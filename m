Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757575Ab3E0UhK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 16:37:10 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:64971 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757261Ab3E0UhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 16:37:08 -0400
Message-ID: <51A3C3F1.4080907@gmail.com>
Date: Mon, 27 May 2013 13:37:05 -0700
From: Alexander Duyck <alexander.duyck@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Ming Lei <ming.lei@canonical.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Shuah Khan <shuah.khan@hp.com>,
        Joerg Roedel <joro@8bytes.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [RFC PATCH 1/2] dma-debug: allow size to become smaller in dma_unmap
References: <1369671187-24430-1-git-send-email-ming.lei@canonical.com> <1369671187-24430-2-git-send-email-ming.lei@canonical.com>
In-Reply-To: <1369671187-24430-2-git-send-email-ming.lei@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/2013 09:13 AM, Ming Lei wrote:
> This patch looses the check on DMA buffer size for streaming
> DMA unmap, based on the below fact:
> 
> - it is common to see only part of DMA transfer is completed,
> especially in case of DMA_FROM_DEVICE
> 
> So it isn't necessary to unmap the whole DMA buffer inside DMA
> unmapping, and unmapping the actual completed buffer should be more
> efficient. Considered that unmapping is often called in hard irq
> context, time of irq handling can be saved.
> 
> Cc: Shuah Khan <shuah.khan@hp.com>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Alexander Duyck <alexander.h.duyck@intel.com>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Signed-off-by: Ming Lei <ming.lei@canonical.com>

What you are proposing doesn't make much sense.  If you are only wanting
to use part of a buffer then just use the dma_sync primitives.

The idea behind unmapping a buffer is to free any resources associated
with it.  Calling map once, and unmap multiple times per buffer is just
asking for trouble in the form of use after free or memory leaks.

Thanks,

Alex


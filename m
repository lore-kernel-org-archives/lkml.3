Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757948Ab3FTVUd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 17:20:33 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:33370 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757710Ab3FTVUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 17:20:32 -0400
MIME-Version: 1.0
In-Reply-To: <20130619162812.GA20657@jonmason-lab>
References: <1371602813-19828-1-git-send-email-jon.mason@intel.com>
	<1371602813-19828-2-git-send-email-jon.mason@intel.com>
	<CAA9_cmc1Gu=BnM_OpMuqL7Hcjz-kfqxJtZzGHP8Nh-hc+tCWeA@mail.gmail.com>
	<20130619162812.GA20657@jonmason-lab>
Date: Thu, 20 Jun 2013 14:20:30 -0700
X-Google-Sender-Auth: Hopf0fQJljvft02EJsrkkh6GduI
Message-ID: <CAA9_cmehScXsCgxwTHxSJ-KXaa52itDoY+3j1Yajnpy-GFU7Hg@mail.gmail.com>
Subject: Re: [PATCH 1/2] dmadevices: dma_sync_wait undefined
From: Dan Williams <djbw@fb.com>
To: Jon Mason <jon.mason@intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, Dave Jiang <dave.jiang@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 19, 2013 at 9:28 AM, Jon Mason <jon.mason@intel.com> wrote:
> On Tue, Jun 18, 2013 at 06:13:28PM -0700, Dan Williams wrote:
[..]
> NTB is currently using it to flush any pending DMAs.  This is needed
> to allow the DMA engine and the CPU to perform operations on the same
> "Memory Window".  Without this, it is possible for the operations to
> complete out of order, which is not a desired outcome for any network
> traffic over NTB.  CPU is preferred over DMA engine for small
> transfers.  Also, it provides an alternative for errors in the DMA
> engine copy process (e.g., DMA mapping, device_prep_dma_memcpy, and
> dmaengine_submit).

Ok there really isn't a better alternative, is NTB always polling or
does it also use completion callbacks?

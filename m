Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559Ab3HFVwj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 17:52:39 -0400
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:52974 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753087Ab3HFVwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 17:52:38 -0400
Message-ID: <1375825955.7303.37.camel@x61.thuisdomein>
Subject: Re: [PATCH] ioatdma: Fix compiler warning
From: Paul Bolle <pebolle@tiscali.nl>
To: Jon Mason <jon.mason@intel.com>
Cc: Dan Williams <djbw@fb.com>, Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org
Date: Tue, 06 Aug 2013 23:52:35 +0200
In-Reply-To: <1375824963-19884-1-git-send-email-jon.mason@intel.com>
References: <1375824963-19884-1-git-send-email-jon.mason@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 06 Aug 2013 21:52:36.0711 (UTC) FILETIME=[43782770:01CE92EF]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-08-06 at 14:36 -0700, Jon Mason wrote:
> GCC v4.6.3 complains:
> drivers/dma/ioat/dma_v3.c: In function ‘__ioat3_prep_pq16_lock’:
> drivers/dma/ioat/dma_v3.c:264:11: warning: array subscript is below array bounds [-Warray-bounds]
> drivers/dma/ioat/dma_v3.c:264:11: warning: array subscript is below array bounds [-Warray-bounds]
> 
> This is due to the possibility of idx being negative, thus being outside
> the boulds of the array.  Correct this by making idx an unsigned int.
> 
> Signed-off-by: Jon Mason <jon.mason@intel.com>

I tried to silence these warnings in
https://lkml.org/lkml/2013/6/17/233 . And again, after some feedback, in
https://lkml.org/lkml/2013/7/20/137 . Perhaps that second patch is
queued somewhere. I don't know.


Paul Bolle


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414Ab3FZTGC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 15:06:02 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54031 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633Ab3FZTGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 15:06:00 -0400
Date: Wed, 26 Jun 2013 12:05:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Vinod Koul <vinod.koul@linux.intel.com>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [resend PATCH] DMA: PL330: fix locking in
 pl330_free_chan_resources()
Message-Id: <20130626120558.3a05f4a099822c529912a14c@linux-foundation.org>
In-Reply-To: <2690233.kbO94NEnCb@amdc1032>
References: <2690233.kbO94NEnCb@amdc1032>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Jun 2013 15:29:15 +0200 Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com> wrote:

> 
> tasklet_kill() may sleep so call it before taking pch->lock.
> 
> Fixes following lockup:
> 
> [  345.470000] BUG: scheduling while atomic: cat/2383/0x00000002

Seems rather unpleasant, so I added a cc:stable to the changelog.

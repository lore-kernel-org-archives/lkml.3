Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161383AbaDPWQA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 18:16:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46738 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390AbaDPWP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 18:15:58 -0400
Date: Wed, 16 Apr 2014 15:15:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, hch <hch@infradead.org>
Subject: Re: [PATCH 1/1] fs/xfs/xfs_log.c: Fix comparison to bool
Message-Id: <20140416151557.ac032e9621027faa8fc7f86d@linux-foundation.org>
In-Reply-To: <20140413220917.a566d048eb0cc55b5ec9f7be@skynet.be>
References: <20140413220917.a566d048eb0cc55b5ec9f7be@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Apr 2014 22:09:17 +0200 Fabian Frederick <fabf@skynet.be> wrote:

> Fixing coccinelle warning

Please always quote the full error message or warning text when fixing
such things.

> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -2376,7 +2376,7 @@ next_lv:
>  				if (lv)
>  					vecp = lv->lv_iovecp;
>  			}
> -			if (record_cnt == 0 && ordered == false) {
> +			if (record_cnt == 0 && !ordered) {
>  				if (!lv)
>  					return 0;

There was nothing wrong with that code.  I suspect coccinelle bustage.

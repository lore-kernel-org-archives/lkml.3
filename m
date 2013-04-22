Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753623Ab3DVVXa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 17:23:30 -0400
Received: from mail-ia0-f174.google.com ([209.85.210.174]:34752 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708Ab3DVVX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 17:23:28 -0400
Date: Mon, 22 Apr 2013 14:23:24 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: dwmw2@infradead.org, axboe@kernel.dk, shli@kernel.org,
        Paul.Clements@steeleye.com, npiggin@kernel.dk, neilb@suse.de,
        cjb@laptop.org, adrian.hunter@intel.com,
        James.Bottomley@HansenPartnership.com, JBottomley@parallels.com,
        linux-scsi@vger.kernel.org, linux-mtd@lists.infradead.org,
        nbd-general@lists.sourceforge.net, linux-raid@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        jcmvbkbc@gmail.com, Namjae Jeon <namjae.jeon@samsung.com>
Subject: Re: [PATCH v2 0/9] fix max discard sectors limit
Message-ID: <20130422212324.GB4704@localhost>
References: <1366389602-19313-1-git-send-email-linkinjeon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366389602-19313-1-git-send-email-linkinjeon@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 20, 2013 at 01:40:02AM +0900, Namjae Jeon wrote:
> From: Namjae Jeon <namjae.jeon@samsung.com>
> 
> linux-v3.8-rc1 and later support for plug for blkdev_issue_discard with
> commit 0cfbcafcae8b7364b5fa96c2b26ccde7a3a296a9 
> (block: add plug for blkdev_issue_discard )
> 
> For example,
> 1) DISCARD rq-1 with size size 4GB
> 2) DISCARD rq-2 with size size 1GB
> 
> If these 2 discard requests get merged, final request size will be 5GB.
> 
> In this case, request's __data_len field may overflow as it can store
> max 4GB(unsigned int).

Complete NACK - like James said, this fix is nonsensical. This should be
fixed by just checking for overflow before merging requests, not with
weird hacks in the drivers.

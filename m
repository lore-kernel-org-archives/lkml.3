Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932137Ab3JKJwK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 05:52:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58901 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757645Ab3JKJvu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 05:51:50 -0400
Date: Fri, 11 Oct 2013 11:51:39 +0200
From: Karel Zak <kzak@redhat.com>
To: Doug Anderson <dianders@chromium.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Matt Fleming <matt.fleming@intel.com>,
        Sean Paul <seanpaul@chromium.org>, Olof Johansson <olof@lixom.net>,
        Bill Richardson <wfrichar@chromium.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Davidlohr Bueso <davidlohr@hp.com>
Subject: Re: [PATCH] partitions/efi: treat size mismatch as a warning, not an
 error
Message-ID: <20131011095139.GA24613@x2.net.home>
References: <20131009232642.GA12776@jtriplet-mobl1>
 <1381447702-6240-1-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381447702-6240-1-git-send-email-dianders@chromium.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 04:28:22PM -0700, Doug Anderson wrote:
> +	 *
> +	 * Consider a bad value here to be a warning to support dd-ing
> +	 * an image from a smaller disk to a bigger disk.
>  	 */
>  	if (ret == GPT_MBR_PROTECTIVE) {
>  		sz = le32_to_cpu(mbr->partition_record[part].size_in_lba);
>  		if (sz != (uint32_t) total_sectors - 1 && sz != 0xFFFFFFFF)
> -			ret = 0;
> +			pr_warn("%s: mbr size mismatch (%u != %u)\n", __func__,
> +				sz, (uint32_t)((uint32_t) total_sectors - 1));
>  	}

 I did the same change to util-linux v2.24 fdisk, so you can use the fdisk
 to update your protective MBR and boot without warnings.

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com

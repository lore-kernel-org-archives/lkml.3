Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757841AbaGWOKg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 10:10:36 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:42608 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757793AbaGWOKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 10:10:34 -0400
Date: Wed, 23 Jul 2014 15:10:28 +0100
From: Sitsofe Wheeler <sitsofe@gmail.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, ohering@suse.com, apw@canonical.com,
        jasowang@redhat.com, jbottomley@parallels.com, hch@infradead.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/1] Drivers: scsi: storvsc: Add blist flags
Message-ID: <20140723141028.GA22724@sucs.org>
References: <1405983961-18782-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405983961-18782-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2014 at 04:06:01PM -0700, K. Y. Srinivasan wrote:
> Add blist flags to permit the reading of the VPD pages even when
> the target may claim SPC-2 compliance. MSFT targets currently
> claim SPC-2 compliance while they implement post SPC-2 features.
> With this patch we can correctly handle WRITE_SAME_16 issues.
> 
>  static void storvsc_on_channel_callback(void *context);
> @@ -1449,6 +1451,14 @@ static int storvsc_device_configure(struct scsi_device *sdevice)
>  
>  	sdevice->no_write_same = 1;
>  
> +	/*
> +	 * Add blist flags to permit the reading of the VPD pages even when
> +	 * the target may claim SPC-2 compliance. MSFT targets currently
> +	 * claim SPC-2 compliance while they implement post SPC-2 features.
> +	 * With this patch we can correctly handle WRITE_SAME_16 issues.
> +	 */
> +	sdevice->sdev_bflags |= msft_blist_flags;
> +

I'm not sure this alone will work - won't sdev_bflags/bflags have
already been built at this point? If the setting of this has to stay in
this function why don't you (also) set sdevice->try_vpd_pages in a
similar way to no_write_same?

-- 
Sitsofe | http://sucs.org/~sits/

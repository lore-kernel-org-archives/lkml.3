Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081Ab3FXXfM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 19:35:12 -0400
Received: from smtp.infotech.no ([82.134.31.41]:55118 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751129Ab3FXXfK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 19:35:10 -0400
Message-ID: <51C8D796.8000005@interlog.com>
Date: Tue, 25 Jun 2013 01:34:46 +0200
From: Douglas Gilbert <dgilbert@interlog.com>
Reply-To: dgilbert@interlog.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Akinobu Mita <akinobu.mita@gmail.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v3 4/4] scsi_debug: fix do_device_access() with wrap around
 range
References: <1371991061-19437-1-git-send-email-akinobu.mita@gmail.com> <1371991061-19437-5-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1371991061-19437-5-git-send-email-akinobu.mita@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-06-23 02:37 PM, Akinobu Mita wrote:
> do_device_access() is a function that abstracts copying SG list from/to
> ramdisk storage (fake_storep).
>
> It must deal with the ranges exceeding actual fake_storep size, because
> such ranges are valid if virtual_gb is set greater than zero, and they
> should be treated as fake_storep is repeatedly mirrored up to virtual size.
>
> Unfortunately, it can't deal with the range which wraps around the end of
> fake_storep. A wrap around range is copied by two sg_copy_{from,to}_buffer()
> calls, but sg_copy_{from,to}_buffer() can't copy from/to in the middle of
> SG list, therefore the second call can't copy correctly.
>
> This fixes it by using sg_pcopy_{from,to}_buffer() that can copy from/to
> the middle of SG list.
>
> This also simplifies the assignment of sdb->resid in fill_from_dev_buffer().
> Because fill_from_dev_buffer() is now only called once per command
> execution cycle.  So it is not necessary to take care to decrease
> sdb->resid if fill_from_dev_buffer() is called more than once.
>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
> Cc: Douglas Gilbert <dgilbert@interlog.com>
> Cc: linux-scsi@vger.kernel.org
> ---
>
> * No change from v2

Acked-by: Douglas Gilbert <dgilbert@interlog.com>


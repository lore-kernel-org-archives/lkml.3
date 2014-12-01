Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932470AbaLAUfx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 15:35:53 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50249 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932373AbaLAUfv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 15:35:51 -0500
Date: Mon, 1 Dec 2014 21:36:05 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Mathieu Magnaudet <mathieu.magnaudet@gmail.com>
cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hid: export hid_report_len as an inline function in
 hid.h
In-Reply-To: <1417100556-7096-1-git-send-email-mathieu.magnaudet@enac.fr>
Message-ID: <alpine.LNX.2.00.1412012134240.2524@pobox.suse.cz>
References: <1417100556-7096-1-git-send-email-mathieu.magnaudet@enac.fr>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Nov 2014, Mathieu Magnaudet wrote:

> in several hid drivers it is necessary to calculate the length
> of an hid_report. This patch exports the existing static function
> hid_report_len of hid-core.c as an inline function in hid.h
> 
> Signed-off-by: Mathieu Magnaudet <mathieu.magnaudet@enac.fr>

Applied, thanks.

[ ... snip ... ]
> diff --git a/include/linux/hid.h b/include/linux/hid.h
> index d585d02..06c4607 100644
> --- a/include/linux/hid.h
> +++ b/include/linux/hid.h
> @@ -1087,6 +1087,17 @@ static inline void hid_hw_wait(struct hid_device *hdev)
>  		hdev->ll_driver->wait(hdev);
>  }
>  
> +/**
> + * hid_report_len - calculate the report length
> + *
> + * @report: the report we want to know the length
> + */
> +static inline int hid_report_len(struct hid_report *report)
> +{
> +	/* equivalent to DIV_ROUND_UP(report->size, 8) + !!(report->id > 0) */
> +	return ((report->size - 1) >> 3) + 1 + (report->id > 0);

BTW this makes me -- being the person resposible for that ugly calculation 
-- wonder whether we shouldn't, in the name of readability, just drop the 
comment and make the code look that way instead.

-- 
Jiri Kosina
SUSE Labs

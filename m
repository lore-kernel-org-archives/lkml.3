Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751709AbaC2Bmr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 21:42:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44346 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751539AbaC2Bmq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 21:42:46 -0400
Date: Fri, 28 Mar 2014 18:42:44 -0700 (PDT)
From: Jiri Kosina <jkosina@suse.cz>
To: "K. Y. Srinivasan" <kys@microsoft.com>
cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        ohering@suse.com, benjamin.tissoires@redhat.com, dh.herrmann@gmail.com
Subject: Re: [PATCH 1/1] Drivers: hid: hid-hyperv: Implement a stub 
 raw_request() entry point
In-Reply-To: <1396053687-21421-1-git-send-email-kys@microsoft.com>
Message-ID: <alpine.LNX.2.00.1403281842100.16202@pobox.suse.cz>
References: <1396053687-21421-1-git-send-email-kys@microsoft.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Mar 2014, K. Y. Srinivasan wrote:

> commit 3c86726cfe38952f0366f86acfbbb025813ec1c2
> Author: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> Date:   Thu Feb 20 15:24:49 2014 -0500
> 
>     HID: make .raw_request mandatory
> 
>     SET_REPORT and GET_REPORT are mandatory in the HID specification.
>     Make the corresponding API in hid-core mandatory too, which removes the
>     need to test against it in some various places.
> 
>     Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
>     Reviewed-by: David Herrmann <dh.herrmann@gmail.com>
>     Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> 
> Made .raw_request mandatory and broke the Hyper-V mouse driver. This patch
> fixes the problem.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> ---
>  drivers/hid/hid-hyperv.c |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/hid/hid-hyperv.c b/drivers/hid/hid-hyperv.c
> index c24908f..89a9234 100644
> --- a/drivers/hid/hid-hyperv.c
> +++ b/drivers/hid/hid-hyperv.c
> @@ -460,12 +460,22 @@ static void mousevsc_hid_stop(struct hid_device *hid)
>  {
>  }
>  
> +static int mousevsc_hid_raw_request(struct hid_device *hid,
> +				    unsigned char report_num,
> +				    __u8 buf, size_t len,

This should be __u8 *buf. I have fixed that and applied.

-- 
Jiri Kosina
SUSE Labs

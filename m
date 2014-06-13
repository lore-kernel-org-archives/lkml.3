Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919AbaFMUub (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 16:50:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51373 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751961AbaFMUua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 16:50:30 -0400
Date: Fri, 13 Jun 2014 16:50:27 -0400
From: Aristeu Rozanski <aris@redhat.com>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Ping Cheng <pinglinux@gmail.com>, Jason Gerecke <killertofu@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Revert "Input: wacom - testing result shows get_report
 is unnecessary."
Message-ID: <20140613205027.GN16780@redhat.com>
References: <1402691538-26392-1-git-send-email-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402691538-26392-1-git-send-email-benjamin.tissoires@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 04:32:18PM -0400, Benjamin Tissoires wrote:
> This reverts commit 1b2faaf7e219fc2905d75afcd4c815e5d39eda80.
> 
> The Intuos4 series presents a bug in which it hangs if it receives
> a set feature command while switching to the enhanced mode.
> This bug is triggered when plugging an Intuos 4 while having
> a gnome user session up and running.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> ---
> 
> Hi Aris,
> 
> actually, you bisected the bug, so can I consider that I have your signed-off-by?

Yes, my apologies, I ended up losing track of this and didn't send
earlier.

Signed-off-by: Aristeu Rozanski <aris@redhat.com>

>  drivers/input/tablet/wacom_sys.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/input/tablet/wacom_sys.c b/drivers/input/tablet/wacom_sys.c
> index 7087b33..319a3ff 100644
> --- a/drivers/input/tablet/wacom_sys.c
> +++ b/drivers/input/tablet/wacom_sys.c
> @@ -536,6 +536,9 @@ static int wacom_set_device_mode(struct usb_interface *intf, int report_id, int
>  
>  		error = wacom_set_report(intf, WAC_HID_FEATURE_REPORT,
>  		                         report_id, rep_data, length, 1);
> +		if (error >= 0)
> +			error = wacom_get_report(intf, WAC_HID_FEATURE_REPORT,
> +			                         report_id, rep_data, length, 1);
>  	} while ((error < 0 || rep_data[1] != mode) && limit++ < WAC_MSG_RETRIES);
>  
>  	kfree(rep_data);
> -- 
> 1.9.0
> 

-- 
Aristeu


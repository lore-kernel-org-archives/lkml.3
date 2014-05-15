Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755105AbaEOVLd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 17:11:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2676 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751504AbaEOVLb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 17:11:31 -0400
Date: Thu, 15 May 2014 21:11:23 +0000
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Andrew Duggan <aduggan@synaptics.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH] HID: rmi: fix masks for x and w_x data
Message-ID: <20140515211123.GA10497@mail.corp.redhat.com>
References: <1400187149-7619-1-git-send-email-aduggan@synaptics.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1400187149-7619-1-git-send-email-aduggan@synaptics.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On May 15 2014 or thereabouts, Andrew Duggan wrote:
> The F11 data in the HID report contains four bits of data for w_x and the least significant bits
> of x. Currently only the first three bits are being used which is resulting in small jumps in
> the position data on the x axis and in the w_x data.
> 
> Signed-off-by: Andrew Duggan <aduggan@synaptics.com>
> ---

Good catch. I might have considered that 3:0 means 3 bits, not 4. I must
have been tired while writing it :)

Reviewed-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

Cheers,
Benjamin

>  drivers/hid/hid-rmi.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/hid/hid-rmi.c b/drivers/hid/hid-rmi.c
> index 7ebdc96..c529b03 100644
> --- a/drivers/hid/hid-rmi.c
> +++ b/drivers/hid/hid-rmi.c
> @@ -277,9 +277,9 @@ static void rmi_f11_process_touch(struct rmi_data *hdata, int slot,
>  	input_mt_report_slot_state(hdata->input, MT_TOOL_FINGER,
>  			finger_state == 0x01);
>  	if (finger_state == 0x01) {
> -		x = (touch_data[0] << 4) | (touch_data[2] & 0x07);
> +		x = (touch_data[0] << 4) | (touch_data[2] & 0x0F);
>  		y = (touch_data[1] << 4) | (touch_data[2] >> 4);
> -		wx = touch_data[3] & 0x07;
> +		wx = touch_data[3] & 0x0F;
>  		wy = touch_data[3] >> 4;
>  		wide = (wx > wy);
>  		major = max(wx, wy);
> -- 
> 1.9.1
> 

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933074AbaGOTHe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 15:07:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64674 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932760AbaGOTH3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 15:07:29 -0400
Date: Tue, 15 Jul 2014 15:07:23 -0400
From: Benjamin Tissoires =?utf-8?B?wqA=?= 
	<benjamin.tissoires@redhat.com>
To: Andrew Duggan <aduggan@synaptics.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH] HID: rmi: change logging level of log messages related
 to unexpected reports
Message-ID: <20140715190723.GC21045@mail.corp.redhat.com>
References: <1405114551-24354-1-git-send-email-aduggan@synaptics.com>
 <1405114551-24354-2-git-send-email-aduggan@synaptics.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1405114551-24354-2-git-send-email-aduggan@synaptics.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 11 2014 or thereabouts, Andrew Duggan wrote:
> Userspace tools may use hidraw to perform operations on the device from userspace while
> hid-rmi is bound to the device. This can cause hid-rmi to print error messages when its
> ->raw_event() callback gets called as the reports pass through the HID stack. In this case
> receiving responses which were not initiated by hid-rmi is not actually an error so the resulting
> error messages are incorrect and misleading. This patch changes the log messages to debug so
> that the messages can be turned on in the event that there is a problem and there is not
> a userspace tool running.
> 
> Signed-off-by: Andrew Duggan <aduggan@synaptics.com>
> ---

Fair enough

Reviewed-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

Cheers,
Benjamin

>  drivers/hid/hid-rmi.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/hid/hid-rmi.c b/drivers/hid/hid-rmi.c
> index 578bbe6..25f571a 100644
> --- a/drivers/hid/hid-rmi.c
> +++ b/drivers/hid/hid-rmi.c
> @@ -377,7 +377,7 @@ static int rmi_input_event(struct hid_device *hdev, u8 *data, int size)
>  	irq_mask |= hdata->f30.irq_mask;
>  
>  	if (data[1] & ~irq_mask)
> -		hid_warn(hdev, "unknown intr source:%02lx %s:%d\n",
> +		hid_dbg(hdev, "unknown intr source:%02lx %s:%d\n",
>  			data[1] & ~irq_mask, __FILE__, __LINE__);
>  
>  	if (hdata->f11.interrupt_base < hdata->f30.interrupt_base) {
> @@ -400,7 +400,7 @@ static int rmi_read_data_event(struct hid_device *hdev, u8 *data, int size)
>  	struct rmi_data *hdata = hid_get_drvdata(hdev);
>  
>  	if (!test_bit(RMI_READ_REQUEST_PENDING, &hdata->flags)) {
> -		hid_err(hdev, "no read request pending\n");
> +		hid_dbg(hdev, "no read request pending\n");
>  		return 0;
>  	}
>  
> -- 
> 1.9.1
> 

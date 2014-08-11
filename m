Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716AbaHKS4U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 14:56:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2402 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753240AbaHKS4T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 14:56:19 -0400
Message-ID: <53E911CA.5090400@redhat.com>
Date: Mon, 11 Aug 2014 20:56:10 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Sanjeev Sharma <sanjeev_sharma@mentor.com>, gregkh@linuxfoundation.org
CC: kraxel@redhat.com, mdharm-usb@one-eyed-alien.net,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] uas: replace WARN_ON_ONCE() with assert_spin_locked().
References: <1407743966-25325-1-git-send-email-sanjeev_sharma@mentor.com>
In-Reply-To: <1407743966-25325-1-git-send-email-sanjeev_sharma@mentor.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 08/11/2014 09:59 AM, Sanjeev Sharma wrote:
> spin_is_locked() always return false in uniprocessor configuration and therefore it
> would be advise to repalce with assert_spin_locked().
> 
> Signed-off-by: Sanjeev Sharma <Sanjeev_Sharma@mentor.com>

Looks sane / good to me:

Acked-by: Hans de Goede <hdegoede@redhat.com>

Regards,

Hans



> ---
>  drivers/usb/storage/uas.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
> index 3f42785..8e5877d 100644
> --- a/drivers/usb/storage/uas.c
> +++ b/drivers/usb/storage/uas.c
> @@ -154,7 +154,7 @@ static void uas_mark_cmd_dead(struct uas_dev_info *devinfo,
>  	struct scsi_cmnd *cmnd = container_of(scp, struct scsi_cmnd, SCp);
>  
>  	uas_log_cmd_state(cmnd, caller);
> -	WARN_ON_ONCE(!spin_is_locked(&devinfo->lock));
> +	assert_spin_locked(&devinfo->lock);
>  	WARN_ON_ONCE(cmdinfo->state & COMMAND_ABORTED);
>  	cmdinfo->state |= COMMAND_ABORTED;
>  	cmdinfo->state &= ~IS_IN_WORK_LIST;
> @@ -181,7 +181,7 @@ static void uas_add_work(struct uas_cmd_info *cmdinfo)
>  	struct scsi_cmnd *cmnd = container_of(scp, struct scsi_cmnd, SCp);
>  	struct uas_dev_info *devinfo = cmnd->device->hostdata;
>  
> -	WARN_ON_ONCE(!spin_is_locked(&devinfo->lock));
> +	assert_spin_locked(&devinfo->lock);
>  	cmdinfo->state |= IS_IN_WORK_LIST;
>  	schedule_work(&devinfo->work);
>  }
> @@ -283,7 +283,7 @@ static int uas_try_complete(struct scsi_cmnd *cmnd, const char *caller)
>  	struct uas_cmd_info *cmdinfo = (void *)&cmnd->SCp;
>  	struct uas_dev_info *devinfo = (void *)cmnd->device->hostdata;
>  
> -	WARN_ON_ONCE(!spin_is_locked(&devinfo->lock));
> +	assert_spin_locked(&devinfo->lock);
>  	if (cmdinfo->state & (COMMAND_INFLIGHT |
>  			      DATA_IN_URB_INFLIGHT |
>  			      DATA_OUT_URB_INFLIGHT |
> @@ -622,7 +622,7 @@ static int uas_submit_urbs(struct scsi_cmnd *cmnd,
>  	struct urb *urb;
>  	int err;
>  
> -	WARN_ON_ONCE(!spin_is_locked(&devinfo->lock));
> +	assert_spin_locked(&devinfo->lock);
>  	if (cmdinfo->state & SUBMIT_STATUS_URB) {
>  		urb = uas_submit_sense_urb(cmnd, gfp, cmdinfo->stream);
>  		if (!urb)
> 

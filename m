Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368AbaHKSTM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 14:19:12 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:43060 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444AbaHKSTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 14:19:09 -0400
Date: Mon, 11 Aug 2014 11:19:05 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Sanjeev Sharma <sanjeev_sharma@mentor.com>
Cc: gregkh@linuxfoundation.org, hdegoede@redhat.com, kraxel@redhat.com,
        mdharm-usb@one-eyed-alien.net, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] uas: replace WARN_ON_ONCE() with assert_spin_locked().
Message-ID: <20140811181905.GA25727@roeck-us.net>
References: <1407743966-25325-1-git-send-email-sanjeev_sharma@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407743966-25325-1-git-send-email-sanjeev_sharma@mentor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2014 at 01:29:26PM +0530, Sanjeev Sharma wrote:
> spin_is_locked() always return false in uniprocessor configuration and therefore it
> would be advise to repalce with assert_spin_locked().
> 
> Signed-off-by: Sanjeev Sharma <Sanjeev_Sharma@mentor.com>
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

Seems to me that replacing WARN_ON_ONCE (which may be annoying but only
creates a traceback, and only once) with assert_spin_locked (which
crashes the kernel) is a bit drastic.

Guenter

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365Ab3J3NTE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 09:19:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44713 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754155Ab3J3NTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 09:19:02 -0400
Date: Wed, 30 Oct 2013 06:21:01 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peng Tao <bergwolf@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andreas Dilger <andreas.dilger@intel.com>
Subject: Re: [PATCH 2/4] staging/lustre/obdclass: read jobid from proc
Message-ID: <20131030132101.GD30087@kroah.com>
References: <1383132636-8952-1-git-send-email-bergwolf@gmail.com>
 <1383132636-8952-2-git-send-email-bergwolf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383132636-8952-2-git-send-email-bergwolf@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30, 2013 at 07:30:34PM +0800, Peng Tao wrote:
> so that we can get rid of cfs_get_environ() that needs access_process_vm() that
> is a core mm function and is not available on some architectures.
> 
> Reviewed-by: Niu Yawei <yawei.niu@intel.com>
> Signed-off-by: Peng Tao <bergwolf@gmail.com>
> Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
> ---
>  drivers/staging/lustre/lustre/obdclass/class_obd.c |  119 +++++++++++++++++++-
>  1 file changed, 115 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/lustre/lustre/obdclass/class_obd.c b/drivers/staging/lustre/lustre/obdclass/class_obd.c
> index b1024a6..99ce863 100644
> --- a/drivers/staging/lustre/lustre/obdclass/class_obd.c
> +++ b/drivers/staging/lustre/lustre/obdclass/class_obd.c
> @@ -96,8 +96,117 @@ EXPORT_SYMBOL(obd_dirty_transit_pages);
>  char obd_jobid_var[JOBSTATS_JOBID_VAR_MAX_LEN + 1] = JOBSTATS_DISABLE;
>  EXPORT_SYMBOL(obd_jobid_var);
>  
> -/* Get jobid of current process by reading the environment variable
> - * stored in between the "env_start" & "env_end" of task struct.
> +static char *self_environ_file = "/proc/self/environ";

Heh, no, that's not ok at all.

This is a _huge_ sign that you are doing something wrong in your driver
if you need something that isn't exported, or that you have to dig out
of proc.

Sorry, I can't take this, please fix the underlying problems that would
even think that you need access to the environment from within a kernel
driver.

greg k-h

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612Ab3KZD33 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 22:29:29 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58477 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855Ab3KZD31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 22:29:27 -0500
Date: Mon, 25 Nov 2013 19:30:12 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peng Tao <bergwolf@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        JC Lafoucriere <jacques-charles.lafoucriere@cea.fr>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: Re: [PATCH 08/16] staging/lustre/mdt: HSM coordinator agent interface
Message-ID: <20131126033012.GA30128@kroah.com>
References: <1385431510-18988-1-git-send-email-bergwolf@gmail.com>
 <1385431510-18988-9-git-send-email-bergwolf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385431510-18988-9-git-send-email-bergwolf@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 26, 2013 at 10:05:02AM +0800, Peng Tao wrote:
> From: JC Lafoucriere <jacques-charles.lafoucriere@cea.fr>
> 
> To move data with external storage, HSM coordinator
> uses a Copy Tool running on a client named agent.
> This patch implements the interface for these agents.

Interesting text here...

> Lustre-change: http://review.whamcloud.com/6534
> Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3342
> Signed-off-by: JC Lafoucriere <jacques-charles.lafoucriere@cea.fr>
> Reviewed-by: Jinshan Xiong <jinshan.xiong@intel.com>
> Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
> Reviewed-by: John L. Hammond <john.hammond@intel.com>
> Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
> Signed-off-by: Peng Tao <bergwolf@gmail.com>
> Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
> ---
>  .../lustre/lustre/include/lustre/lustre_user.h     |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/lustre/lustre/include/lustre/lustre_user.h b/drivers/staging/lustre/lustre/include/lustre/lustre_user.h
> index 9436166..631f026 100644
> --- a/drivers/staging/lustre/lustre/include/lustre/lustre_user.h
> +++ b/drivers/staging/lustre/lustre/include/lustre/lustre_user.h
> @@ -428,8 +428,8 @@ struct obd_uuid {
>  	char uuid[UUID_MAX];
>  };
>  
> -static inline int obd_uuid_equals(const struct obd_uuid *u1,
> -				  const struct obd_uuid *u2)
> +static inline bool obd_uuid_equals(const struct obd_uuid *u1,
> +				   const struct obd_uuid *u2)
>  {
>  	return strcmp((char *)u1->uuid, (char *)u2->uuid) == 0;
>  }
> @@ -446,7 +446,7 @@ static inline void obd_str2uuid(struct obd_uuid *uuid, const char *tmp)
>  }
>  
>  /* For printf's only, make sure uuid is terminated */
> -static inline char *obd_uuid2str(struct obd_uuid *uuid)
> +static inline char *obd_uuid2str(const struct obd_uuid *uuid)
>  {
>  	if (uuid->uuid[sizeof(*uuid) - 1] != '\0') {
>  		/* Obviously not safe, but for printfs, no real harm done...

Too bad it doesn't describe the changes made in the code at all.

How can so many people review a patch that is not the same as what it
says it really is?

I'm stopping here in the series, sorry.  Please fix up and resend the
rest when you can.

greg k-h

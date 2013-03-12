Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979Ab3CLDIA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 23:08:00 -0400
Received: from smtp.nue.novell.com ([195.135.221.5]:53066 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714Ab3CLDH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 23:07:59 -0400
Subject: Re: [PATCH] efivars: allow efi pstore variable when validate
 filename
From: joeyli <jlee@suse.com>
To: matt.fleming@intel.com
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Lingzhu Xiang <lxiang@redhat.com>
In-Reply-To: <1363028428-27976-1-git-send-email-jlee@suse.com>
References: <1363028428-27976-1-git-send-email-jlee@suse.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Mar 2013 11:06:19 +0800
Message-ID: <1363057579.13754.46.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matt, 

Sorry for I didn't aware your 123abd76edf patch fixed issue.
Please ignore my patch.


Thanks a lot!
Joey Lee

於 二，2013-03-12 於 03:00 +0800，Lee, Chun-Yi 提到：
> We mount efivarfs fail after pstore generated 'dump-type*' variables and
> reboot.
> 
> This issue introduced by commit 47f531e8ba3bc3901a0c493f4252826c41dea1a1
> (efivarfs: Validate filenames much more aggressively)
> 
> The pstore variable is 'dump-type*-*-*-*-GUID'style, it could not pass
> the "GUID should be right after the first '-'" check. This patch allow
> the variable name that has 'dump-type' pass the name check.
> 
> Cc: Matt Fleming <matt.fleming@intel.com>
> Cc: Seiji Aguchi <seiji.aguchi@hds.com>
> Cc: Matthew Garrett <mjg59@srcf.ucam.org>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Lingzhu Xiang <lxiang@redhat.com>
> Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
> ---
>  drivers/firmware/efivars.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
> index 3edade0..ab07f7f 100644
> --- a/drivers/firmware/efivars.c
> +++ b/drivers/firmware/efivars.c
> @@ -930,7 +930,7 @@ static bool efivarfs_valid_name(const char *str, int len)
>  		return false;
>  
>  	/* GUID should be right after the first '-' */
> -	if (s - 1 != strchr(str, '-'))
> +	if (s - 1 != strchr(str, '-') && !strstarts(str, "dump-type"))
>  		return false;
>  
>  	/*



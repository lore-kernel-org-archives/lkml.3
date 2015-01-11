Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747AbbAKENW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 23:13:22 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46725 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995AbbAKENV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 23:13:21 -0500
Date: Sat, 10 Jan 2015 20:13:19 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Joe Perches <joe@perches.com>
Cc: Benjamin Romer <benjamin.romer@unisys.com>,
        David Kershner <david.kershner@unisys.com>, devel@driverdev.osuosl.org,
        sparmaintainer@unisys.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: unisys: Convert direct LOGERR uses to pr_err
Message-ID: <20150111041319.GB22334@kroah.com>
References: <1420945742.16787.12.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420945742.16787.12.camel@perches.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 10, 2015 at 07:09:02PM -0800, Joe Perches wrote:
> Use the normal logging facility instead of a new macro.
> 
> Miscellanea:
> 
> o Realign arguments
> o Remove unnecessary alloc error messages as alloc failures
>   already emits a generic OOM message with a dump_stack
> o Add missing newlines to these messages to avoid interleaving
> o Spelling/typo fixes in those messages
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/staging/unisys/include/uisutils.h          |   4 +-
>  drivers/staging/unisys/uislib/uislib.c             | 169 ++++++++++-----------
>  drivers/staging/unisys/uislib/uisqueue.c           |   4 +-
>  drivers/staging/unisys/uislib/uisthread.c          |   4 +-
>  drivers/staging/unisys/uislib/uisutils.c           |  34 ++---
>  drivers/staging/unisys/virthba/virthba.c           | 119 +++++++--------
>  drivers/staging/unisys/virtpci/virtpci.c           |  71 +++++----
>  drivers/staging/unisys/visorchipset/file.c         |   2 +-
>  .../unisys/visorchipset/visorchipset_main.c        | 159 ++++++++++---------
>  9 files changed, 276 insertions(+), 290 deletions(-)
> 
> diff --git a/drivers/staging/unisys/include/uisutils.h b/drivers/staging/unisys/include/uisutils.h
> index 7414220..f937892 100644
> --- a/drivers/staging/unisys/include/uisutils.h
> +++ b/drivers/staging/unisys/include/uisutils.h
> @@ -206,10 +206,10 @@ wait_for_valid_guid(uuid_le __iomem *guid)
>  			      (void __iomem *)guid, sizeof(uuid_le));
>  		if (uuid_le_cmp(tmpguid, NULL_UUID_LE) != 0)
>  			break;
> -		LOGERR("Waiting for non-0 GUID (why???)...\n");
> +		pr_err("Waiting for non-0 GUID (why???)...\n");

I rejected the other patch that did much this same thing, almost all of
these should be converted to use dev_* calls instead of pr_* calls, as
this is a driver, and drivers should always have access to a struct
device.  If not, they need to be fixed.

thanks,

greg k-h

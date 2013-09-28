Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750994Ab3I1EBs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 00:01:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48227 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844Ab3I1EBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 00:01:46 -0400
Date: Fri, 27 Sep 2013 21:02:57 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Stefan Achatz <erazor_de@users.sourceforge.net>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: roccat: Fix "cannot create duplicate filename"
 problems
Message-ID: <20130928040257.GA21630@kroah.com>
References: <1380340666.2451.4.camel@neuromancer.tessier-ashpool>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380340666.2451.4.camel@neuromancer.tessier-ashpool>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 28, 2013 at 05:57:46AM +0200, Stefan Achatz wrote:
> Fixing some wrong macro stringification/concatenation.
> 
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
> ---
>  drivers/hid/hid-roccat-kone.c     |    2 +-
>  drivers/hid/hid-roccat-koneplus.c |    4 ++--
>  drivers/hid/hid-roccat-kovaplus.c |    4 ++--
>  drivers/hid/hid-roccat-pyra.c     |    4 ++--
>  4 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/hid/hid-roccat-kone.c b/drivers/hid/hid-roccat-kone.c
> index 602c188..6101816 100644
> --- a/drivers/hid/hid-roccat-kone.c
> +++ b/drivers/hid/hid-roccat-kone.c
> @@ -382,7 +382,7 @@ static ssize_t kone_sysfs_write_profilex(struct file *fp,
>  }
>  #define PROFILE_ATTR(number)					\
>  static struct bin_attribute bin_attr_profile##number = {	\
> -	.attr = { .name = "profile##number", .mode = 0660 },	\
> +	.attr = { .name = "profile" #number, .mode = 0660 },	\

Ugh, very sorry about that, I hate macros in C at times :)

Jiri, can you take this through your tree, or I can if you want, it
needs to go in for 3.12-final.

If yours, feel free to add:

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Stefan, thanks for fixing my bugs, it's much appreciated.

greg k-h

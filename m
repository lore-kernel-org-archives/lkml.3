Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186AbaJ2Coe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 22:44:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36280 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739AbaJ2Cod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 22:44:33 -0400
Date: Wed, 29 Oct 2014 10:43:20 +0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Cc: linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: Re: [PATCH 1/2] kobject: Add kobject_initialized() function
Message-ID: <20141029024320.GB7338@kroah.com>
References: <1414510008-7262-1-git-send-email-tomeu.vizoso@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414510008-7262-1-git-send-email-tomeu.vizoso@collabora.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 04:26:47PM +0100, Tomeu Vizoso wrote:
> To be used by users of kobject to tell when one hasn't been initialized yet.
> 
> Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
> ---
>  include/linux/kobject.h | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/include/linux/kobject.h b/include/linux/kobject.h
> index 2d61b90..6bb5a92 100644
> --- a/include/linux/kobject.h
> +++ b/include/linux/kobject.h
> @@ -88,6 +88,11 @@ static inline const char *kobject_name(const struct kobject *kobj)
>  	return kobj->name;
>  }
>  
> +static inline bool kobject_initialized(const struct kobject *kobj)
> +{
> +	return kobj->state_initialized;
> +}

Ick, no.  Why would you ever need this?  You "own" the kobject, and you
better know if you initialized it or not.  If not, you should fix your
use of a kobject.

And why are you even using a kobject at all?

greg k-h

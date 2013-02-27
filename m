Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760149Ab3B0Qg6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 11:36:58 -0500
Received: from mail-da0-f47.google.com ([209.85.210.47]:51729 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706Ab3B0Qg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 11:36:56 -0500
Date: Wed, 27 Feb 2013 08:36:53 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Michail Kurachkin <michail.kurachkin@promwad.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kuten Ivan <Ivan.Kuten@promwad.com>,
        "benavi@marvell.com" <benavi@marvell.com>,
        Palstsiuk Viktar <Viktar.Palstsiuk@promwad.com>,
        Dmitriy Gorokh <dmitriy.gorokh@promwad.com>
Subject: Re: [PATCH 7/9] added issues description in TODO file
Message-ID: <20130227163653.GA23508@kroah.com>
References: <1361982404-5398-1-git-send-email-michail.kurachkin@promwad.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361982404-5398-1-git-send-email-michail.kurachkin@promwad.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2013 at 07:26:44PM +0300, Michail Kurachkin wrote:
> Signed-off-by: Michail Kurachkin <michail.kurachkin@promwad.com>
> ---
>  drivers/staging/si3226x/TODO |    8 +++++++-
>  1 files changed, 7 insertions(+), 1 deletions(-)

Please, when sending patches, make them descriptive of what part of the
kernel that this is for.  In this specific instance, your Subject:
should be:
	"staging: si3226x: add issues to TODO file"
that way it makes sense where things are being changed, and it makes it
easier to find the series in my inbox (hint, you should also use
git-send-email to chain them, not make them individual threads, but
that's a minor issue.)

> diff --git a/drivers/staging/si3226x/TODO b/drivers/staging/si3226x/TODO
> index 83c5958..b2cb27e 100644
> --- a/drivers/staging/si3226x/TODO
> +++ b/drivers/staging/si3226x/TODO
> @@ -1,2 +1,8 @@
>  1) mutex_lock(&slic_chr_dev_lock);
> -This locking is very heavy handed. You are holding it across the entire open, close, read, write, ioctl, and it is protecting a bunch of different things.
> +This locking is very heavy handed and should be reworked
> +
> +2) SLIC driver works unstable when compiled as module, loaded, then unloaded and finally reloaded again.
> +
> +3) Current version of Si3226x SLIC driver is limited. It implements only base functionality such as Answer, Hangup, receive DTMF, send DTMF, send Caller ID.

Please wrap your lines at 75 columns at the least, to make it readable.

Also, I need an email address in the TODO files as to who to cc: patches
to in order for them to be reviewed.

And really, these are the only reasons this driver isn't in the main
part of the kernel?  That last item shouldn't be a limiting factor, and
the other two aren't really an issue either, right?

I need a list here (and for the tdm core) of what is needed to be done
to get the code out of the staging tree, and email addresses and names
of people who are going to be responsible for doing this work.

Oh, and finally, why isn't this driver under the drivers/staging/tdm/
directory?

thanks,

greg k-h

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933876Ab3FSHVz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 03:21:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:33620 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756519Ab3FSHVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 03:21:54 -0400
MIME-Version: 1.0
In-Reply-To: <20130619171221.bedfb8f5c3c9819decc01edc@canb.auug.org.au>
References: <20130619153225.9ff68f0984bfa54333c4df10@canb.auug.org.au>
	<20130619171221.bedfb8f5c3c9819decc01edc@canb.auug.org.au>
Date: Wed, 19 Jun 2013 15:21:52 +0800
Message-ID: <CACVXFVNkbOjNMc+-WKBCuyYQHn=APTodTP1L_00TzQN59o4SCw@mail.gmail.com>
Subject: Re: linux-next: manual merge of the driver-core tree with the
 driver-core.current tree
From: Ming Lei <ming.lei@canonical.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 19, 2013 at 3:12 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Greg,
>
> On Wed, 19 Jun 2013 15:32:25 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>>
>> Today's linux-next merge of the driver-core tree got a conflict in
>> drivers/base/firmware_class.c between commit 875979368eb4 ("firmware
>> loader: fix use-after-free by double abort") from the driver-core.current
>> tree and commit fe304143b0c3 ("firmware: Avoid deadlock of usermodehelper
>> lock at shutdown") from the driver-core tree.
>>
>> I fixed it up (more may be required - see below) and can carry the fix as
>> necessary (no action is required).
>
> I missed the bit below (at least) and have now added this as a merge fix
> for the driver-core tree.

I think it is OK to merge, then I can add the 'more' part about the original
fix(875979368eb4) against today's change.

>
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Wed, 19 Jun 2013 17:08:01 +1000
> Subject: [PATCH] fix up for fw_load_abort API change
>
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  drivers/base/firmware_class.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
> index 57aa842..fdacd77 100644
> --- a/drivers/base/firmware_class.c
> +++ b/drivers/base/firmware_class.c
> @@ -812,7 +812,7 @@ static void firmware_class_timeout_work(struct work_struct *work)
>                         struct firmware_priv, timeout_work.work);
>
>         mutex_lock(&fw_lock);
> -       fw_load_abort(fw_priv);
> +       fw_load_abort(fw_priv->buf);
>         mutex_unlock(&fw_lock);
>  }
>
> --
> 1.8.1
>
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au

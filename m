Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002Ab3HAKJs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 06:09:48 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:50066 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039Ab3HAKJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 06:09:46 -0400
MIME-Version: 1.0
In-Reply-To: <1374153691-25100-2-git-send-email-nlopezcasad@logitech.com>
References: <1374153691-25100-1-git-send-email-nlopezcasad@logitech.com>
	<1374153691-25100-2-git-send-email-nlopezcasad@logitech.com>
Date: Thu, 1 Aug 2013 12:09:44 +0200
Message-ID: <CAN+gG=GcS7pfK9K5FuW9TyX+PJWNkXZWLk8UX9PzLXom2PSpgQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] HID: hid-logitech-dj, querying_devices was never set
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Nestor Lopez Casado <nlopezcasad@logitech.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Andrew de los Reyes <adlr@chromium.org>,
        joseph.salisbury@canonical.com,
        linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 18, 2013 at 3:21 PM, Nestor Lopez Casado
<nlopezcasad@logitech.com> wrote:
> Set querying_devices flag to true when we start the enumeration
> process.
>
> This was missing from the original patch. It never produced
> undesirable effects as it is highly improbable to have a second
> enumeration triggered while a first one was still in progress.
>
> Signed-off-by: Nestor Lopez Casado <nlopezcasad@logitech.com>
> ---
>  drivers/hid/hid-logitech-dj.c |    2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/hid/hid-logitech-dj.c b/drivers/hid/hid-logitech-dj.c
> index 0d13389..d4657a5 100644
> --- a/drivers/hid/hid-logitech-dj.c
> +++ b/drivers/hid/hid-logitech-dj.c
> @@ -488,6 +488,8 @@ static int logi_dj_recv_query_paired_devices(struct dj_receiver_dev *djrcv_dev)
>         if (djrcv_dev->querying_devices)
>                 return 0;
>
> +       djrcv_dev->querying_devices = true;
> +

Unfortunately, this breaks the fallback mechanism :(
We tried to add the two patches in Fedora [1], but this doesn't fix
the bug because the driver actually things that it already asked for
the enumeration, but as we get the -EPIPE error, the request was never
sent.

So, Jiri, if you were to submit that series to Linus (or Greg) for
fixing the bug, please just drop this second patch.

Cheers,
Benjamin

[1] https://bugzilla.redhat.com/show_bug.cgi?id=989138

>         dj_report = kzalloc(sizeof(struct dj_report), GFP_KERNEL);
>         if (!dj_report)
>                 return -ENOMEM;
> --
> 1.7.9.5
>

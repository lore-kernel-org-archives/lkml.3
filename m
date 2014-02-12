Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956AbaBLKbk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 05:31:40 -0500
Received: from mail-ig0-f178.google.com ([209.85.213.178]:61074 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbaBLKbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 05:31:34 -0500
MIME-Version: 1.0
In-Reply-To: <1392055139-19631-7-git-send-email-benjamin.tissoires@redhat.com>
References: <1392055139-19631-1-git-send-email-benjamin.tissoires@redhat.com>
	<1392055139-19631-7-git-send-email-benjamin.tissoires@redhat.com>
Date: Wed, 12 Feb 2014 11:31:33 +0100
Message-ID: <CANq1E4QZOKqst3Q19CvCpSWT81uDgBM_fVtiUeyp8gSEhT7zjQ@mail.gmail.com>
Subject: Re: [PATCH 06/14] HID: usbhid: change return error of usbhid_output_report
From: David Herrmann <dh.herrmann@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Mon, Feb 10, 2014 at 6:58 PM, Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
> If there is no urbout when sending a output report, ENOSYS (Function
> not implemented) is a better error than EIO (I/O error).

Reviewed-by: David Herrmann <dh.herrmann@gmail.com>

Thanks
David

> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> ---
>  drivers/hid/usbhid/hid-core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
> index b9a770f..0d1d875 100644
> --- a/drivers/hid/usbhid/hid-core.c
> +++ b/drivers/hid/usbhid/hid-core.c
> @@ -922,7 +922,7 @@ static int usbhid_output_report(struct hid_device *hid, __u8 *buf, size_t count)
>         int actual_length, skipped_report_id = 0, ret;
>
>         if (!usbhid->urbout)
> -               return -EIO;
> +               return -ENOSYS;
>
>         if (buf[0] == 0x0) {
>                 /* Don't send the Report ID */
> --
> 1.8.3.1
>

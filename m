Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751618AbaLPV4H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 16:56:07 -0500
Received: from mail-qg0-f46.google.com ([209.85.192.46]:63350 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429AbaLPV4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 16:56:05 -0500
MIME-Version: 1.0
In-Reply-To: <1418745323-17133-2-git-send-email-peter@lekensteyn.nl>
References: <CAN+gG=EL0kYim=_uaS4yj7c_XC8rKa1eELxpVXaOuvnWgT_eQw@mail.gmail.com>
	<1418745323-17133-1-git-send-email-peter@lekensteyn.nl>
	<1418745323-17133-2-git-send-email-peter@lekensteyn.nl>
Date: Tue, 16 Dec 2014 16:56:03 -0500
Message-ID: <CAN+gG=GbBourMyH5PcznOPB+wGsfC-Nsh_ea5h171fzpTc=O9Q@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] HID: logitech-hidpp: check WTP report length
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Peter Wu <peter@lekensteyn.nl>
Cc: Jiri Kosina <jkosina@suse.cz>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Nestor Lopez Casado <nlopezcasad@logitech.com>,
        linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2014 at 10:55 AM, Peter Wu <peter@lekensteyn.nl> wrote:
> Malicious USB devices can send bogus reports smaller than the expected
> buffer size. Ensure that the length for WTP reports is valid to avoid
> reading out of bounds.
>
> Signed-off-by: Peter Wu <peter@lekensteyn.nl>
> ---
>  v1: patch 2/3 HID: logitech-{dj,hidpp}: check report length
>  v2: splitted original report length check patch
> ---

Reviewed-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

Cheers,
Benjamin

>  drivers/hid/hid-logitech-hidpp.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
> index b32f751..2f1b0ac 100644
> --- a/drivers/hid/hid-logitech-hidpp.c
> +++ b/drivers/hid/hid-logitech-hidpp.c
> @@ -805,6 +805,11 @@ static int wtp_raw_event(struct hid_device *hdev, u8 *data, int size)
>
>         switch (data[0]) {
>         case 0x02:
> +               if (size < 2) {
> +                       hid_err(hdev, "Received HID report of bad size (%d)",
> +                               size);
> +                       return 1;
> +               }
>                 if (hidpp->quirks & HIDPP_QUIRK_WTP_PHYSICAL_BUTTONS) {
>                         input_event(wd->input, EV_KEY, BTN_LEFT,
>                                         !!(data[1] & 0x01));
> @@ -818,6 +823,7 @@ static int wtp_raw_event(struct hid_device *hdev, u8 *data, int size)
>                         return wtp_mouse_raw_xy_event(hidpp, &data[7]);
>                 }
>         case REPORT_ID_HIDPP_LONG:
> +               /* size is already checked in hidpp_raw_event. */
>                 if ((report->fap.feature_index != wd->mt_feature_index) ||
>                     (report->fap.funcindex_clientid != EVENT_TOUCHPAD_RAW_XY))
>                         return 1;
> --
> 2.1.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

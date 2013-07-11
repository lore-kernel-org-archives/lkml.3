Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756555Ab3GKWvP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 18:51:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36524 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756431Ab3GKWvN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 18:51:13 -0400
Date: Fri, 12 Jul 2013 00:51:12 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        David Herrmann <dh.herrmann@gmail.com>,
        linux-bluetooth@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Bluetooth: hidp: remove wrong send_report at init
In-Reply-To: <1373550090-30379-3-git-send-email-benjamin.tissoires@redhat.com>
Message-ID: <alpine.LNX.2.00.1307120050450.29788@pobox.suse.cz>
References: <1373550090-30379-1-git-send-email-benjamin.tissoires@redhat.com> <1373550090-30379-3-git-send-email-benjamin.tissoires@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Jul 2013, Benjamin Tissoires wrote:

> The USB hid implementation does retrieve the reports during the start.
> However, this implementation does not call the HID command GET_REPORT
> (which would fetch the current status of each report), but use the
> DATA command, which is an Output Report (so transmitting data from the
> host to the device).
> The Wiimote controller is already guarded against this problem in the
> protocol, but it is not conformant to the specification to set all the
> reports to 0 on start.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

Acked-by: Jiri Kosina <jkosina@suse.cz>

Gustavo, could you please take it through your tree?

Thanks Benjamin, thanks David.

> ---
>  net/bluetooth/hidp/core.c | 14 --------------
>  1 file changed, 14 deletions(-)
> 
> diff --git a/net/bluetooth/hidp/core.c b/net/bluetooth/hidp/core.c
> index 9c8b50d..59d132a 100644
> --- a/net/bluetooth/hidp/core.c
> +++ b/net/bluetooth/hidp/core.c
> @@ -703,20 +703,6 @@ static int hidp_parse(struct hid_device *hid)
>  
>  static int hidp_start(struct hid_device *hid)
>  {
> -	struct hidp_session *session = hid->driver_data;
> -	struct hid_report *report;
> -
> -	if (hid->quirks & HID_QUIRK_NO_INIT_REPORTS)
> -		return 0;
> -
> -	list_for_each_entry(report, &hid->report_enum[HID_INPUT_REPORT].
> -			report_list, list)
> -		hidp_send_report(session, report);
> -
> -	list_for_each_entry(report, &hid->report_enum[HID_FEATURE_REPORT].
> -			report_list, list)
> -		hidp_send_report(session, report);
> -
>  	return 0;
>  }
>  
> -- 
> 1.8.3.1
> 

-- 
Jiri Kosina
SUSE Labs

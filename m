Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933855Ab3GRTXJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 15:23:09 -0400
Received: from smtprelay-b31.telenor.se ([213.150.131.20]:47149 "EHLO
	smtprelay-b31.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933281Ab3GRTXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 15:23:07 -0400
X-SENDER-IP: [85.230.171.181]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ak1mANA/6FFV5qu1PGdsb2JhbABagwaDIoUjuH8EAYESFwMBAQEBODWCJAEBBAEnExwjBQsIAyElDwUlChoTiAoKtiwWjlyBHQeDDm4Dl1yGM44vOg
X-IronPort-AV: E=Sophos;i="4.89,695,1367964000"; 
   d="scan'208";a="364813363"
From: rydberg@euromail.se
Date: Thu, 18 Jul 2013 21:24:16 +0200
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Stephane Chatty <chatty@enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: multitouch: do not init reports for multitouch
 devices
Message-ID: <20130718192416.GA526@polaris.bitmath.org>
References: <1373620101-16113-1-git-send-email-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373620101-16113-1-git-send-email-benjamin.tissoires@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

> Some multitouch screens do not like to be polled for input reports.
> However, the Win8 spec says that all touches should be sent during
> each report, making the initialization of reports unnecessary.
> The Win7 spec is less precise, but we can safely assume that when
> the module is loaded (at boot), no one is touching the screen.
> 
> Add the quirk HID_QUIRK_NO_INIT_REPORTS so that we do not have to
> introduce a quirk for each problematic device.

I assume you have tested thoroughly for regressions? How about odd
eGalax devices, for instance? Changes affecting existing hardware
makes me nervous. Is it so bad to add this quirk on a per-device
basis? Or perhaps turned on by default for win8 devices only?

> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> ---
>  drivers/hid/hid-multitouch.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
> index d99b959..197c2e6 100644
> --- a/drivers/hid/hid-multitouch.c
> +++ b/drivers/hid/hid-multitouch.c
> @@ -957,6 +957,15 @@ static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
>  	hdev->quirks |= HID_QUIRK_NO_INPUT_SYNC;
>  
>  	/*
> +	 * Some multitouch screens do not like to be polled for input reports.
> +	 * However, the Win8 spec says that all touches should be sent during
> +	 * each report, making the initialization of reports unnecessary.
> +	 * The Win7 spec is less precise, but we can safely assume that when
> +	 * the module is loaded (at boot), no one is touching the screen.
> +	 */
> +	hdev->quirks |= HID_QUIRK_NO_INIT_REPORTS;
> +
> +	/*
>  	 * This allows the driver to handle different input sensors
>  	 * that emits events through different reports on the same HID
>  	 * device.
> -- 
> 1.8.3.1
> 

Thanks,
Henrik

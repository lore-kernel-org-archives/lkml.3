Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753674Ab3KPAWS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 19:22:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34472 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752148Ab3KPAWE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 19:22:04 -0500
Date: Sat, 16 Nov 2013 01:21:56 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: James Henstridge <james.henstridge@canonical.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Luis Henriques <luis.henriques@canonical.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        =?ISO-8859-15?Q?Fabien_Andr=E9?= <fabien.andre@gmail.com>,
        Bastien Nocera <hadess@hadess.net>
Subject: Re: [appleir] BUG: unable to handle kernel NULL pointer
 dereference
In-Reply-To: <527BB695.9040209@redhat.com>
Message-ID: <alpine.LRH.2.00.1311160121310.24147@twin.jikos.cz>
References: <20131029145139.GA2788@hercules> <alpine.LNX.2.00.1311061635160.835@pobox.suse.cz> <CALcaVO=jOEqCwLCMUgEkFJMcc4H6bMLU4yvjo1fJ7DeXgkZH6A@mail.gmail.com> <527BB695.9040209@redhat.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Nov 2013, Benjamin Tissoires wrote:

> Ok, thanks for the report. Could you please test the following patch
> which should solve your problem (hopefully)?

James, do you happen to have testing results please?

> 
> Cheers,
> Benjamin
> 
> --
> 
> >From 54b332b992da1666abe7180b6cecd313c864e0b7 Mon Sep 17 00:00:00 2001
> From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> Date: Thu, 7 Nov 2013 10:46:48 -0500
> Subject: [PATCH] HID: appleir: force input to be set
> 
> Some weird remotes are not correctly creating the input device. Their
> report descriptor starts with:
> 0x06, 0x00, 0xff,              // Usage Page (Vendor Defined Page 1)  0
> 0xa1, 0x01,                    // Collection (Application)            3
> 
> whereas others (which are correctly handled) start with:
> 0x05, 0x0c,                    // Usage Page (Consumer Devices)       0
> 0x09, 0x01,                    // Usage (Consumer Control)            2
> 0xa1, 0x01,                    // Collection (Application)            4
> 
> The rest of the report descriptor is the same.
> 
> Adding the quirk HID_QUIRK_HIDINPUT_FORCE forces hid-input to allocate
> the inputs, and everything should be ok.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> ---
>  drivers/hid/hid-appleir.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/hid/hid-appleir.c b/drivers/hid/hid-appleir.c
> index a42e6a3..0e6a42d 100644
> --- a/drivers/hid/hid-appleir.c
> +++ b/drivers/hid/hid-appleir.c
> @@ -297,6 +297,9 @@ static int appleir_probe(struct hid_device *hid, const struct hid_device_id *id)
>  
>  	appleir->hid = hid;
>  
> +	/* force input as some remotes bypass the input registration */
> +	hid->quirks |= HID_QUIRK_HIDINPUT_FORCE;
> +
>  	spin_lock_init(&appleir->lock);
>  	setup_timer(&appleir->key_up_timer,
>  		    key_up_tick, (unsigned long) appleir);
> 

-- 
Jiri Kosina
SUSE Labs


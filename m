Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935386AbaH1F5J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 01:57:09 -0400
Received: from smtprelay.restena.lu ([158.64.1.62]:44088 "EHLO
	smtprelay.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756921AbaH1F5I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 01:57:08 -0400
Date: Thu, 28 Aug 2014 07:57:04 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] HID: picolcd: sanity check report size in
 raw_event() callback
Message-ID: <20140828075704.3207e228@pluto>
In-Reply-To: <alpine.LNX.2.00.1408272331250.21233@pobox.suse.cz>
References: <alpine.LNX.2.00.1408270911130.2992@pobox.suse.cz>
	<alpine.LNX.2.00.1408270912310.2992@pobox.suse.cz>
	<20140827101311.098f3fd1@pluto>
	<alpine.LNX.2.00.1408271025040.2992@pobox.suse.cz>
	<alpine.LNX.2.00.1408272331250.21233@pobox.suse.cz>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Aug 2014 23:32:00 +0200 (CEST) Jiri Kosina wrote:
> On Wed, 27 Aug 2014, Jiri Kosina wrote:
> 
> > > Is it worth adding report->id to this hid_warn()?
> > > 
> > > A valid device is not expected to ever send >64 bytes reports but in
> > > case a firmware update would do so it would help to know for which
> > > report it was.
> > 
> > It definitely wouldn't hurt. Pull request with the original patch is now 
> > on its way to Linus though, so let's do this as a followup patch on top 
> > once this is merged.
> 
> I've just queued the below for 3.18.

Looks good,
Thanks

Bruno

> From: Jiri Kosina <jkosina@suse.cz>
> Subject: [PATCH] HID: picolcd: be more verbose when reporting report size error
> 
> picolcd device is not expected to send any report with size larger than 64 
> bytes.
> 
> If this impossible event happens (sic!), print also a report ID to allow 
> for easier debugging.
> 
> Suggested-by: Bruno Prémont <bonbons@linux-vserver.org>
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> ---
>  drivers/hid/hid-picolcd_core.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/hid/hid-picolcd_core.c b/drivers/hid/hid-picolcd_core.c
> index 020df3c..c1b29a9 100644
> --- a/drivers/hid/hid-picolcd_core.c
> +++ b/drivers/hid/hid-picolcd_core.c
> @@ -351,8 +351,8 @@ static int picolcd_raw_event(struct hid_device *hdev,
>  		return 1;
>  
>  	if (size > 64) {
> -		hid_warn(hdev, "invalid size value (%d) for picolcd raw event\n",
> -				size);
> +		hid_warn(hdev, "invalid size value (%d) for picolcd raw event (%d)\n",
> +				size, report->id);
>  		return 0;
>  	}
>  

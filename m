Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756602AbaKSTXr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 14:23:47 -0500
Received: from mail-la0-f50.google.com ([209.85.215.50]:47683 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755995AbaKSTXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 14:23:34 -0500
MIME-Version: 1.0
In-Reply-To: <20141119183921.GF37989@dtor-ws>
References: <20141114222640.GA39748@dtor-ws>
	<CAN+gG=FaovQETa3+qQsLoBBQnbZ8Q2uoQJD6_XvAmCCvGTHT1g@mail.gmail.com>
	<CAJBHPojp7JVG6KKgrNfbC-V5ibPs-j6+BnqrSDkxvak0vNGM8w@mail.gmail.com>
	<20141119181247.GE37989@dtor-ws>
	<CAJBHPohu71BXqyZ4u74tAiP84UcQhXgto34k8NtNHPgw61WvLQ@mail.gmail.com>
	<20141119183921.GF37989@dtor-ws>
Date: Wed, 19 Nov 2014 20:23:32 +0100
Message-ID: <CAJBHPog3qRMQgNnso_csUOgR30A6eFPx4PkTzfCzkB3Gd5oVfQ@mail.gmail.com>
Subject: Re: [git pull] Input updates for 3.18-rc4
From: Marcus Overhagen <marcus.overhagen@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Ulrik De Bie <ulrik.debie-os@e2big.org>,
        Hans de Goede <hdegoede@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-input <linux-input@vger.kernel.org>,
        Jiri Kosina <jkosina@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

luckily I found some time right now. I haven't reverted the original large
patch, but I tested your short patch and it fixes the problem for me.

regards
Marcus

On Wed, Nov 19, 2014 at 7:39 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On Wed, Nov 19, 2014 at 07:20:21PM +0100, Marcus Overhagen wrote:
>> Hi,
>>
>> I will try reverting that, but may need until tomorrow or Friday.
>>
>> Just now I made a warm reboot from rc3 to rc5 and initially scrolling
>> behaviour was ok,  but after about a minute it went wrong and I got
>> this:
>>
>> [  179.705362] ------------[ cut here ]------------
>> [  179.705382] WARNING: CPU: 3 PID: 0 at
>> drivers/input/mouse/elantech.c:433
>> elantech_report_trackpoint.isra.5+0x199/0x1b0 [psmouse]()
>> [  179.705385] psmouse serio1: elantech: Unexpected trackpoint message
>
> Or just this for now:
>
> diff --git a/drivers/input/mouse/elantech.c b/drivers/input/mouse/elantech.c
> index 3fcb6b3..294f613 100644
> --- a/drivers/input/mouse/elantech.c
> +++ b/drivers/input/mouse/elantech.c
> @@ -793,7 +793,7 @@ static int elantech_packet_check_v4(struct psmouse *psmouse)
>         unsigned char packet_type = packet[3] & 0x03;
>         bool sanity_check;
>
> -       if ((packet[3] & 0x0f) == 0x06)
> +       if ((packet[3] & 0x0f) == 0x06 && etd->tp_dev)
>                 return PACKET_TRACKPOINT;
>
>         /*
>
> --
> Dmitry

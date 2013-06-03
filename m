Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759490Ab3FCSKB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 14:10:01 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:60503 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757202Ab3FCSJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 14:09:59 -0400
MIME-Version: 1.0
In-Reply-To: <51ACD600.2020805@message-id.googlemail.com>
References: <51ACD4B2.7070107@message-id.googlemail.com>
	<51ACD600.2020805@message-id.googlemail.com>
Date: Mon, 3 Jun 2013 21:09:58 +0300
X-Google-Sender-Auth: 7D1jLxrsF99PTi409VFH8IF3GV8
Message-ID: <CA+i0qc4eEDjygde4+frqd51JutTDeoJ8mTp-K==gwG_7ghJwcw@mail.gmail.com>
Subject: Re: INTEL_MEI_ME=y breaks suspend on 3.10-rc3
From: Tomas Winkler <tomas.winkler@intel.com>
To: Stefan Seyfried <stefan.seyfried@googlemail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> > Or, to be more precise: it breaks resume.
> >
> > The machine seems to lock up hard after resume, then after a few seconds
> > it panics (caps lock blinking).
> >
> > Reproduced on ThinkPad X200s
> >
> > 00:03.0 0780: 8086:2a44 (rev 07)
> > Intel Corporation Mobile 4 Series Chipset MEI Controller
> >
> > Debugged with "init=/bin/bash no_console_suspend", I see lots of errors
> > from the mei_me driver, then finally the panic (some overflow maybe?).
> >
> > Unbinding the device before suspend fixes resume.
>
> I just noticed that I get the following message on unbinding:
>
> $ echo 0000:00:03.0 > /sys/bus/pci/drivers/mei_me/unbind
> $ dmesg|tail -2
> [ 1216.830034] mei_me 0000:00:03.0: stop
> [ 1216.837018] mei_me 0000:00:03.0: wait hw ready failed. status = 0x0
>
> not sure if this is related.
>
Thanks for the report I'm looking into it.

Thanks
Tomas

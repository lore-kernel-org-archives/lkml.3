Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474AbaHFJKq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 05:10:46 -0400
Received: from mail-oi0-f47.google.com ([209.85.218.47]:52533 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426AbaHFJKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 05:10:44 -0400
MIME-Version: 1.0
In-Reply-To: <CAKocOOO+vahGqVtM-hE6Vp5P2vX83L+z+OVnP=ZHvE4nc9P-JQ@mail.gmail.com>
References: <14048583172593@kroah.com> <8B2F6FFD0BD1E448853114367400A37306FD6FBBE9@BLRX7MCDC203.AMER.DELL.COM>
 <s5h38e9mg5v.wl%tiwai@suse.de> <8B2F6FFD0BD1E448853114367400A37306FD6FBBF8@BLRX7MCDC203.AMER.DELL.COM>
 <s5hy4w1l0s3.wl%tiwai@suse.de> <8B2F6FFD0BD1E448853114367400A37306FD6FBC06@BLRX7MCDC203.AMER.DELL.COM>
 <s5hpphdkyi6.wl%tiwai@suse.de> <8B2F6FFD0BD1E448853114367400A37306FD6FBDAB@BLRX7MCDC203.AMER.DELL.COM>
 <s5hoawvkimg.wl%tiwai@suse.de> <8B2F6FFD0BD1E448853114367400A37306FE07C773@BLRX7MCDC203.AMER.DELL.COM>
 <s5h7g3frmg7.wl%tiwai@suse.de> <8B2F6FFD0BD1E448853114367400A37306FE07CC64@BLRX7MCDC203.AMER.DELL.COM>
 <s5hlhrrizbq.wl%tiwai@suse.de> <8B2F6FFD0BD1E448853114367400A37306FE311D74@BLRX7MCDC203.AMER.DELL.COM>
 <CAL8zT=jDUyxjimFxBFk56q+B9VwZdnijrU9VF7LBm4X4mNKp+g@mail.gmail.com>
 <s5hvbq753w2.wl%tiwai@suse.de> <CAL8zT=jzFmPZ2jizrPXMGBwNReOnDw7wLHZDashavNBh9vhe2g@mail.gmail.com>
 <s5htx5r53jl.wl%tiwai@suse.de> <CAKocOOO+vahGqVtM-hE6Vp5P2vX83L+z+OVnP=ZHvE4nc9P-JQ@mail.gmail.com>
From: Jean-Michel Hautbois <jhautbois@gmail.com>
Date: Wed, 6 Aug 2014 11:10:27 +0200
Message-ID: <CAL8zT=gbqcGPMLKS+bkc3cJPJJGmzuvdr7owy+zF-bCCaEv-Gg@mail.gmail.com>
Subject: Re: patch "firmware loader: allow disabling of udev as firmware
 loader" added to driver-core tree
To: Shuah Khan <shuahkhan@gmail.com>
Cc: Takashi Iwai <tiwai@suse.de>, B_B_Singh@dell.com,
        Greg KH <gregkh@linuxfoundation.org>, Abhay_Salunke@dell.com,
        Arnd Bergmann <arnd@arndb.de>, Kay Sievers <kay@vrfy.org>,
        Ming Lei <ming.lei@canonical.com>, Stefan Roese <sr@denx.de>,
        Tom Gundersen <teg@jklm.no>, Stuart_Hayes@dell.com,
        Srinivas_G_Gowda@dell.com, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-08-05 21:22 GMT+02:00 Shuah Khan <shuahkhan@gmail.com>:
> On Tue, Aug 5, 2014 at 10:01 AM, Takashi Iwai <tiwai@suse.de> wrote:
>>> Yes, it worked, if the firmware was in the /lib/firmware directory.
>>
>
> ok it works when the firmware is in /lib/firmware. It sounds to me the
> reason load fails when the firmware is under /sys/class/firmware is
> fw_load_from_user_helper() returns -ENOENT when
> CONFIG_FW_LOADER_USER_HELPER is disabled.
>
> It would be nice to see the entire dmesg with debug enabled though.
>
> -- Shuah

It does not work with the 3.16 kernel even when firmware is in
/lib/firmware, it worked before this patch is applied.
Here is what I got in my dmesg :
[    0.307856] __allocate_fw_buf: fw-lattice-ecp3.bit buf=bd81a480
[    0.308029] lattice-ecp3 spi2.3: Direct firmware load for
lattice-ecp3.bit failed with error -2
[    0.308078] __fw_free_buf: fw-lattice-ecp3.bit buf=bd81a480 data=
(null) size=0
[    0.308094] lattice-ecp3 spi2.3: Cannot load firmware, aborting

If you want specific messages, please tell me.

Thanks,
JM

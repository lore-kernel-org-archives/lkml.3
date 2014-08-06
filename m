Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755703AbaHFKup (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 06:50:45 -0400
Received: from mail-oi0-f48.google.com ([209.85.218.48]:39538 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755551AbaHFKuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 06:50:44 -0400
MIME-Version: 1.0
In-Reply-To: <s5h7g2l6hq6.wl%tiwai@suse.de>
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
 <CAL8zT=gbqcGPMLKS+bkc3cJPJJGmzuvdr7owy+zF-bCCaEv-Gg@mail.gmail.com>
 <s5hd2ce55sl.wl%tiwai@suse.de> <CAL8zT=hbwRXRP7yNbrh9BEYzqAyipkTmrFCSqM5Z0U8hr0Yz+g@mail.gmail.com>
 <s5h7g2l6hq6.wl%tiwai@suse.de>
From: Jean-Michel Hautbois <jhautbois@gmail.com>
Date: Wed, 6 Aug 2014 12:50:28 +0200
Message-ID: <CAL8zT=j6DJ_JX7OT7csmuQPQj2AnwDxDvtBtui-i4PTbeGwmWw@mail.gmail.com>
Subject: Re: patch "firmware loader: allow disabling of udev as firmware
 loader" added to driver-core tree
To: Takashi Iwai <tiwai@suse.de>
Cc: Shuah Khan <shuahkhan@gmail.com>, B_B_Singh@dell.com,
        Greg KH <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>,
        Kay Sievers <kay@vrfy.org>, Ming Lei <ming.lei@canonical.com>,
        Stefan Roese <sr@denx.de>, Tom Gundersen <teg@jklm.no>,
        Stuart_Hayes@dell.com, Srinivas_G_Gowda@dell.com,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-08-06 12:21 GMT+02:00 Takashi Iwai <tiwai@suse.de>:
> At Wed, 6 Aug 2014 11:44:14 +0200,
> Jean-Michel Hautbois wrote:
>>
>> 2014-08-06 11:24 GMT+02:00 Takashi Iwai <tiwai@suse.de>:
>> > At Wed, 6 Aug 2014 11:10:27 +0200,
>> > Jean-Michel Hautbois wrote:
>> >>
>> >> 2014-08-05 21:22 GMT+02:00 Shuah Khan <shuahkhan@gmail.com>:
>> >> > On Tue, Aug 5, 2014 at 10:01 AM, Takashi Iwai <tiwai@suse.de> wrote:
>> >> >>> Yes, it worked, if the firmware was in the /lib/firmware directory.
>> >> >>
>> >> >
>> >> > ok it works when the firmware is in /lib/firmware. It sounds to me the
>> >> > reason load fails when the firmware is under /sys/class/firmware is
>> >> > fw_load_from_user_helper() returns -ENOENT when
>> >> > CONFIG_FW_LOADER_USER_HELPER is disabled.
>> >> >
>> >> > It would be nice to see the entire dmesg with debug enabled though.
>> >> >
>> >> > -- Shuah
>> >>
>> >> It does not work with the 3.16 kernel even when firmware is in
>> >> /lib/firmware, it worked before this patch is applied.
>> >
>> > Hm?  3.16 doesn't contain my patch yet.  It's merged for 3.17-rc1.
>>
>> Oh, you are right of course, I am on upstream kernel and I have your
>> patch. I don't mean your match is causing the issue though ;-).
>
> I see.
>
>> >> Here is what I got in my dmesg :
>> >> [    0.307856] __allocate_fw_buf: fw-lattice-ecp3.bit buf=bd81a480
>> >> [    0.308029] lattice-ecp3 spi2.3: Direct firmware load for
>> >> lattice-ecp3.bit failed with error -2
>> >
>> > It's -ENOENT.  Are you sure that you really have
>> >  /lib/firmware/lattice-ecp3.bit file?
>>
>> Yes :
>> ls -al /lib/firmware/lattice-ecp3.bit
>> -rwxr-xr-x 1 root root 897753 Aug  5 15:04 /lib/firmware/lattice-ecp3.bit
>
> Then you'd better bisect...
> Or, at least, put a debug code to see which file is opened in the loop
> in fw_get_filesystem_firmware().

Well, when this function is called, my rootfs is not yet mounted (I
have a dedicated partition on a SDCard)...
So I probably missed a step in order to get /lib/firmware before / is
mounted... ?

JM

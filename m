Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932219AbaHFTAa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 15:00:30 -0400
Received: from mail-yh0-f52.google.com ([209.85.213.52]:42382 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932077AbaHFTAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 15:00:25 -0400
MIME-Version: 1.0
In-Reply-To: <CAL8zT=hbwRXRP7yNbrh9BEYzqAyipkTmrFCSqM5Z0U8hr0Yz+g@mail.gmail.com>
References: <14048583172593@kroah.com>
	<8B2F6FFD0BD1E448853114367400A37306FD6FBBE9@BLRX7MCDC203.AMER.DELL.COM>
	<s5h38e9mg5v.wl%tiwai@suse.de>
	<8B2F6FFD0BD1E448853114367400A37306FD6FBBF8@BLRX7MCDC203.AMER.DELL.COM>
	<s5hy4w1l0s3.wl%tiwai@suse.de>
	<8B2F6FFD0BD1E448853114367400A37306FD6FBC06@BLRX7MCDC203.AMER.DELL.COM>
	<s5hpphdkyi6.wl%tiwai@suse.de>
	<8B2F6FFD0BD1E448853114367400A37306FD6FBDAB@BLRX7MCDC203.AMER.DELL.COM>
	<s5hoawvkimg.wl%tiwai@suse.de>
	<8B2F6FFD0BD1E448853114367400A37306FE07C773@BLRX7MCDC203.AMER.DELL.COM>
	<s5h7g3frmg7.wl%tiwai@suse.de>
	<8B2F6FFD0BD1E448853114367400A37306FE07CC64@BLRX7MCDC203.AMER.DELL.COM>
	<s5hlhrrizbq.wl%tiwai@suse.de>
	<8B2F6FFD0BD1E448853114367400A37306FE311D74@BLRX7MCDC203.AMER.DELL.COM>
	<CAL8zT=jDUyxjimFxBFk56q+B9VwZdnijrU9VF7LBm4X4mNKp+g@mail.gmail.com>
	<s5hvbq753w2.wl%tiwai@suse.de>
	<CAL8zT=jzFmPZ2jizrPXMGBwNReOnDw7wLHZDashavNBh9vhe2g@mail.gmail.com>
	<s5htx5r53jl.wl%tiwai@suse.de>
	<CAKocOOO+vahGqVtM-hE6Vp5P2vX83L+z+OVnP=ZHvE4nc9P-JQ@mail.gmail.com>
	<CAL8zT=gbqcGPMLKS+bkc3cJPJJGmzuvdr7owy+zF-bCCaEv-Gg@mail.gmail.com>
	<s5hd2ce55sl.wl%tiwai@suse.de>
	<CAL8zT=hbwRXRP7yNbrh9BEYzqAyipkTmrFCSqM5Z0U8hr0Yz+g@mail.gmail.com>
Date: Wed, 6 Aug 2014 13:00:24 -0600
Message-ID: <CAKocOOOXAPR4-K2pLDABsC=Gpohct+zZ9p+3FNp4_dUfT-2BkQ@mail.gmail.com>
Subject: Re: patch "firmware loader: allow disabling of udev as firmware
 loader" added to driver-core tree
From: Shuah Khan <shuahkhan@gmail.com>
To: Jean-Michel Hautbois <jhautbois@gmail.com>
Cc: Takashi Iwai <tiwai@suse.de>, B_B_Singh@dell.com,
        Greg KH <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>,
        Kay Sievers <kay@vrfy.org>, Ming Lei <ming.lei@canonical.com>,
        Stefan Roese <sr@denx.de>, Tom Gundersen <teg@jklm.no>,
        Stuart_Hayes@dell.com, Srinivas_G_Gowda@dell.com,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 6, 2014 at 3:44 AM, Jean-Michel Hautbois
<jhautbois@gmail.com> wrote:
> 2014-08-06 11:24 GMT+02:00 Takashi Iwai <tiwai@suse.de>:
>> At Wed, 6 Aug 2014 11:10:27 +0200,
>> Jean-Michel Hautbois wrote:
>>>
>>> 2014-08-05 21:22 GMT+02:00 Shuah Khan <shuahkhan@gmail.com>:
>>> > On Tue, Aug 5, 2014 at 10:01 AM, Takashi Iwai <tiwai@suse.de> wrote:
>>> >>> Yes, it worked, if the firmware was in the /lib/firmware directory.
>>> >>
>>> >
>>> > ok it works when the firmware is in /lib/firmware. It sounds to me the
>>> > reason load fails when the firmware is under /sys/class/firmware is
>>> > fw_load_from_user_helper() returns -ENOENT when
>>> > CONFIG_FW_LOADER_USER_HELPER is disabled.
>>> >
>>> > It would be nice to see the entire dmesg with debug enabled though.
>>> >
>>> > -- Shuah
>>>
>>> It does not work with the 3.16 kernel even when firmware is in
>>> /lib/firmware, it worked before this patch is applied.
>>
>> Hm?  3.16 doesn't contain my patch yet.  It's merged for 3.17-rc1.
>
> Oh, you are right of course, I am on upstream kernel and I have your
> patch. I don't mean your match is causing the issue though ;-).
>

I think this is what is going on and this patch is the cause:
fw_load_from_user_helper() is a stub that returns -ENOENT with this
patch. As a result, in _request_firmware() after fw_get_filesystem_firmware()
fails to find the file, fw_load_from_user_helper() gets called and it
returns right
away with -ENOENT.

In some cases if rootfs mount is in progress, fw_load_from_user_helper()
steps into load the firmware.

A quick way to test is by adding a dev_info() in the fw_load_from_user_helper()
and see if that is path it is taking.

-- Shuah

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932363AbaHGNXu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 09:23:50 -0400
Received: from mail-yk0-f173.google.com ([209.85.160.173]:34127 "EHLO
	mail-yk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932082AbaHGNXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 09:23:48 -0400
MIME-Version: 1.0
In-Reply-To: <s5hegws3f6m.wl%tiwai@suse.de>
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
	<CAKocOOOXAPR4-K2pLDABsC=Gpohct+zZ9p+3FNp4_dUfT-2BkQ@mail.gmail.com>
	<s5hegws3f6m.wl%tiwai@suse.de>
Date: Thu, 7 Aug 2014 07:23:47 -0600
Message-ID: <CAKocOONv97=XvciQCT3qJ-e01YVGmJsz0e-N9P2iJrsBw8eeCQ@mail.gmail.com>
Subject: Re: patch "firmware loader: allow disabling of udev as firmware
 loader" added to driver-core tree
From: Shuah Khan <shuahkhan@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Jean-Michel Hautbois <jhautbois@gmail.com>, B_B_Singh@dell.com,
        Greg KH <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>,
        Kay Sievers <kay@vrfy.org>, Ming Lei <ming.lei@canonical.com>,
        Stefan Roese <sr@denx.de>, Tom Gundersen <teg@jklm.no>,
        Stuart_Hayes@dell.com, Srinivas_G_Gowda@dell.com,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 7, 2014 at 1:57 AM, Takashi Iwai <tiwai@suse.de> wrote:
>> >> Hm?  3.16 doesn't contain my patch yet.  It's merged for 3.17-rc1.
>> >
>> > Oh, you are right of course, I am on upstream kernel and I have your
>> > patch. I don't mean your match is causing the issue though ;-).
>> >
>>
>> I think this is what is going on and this patch is the cause:
>> fw_load_from_user_helper() is a stub that returns -ENOENT with this
>> patch.
>
> ... unless specifying the new Kconfig
> CONFIG_FW_LOADER_USER_HELPER_FALLBACK=y.  This is exactly the purpose
> of the commit.

Right - I figured that is the intent.

>
>> As a result, in _request_firmware() after fw_get_filesystem_firmware()
>> fails to find the file, fw_load_from_user_helper() gets called and it
>> returns right
>> away with -ENOENT.
>>
>> In some cases if rootfs mount is in progress, fw_load_from_user_helper()
>> steps into load the firmware.
>
> When a module in initrd requires a firmware, it should be put in
> initrd, too.

Right. This is something drivers have to watch out for with this change.

-- Shuah

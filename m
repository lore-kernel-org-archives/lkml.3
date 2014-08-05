Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378AbaHEPz5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 11:55:57 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:48512 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755176AbaHEPzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 11:55:55 -0400
MIME-Version: 1.0
In-Reply-To: <s5hvbq753w2.wl%tiwai@suse.de>
References: <14048583172593@kroah.com> <8B2F6FFD0BD1E448853114367400A37306FD6FBBE9@BLRX7MCDC203.AMER.DELL.COM>
 <s5h38e9mg5v.wl%tiwai@suse.de> <8B2F6FFD0BD1E448853114367400A37306FD6FBBF8@BLRX7MCDC203.AMER.DELL.COM>
 <s5hy4w1l0s3.wl%tiwai@suse.de> <8B2F6FFD0BD1E448853114367400A37306FD6FBC06@BLRX7MCDC203.AMER.DELL.COM>
 <s5hpphdkyi6.wl%tiwai@suse.de> <8B2F6FFD0BD1E448853114367400A37306FD6FBDAB@BLRX7MCDC203.AMER.DELL.COM>
 <s5hoawvkimg.wl%tiwai@suse.de> <8B2F6FFD0BD1E448853114367400A37306FE07C773@BLRX7MCDC203.AMER.DELL.COM>
 <s5h7g3frmg7.wl%tiwai@suse.de> <8B2F6FFD0BD1E448853114367400A37306FE07CC64@BLRX7MCDC203.AMER.DELL.COM>
 <s5hlhrrizbq.wl%tiwai@suse.de> <8B2F6FFD0BD1E448853114367400A37306FE311D74@BLRX7MCDC203.AMER.DELL.COM>
 <CAL8zT=jDUyxjimFxBFk56q+B9VwZdnijrU9VF7LBm4X4mNKp+g@mail.gmail.com> <s5hvbq753w2.wl%tiwai@suse.de>
From: Jean-Michel Hautbois <jhautbois@gmail.com>
Date: Tue, 5 Aug 2014 17:55:40 +0200
Message-ID: <CAL8zT=jzFmPZ2jizrPXMGBwNReOnDw7wLHZDashavNBh9vhe2g@mail.gmail.com>
Subject: Re: patch "firmware loader: allow disabling of udev as firmware
 loader" added to driver-core tree
To: Takashi Iwai <tiwai@suse.de>
Cc: B_B_Singh@dell.com, Greg KH <gregkh@linuxfoundation.org>,
        Abhay_Salunke@dell.com, Arnd Bergmann <arnd@arndb.de>, kay@vrfy.org,
        ming.lei@canonical.com, Stefan Roese <sr@denx.de>, teg@jklm.no,
        Stuart_Hayes@dell.com, Srinivas_G_Gowda@dell.com,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-08-05 17:53 GMT+02:00 Takashi Iwai <tiwai@suse.de>:
> At Tue, 5 Aug 2014 17:43:17 +0200,
> Jean-Michel Hautbois wrote:
>>
>> 2014-08-01 22:01 GMT+02:00  <B_B_Singh@dell.com>:
>> > Hi Takashi,
>> >
>> > Sorry for the late response,  I tried with latest stable kernel 3.15.8.  surprisingly the BIOS update works even without applying the patch in both the cases.
>>
>> Hi,I'm sorry for my late answer too, but I didn't try this patch recently...
>>
>> I have a Lattice FPGA on my board, and it seems that your patch breaks
>> the firmware loading.
>> I have the following config :
>> CONFIG_FW_LOADER=y
>> CONFIG_FW_LOADER_USER_HELPER=n
>> FW_LOADER_USER_HELPER_FALLBACK=n
>> LATTICE_ECP3_CONFIG=y
>
> It worked before applying my patch properly...?
>
> The kernel Oops itself is a bug in lattice-ecp3-config driver.
> It blindly assumes that the returned firmware is non-NULL.
> firmware_load() must have a NULL check of fw at the beginning.
>
>
> thanks,
>
> Takashi

Yes, it worked, if the firmware was in the /lib/firmware directory.
You are right, it lacks a NULL check, I will fix that.

Thanks,
JM

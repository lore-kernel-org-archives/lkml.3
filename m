Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348Ab3HDBrQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Aug 2013 21:47:16 -0400
Received: from mail-wg0-f53.google.com ([74.125.82.53]:39656 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639Ab3HDBrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Aug 2013 21:47:13 -0400
MIME-Version: 1.0
In-Reply-To: <CAMP44s3kacF57gsJzyL6-4JWfWpdfJbJYW-nWQ92Yn1VimnYug@mail.gmail.com>
References: <1375472229-1563-1-git-send-email-felipe.contreras@gmail.com>
	<13505759.IqzsRNCUnN@vostro.rjw.lan>
	<CAMP44s1SobAmSwth+=-pHYN77u-yEumqMfes1w3Bj-8sLTpWng@mail.gmail.com>
	<2483450.yz2brWbP8X@vostro.rjw.lan>
	<CAMP44s3kacF57gsJzyL6-4JWfWpdfJbJYW-nWQ92Yn1VimnYug@mail.gmail.com>
Date: Sun, 4 Aug 2013 09:47:12 +0800
Message-ID: <CAOzJMDQwte=7VtfQzW9DyQpt+pbe48STDEGhLis62Y0tG78G1w@mail.gmail.com>
Subject: Re: [PATCH] acpi: video: improve quirk check
From: Aaron Lu <aaron.lwe@gmail.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        linux-acpi@vger.kernel.org, Len Brown <lenb@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 4, 2013 at 6:20 AM, Felipe Contreras
<felipe.contreras@gmail.com> wrote:
> On Sat, Aug 3, 2013 at 4:40 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> On Saturday, August 03, 2013 03:24:16 PM Felipe Contreras wrote:
>>> On Sat, Aug 3, 2013 at 6:34 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>>> > On Saturday, August 03, 2013 04:14:04 PM Aaron Lu wrote:
>>>
>>> >> Yes, the patch is correct, but I still prefer my own version :-)
>>> >> https://github.com/aaronlu/linux/commit/0a3d2c5b59caf80ae5bb1ca1fda0f7bf448b38c9
>>> >>
>>> >> In case you want to take mine and mine needs refresh, please let me know
>>> >> and I can do the re-base, thanks.
>>> >
>>> > Well, I prefer simpler, unless there's a good reason to use more complicated.
>>>
>>> Note that these are not exclusionary; his patch can be applied on top
>>> of mine. I don't think his patch is needed though.
>>
>> OK
>>
>> Do we still need to revert commit efaa14c if this patch is applied?
>
> I guess not. At least in this machine changing the backlight works
> correctly, whereas in v3.11-rc3 it was all weird, and v3.7-v3.10
> didn't work at all. I cannot see how it would affect negatively other
> machines.

That commit makes hotkey emit notifications, and it's not the
problem of "booting into a black screen", that problem is due to
broken _BQC.

BTW, the efaa14c will also make screen off at level 0 according
to Felipe, who consider this is a bug. But since it is required to
let firmware emit notifications on hotkey press, I think user will
want it.

-Aaron

>
> That being said, the blacklisting is still needed, because 1. the
> level is not preserved between boots, and 2. level 0 turns off the
> screen, which I personally consider a regression.
>
> At least it boots to level 100 instead of 0.
>
> --
> Felipe Contreras

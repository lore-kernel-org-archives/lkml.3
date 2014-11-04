Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165AbaKDIEw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 03:04:52 -0500
Received: from mga14.intel.com ([192.55.52.115]:64553 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751163AbaKDIEs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 03:04:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="411018866"
From: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>
To: Andy Lutomirski <luto@amacapital.net>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Fleming, Matt" <matt.fleming@intel.com>,
        Ming Lei <ming.lei@canonical.com>,
        Sam Protsenko <semen.protsenko@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>
Subject: RE: [PATCH v2 3/3] efi: Capsule update with user helper interface
Thread-Topic: [PATCH v2 3/3] efi: Capsule update with user helper interface
Thread-Index: AQHP9+iuHUs9oVBcgkKjHBOxgX5ANZxPaE0AgACL8cD//4fqAIAAiNyg
Date: Tue, 4 Nov 2014 08:03:30 +0000
Message-ID: <F54AEECA5E2B9541821D670476DAE19C2B80EB68@PGSMSX102.gar.corp.intel.com>
References: <1414984030-13859-1-git-send-email-hock.leong.kweh@intel.com>
 <1414984030-13859-4-git-send-email-hock.leong.kweh@intel.com>
 <20141104043247.GA23418@kroah.com>
 <CALCETrXjJju+cMWJfB6W5kSD=Ox5y+Hj_AfmbbbOTOh8CV8eaQ@mail.gmail.com>
 <F54AEECA5E2B9541821D670476DAE19C2B80EAE4@PGSMSX102.gar.corp.intel.com>
 <CALCETrU2wk_FdcD6E+oMcp-tF97zN7f+w7q5rfPWBaNKrrmxVg@mail.gmail.com>
In-Reply-To: <CALCETrU2wk_FdcD6E+oMcp-tF97zN7f+w7q5rfPWBaNKrrmxVg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.30.20.205]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sA484vjg014296

> -----Original Message-----
> From: Andy Lutomirski [mailto:luto@amacapital.net]
> Sent: Tuesday, November 04, 2014 2:32 PM
> 
> It seems like a large fraction of the code in this module exists just to work
> around the fact that request_firmware doesn't do what you want it to do.
> You have code to:
> 
>  - Prevent the /lib/firmware mechanism from working.
>  - Avoid a deadlock by doing strange things in the unload code.
>  - Allow more than one capsule per module load.  (Isn't this hard to use?
> User code will have to wait for the next firmware request before sending a
> second capsule.)

I did try to upload more than one capsule binaries and I don't observe a long wait
is required. In fact, it seem to me the interface is instantly re-created.

> 
> All of this is for dubious gain.  You have to do three separate opens in sysfs to
> upload a capsule, and there's no way to report back to userspace whether
> the EFI call worked and whether a reboot is needed.

I have not encounter any capsule update that does not require reboot.
Base on my understanding, the EFI firmware only do the binary decoding
during the next reboot. If the binary is broken/corrupted, you would only
know during the next reboot. On kernel driver point of view, it just registers
the binary by calling the EFI API UpdateCapsule(). May be Matt you could
help out with this?

Regarding the EFI call failed message, besides obtains from the dmesg log,
you also can verify that through this sysfs:
/sys/devices/platform/efi_capsule_user_helper/capsule_loaded

I did mention this in the commit message as showed below:
Besides the request_firmware user helper interface, this module also exposes
a 'capsule_loaded' file note for user to verify the number of successfully uploaded
capsule binaries. This file note has the read only attribute.

> 
> What's the benefit of using the firmware interface here?
> 
> --Andy

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

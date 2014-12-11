Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933601AbaLKCPK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 21:15:10 -0500
Received: from mail-vc0-f182.google.com ([209.85.220.182]:62671 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933315AbaLKCPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 21:15:08 -0500
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:157d:45e4:c52e:9cb:8695]
In-Reply-To: <20141211010226.GA26253@aaronlu.sh.intel.com>
References: <54868CF6.6020505@intel.com>
	<CAOesGMirF-_H2ZzFR-VpwkEErZE2uQJSYx5EuePArQsEh=r_Kw@mail.gmail.com>
	<20141211010226.GA26253@aaronlu.sh.intel.com>
Date: Wed, 10 Dec 2014 18:15:07 -0800
Message-ID: <CAOesGMj_uObbxLdpobEhP=nRPsFUJNCtq01RH7ZSECd5=1Ti6Q@mail.gmail.com>
Subject: Re: [PATCH v5] Thermal: introduce INT3406 thermal driver
From: Olof Johansson <olof@lixom.net>
To: Aaron Lu <aaron.lu@intel.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, Zhang Rui <rui.zhang@intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        Linux-pm mailing list <linux-pm@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2014 at 5:02 PM, Aaron Lu <aaron.lu@intel.com> wrote:
> On Wed, Dec 10, 2014 at 11:53:25AM -0800, Olof Johansson wrote:
>> Hi,
>>
>> [+daniel vetter]
>>
>> On Mon, Dec 8, 2014 at 9:47 PM, Aaron Lu <aaron.lu@intel.com> wrote:
>> > INT3406 ACPI device object resembles an ACPI video output device, but its
>> > _BCM is said to be deprecated and should not be used. So we will make
>> > use of the raw interface to do the actual cooling. Due to this, the
>> > backlight core has some modifications. Also, to re-use some of the ACPI
>> > video module's code, one function has been exported.
>> >
>> > Signed-off-by: Aaron Lu <aaron.lu@intel.com>
>> > Signed-off-by: Zhang Rui <rui.zhang@intel.com>
>> > ---
>> > v5:
>> > Add the missing file drivers/thermal/int340x_thermal/Kconfig
>> > Remove the assignment of .owner field from the device_driver structure
>>
>>
>> Did this patch show up in -next for the first time last night, or did
>> some other change break this?
>>
>> It causes a panic in i915 when booting Minnowboard Max for me.
>
> Sorry for the trouble, I'm looking at this now.
> Is there anything special about the Minnowboard Max? I'll try to
> reproduce the issue here locally with a typical Intel desktop.

Another good question is why the code showed up in -next today. Code
going in for 3.19 is supposed to have been baking there already, and
it's too early to stage anything for 3.20.

Zhang?

> Is it the next/master branch?
> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git

Yes. But I've confirmed that it happens with Zhang's next branch too
without the rest of linux-next.


-Olof

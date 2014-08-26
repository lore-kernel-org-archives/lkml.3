Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681AbaHZRVL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 13:21:11 -0400
Received: from mail-yh0-f42.google.com ([209.85.213.42]:62963 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684AbaHZRVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 13:21:10 -0400
MIME-Version: 1.0
X-Originating-IP: [2a02:fe0:c120:a4c0:7e7a:91ff:fe0e:3e2c]
In-Reply-To: <20140826171425.GQ3347@wotan.suse.de>
References: <20140826170946.GP3347@wotan.suse.de> <20140826171425.GQ3347@wotan.suse.de>
From: Tom Gundersen <teg@jklm.no>
Date: Tue, 26 Aug 2014 19:20:49 +0200
Message-ID: <CAG-2HqULGgC5ftNKOML4XJZ5v_1b+z0t92nctTh7RB2tniRb9Q@mail.gmail.com>
Subject: Re: dell rbu driver and FW_LOADER_USER_HELPER
To: "Luis R. Rodriguez" <mcgrof@suse.com>
Cc: Abhay Salunke <abhay_salunke@dell.com>,
        =?UTF-8?Q?Cristian_Rodr=C3=ADguez?= <crrodriguez@opensuse.org>,
        Takashi Iwai <tiwai@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        systemd Mailing List <systemd-devel@lists.freedesktop.org>,
        Mario Limonciello <mario_limonciello@dell.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2014 at 7:14 PM, Luis R. Rodriguez <mcgrof@suse.com> wrote:
> On Tue, Aug 26, 2014 at 07:09:46PM +0200, Luis R. Rodriguez wrote:
>> When Christian tried removing the udev firmware loader
>> it was detected that the Dell rbu driver still required
>> use of FW_LOADER_USER_HELPER [0]. This driver needed
>> reworking to not be tied to the firmware loader, curious
>> if anyone has been working on that.

The rework is now upstream, but not yet released [1].

>> Is the current
>> implementation depending on that userspace identifies
>> the required path to the file ? Why can't standard
>> /lib/firmware/ paths be used ?

The dell driver dose not use rely on udev in userspace, nor the
/lib/firmware path. It has its own userspace component, which just
happens to reuse some of the infrastructure the udev firmware helper
used to use. This has now been split up, and as of 3.17 the firmware
loader can safely be removed from udev.

>> [0] http://lists.freedesktop.org/archives/systemd-devel/2014-May/019631.html
>
> Well abhay_salunke@dell.com bounces. Who at Dell is maintaining this
> driver now? Maybe Mario can help finding the right person?
>
>   Luis

[1]: <http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=5a1379e8748a5cfa3eb068f812d61bde849ef76c>

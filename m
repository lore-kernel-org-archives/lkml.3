Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757456AbaDHPmH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 11:42:07 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:41107 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756911AbaDHPmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 11:42:04 -0400
Message-ID: <534418C8.6080105@linux.com>
Date: Tue, 08 Apr 2014 17:42:00 +0200
From: Levente Kurusa <levex@linux.com>
Reply-To: Levente Kurusa <levex@linux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Jason Cooper <jason@lakedaemon.net>,
        =?UTF-8?B?VGVvZG9yYSBCxINsdcWjxIM=?= <teobaluta@gmail.com>
CC: David Lang <david@lang.hm>, Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>
Subject: Re: [RFC] QR encoding for Oops messages
References: <532DC3D3.9060008@linux.com> <CACV2jQBfRdQOyXF80WLoqm08-3VpWZno6UphKKPWmQD2f_yitA@mail.gmail.com> <20140323193839.GY15608@titan.lakedaemon.net> <CAAsK9AF8VevpdF-3nLC5sadV4y31cVeVWb5f2E=sV3ROu3Yk4Q@mail.gmail.com> <20140401142051.GO28304@titan.lakedaemon.net> <alpine.DEB.2.02.1404031353280.14073@nftneq.ynat.uz> <20140404151542.GB28334@titan.lakedaemon.net> <533EDB15.40305@linux.com> <CACV2jQCxfQzRydFD6KizFnquasqtqaz1O_yNnVDBetFA5UryrA@mail.gmail.com> <533FC8A6.6050905@linux.com> <20140407152003.GF28334@titan.lakedaemon.net>
In-Reply-To: <20140407152003.GF28334@titan.lakedaemon.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 04/07/2014 05:20 PM, Jason Cooper wrote:
> On Sat, Apr 05, 2014 at 11:11:02AM +0200, Levente Kurusa wrote:
>> Or, we could use core_param and simply have 'oops_qr' or
>> 'qr_oops'. In my humble opinion the latter sounds better.
> 
> Ack.  My original suggestion was focused on 0=disable, >0 is scale.  I
> literally pulled the name from my nether-regions.  :-)

Pushed to Teodora. Hopefully she will pull it soon.

> 
>> Oh and another suggestion, I think placing it in the bottom-right
>> corner would be better since then we wouldn't overwrite some of
>> the timestamps and messages.
> 
> The real text is still sent to the (hopefully written to disk) logs.  If
> a user (or distro) builds with this feature, I would think centered and
> scaled for ease of scanning would be highest priority.

Yup, I'll be traveling on the train a lot this week, so I'll
have plenty of time to implement scaling and centering. Maybe
we could also implement this:

qr_oops=center   (center the QR code with scale 1)
qr_oops=center,3 (center the QR code with scale 3)

'center' could also be 'topleft', 'bottomright', etc.
Or just remain at the KISS rule? (keep it simple)

Any objections?

> 
> I don't think there is a 'safe' part of the framebuffer real estate
> where the QR could be written for all scenarios.  Best to make it easy
> to scan.

Yea we also need to prevent it from happening on panics. Currently on
panics, (i.e. exit when init=/bin/sh) will cause half of the QR code
not rendered on screen due to some reason. It looks like it is due
to scrolling, but I am not sure then why doesn't happen when I
do 'echo c > /proc/sysrq-trigger' which as well causes a panic.

Any ideas why this happens?

-- 
Regards,
Levente Kurusa
PGP: 4EF5D641

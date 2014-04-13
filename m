Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346AbaDMUnw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 16:43:52 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:58478 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768AbaDMUnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 16:43:51 -0400
MIME-Version: 1.0
In-Reply-To: <534431EB.1060803@linux.com>
References: <20140323193839.GY15608@titan.lakedaemon.net>
	<CAAsK9AF8VevpdF-3nLC5sadV4y31cVeVWb5f2E=sV3ROu3Yk4Q@mail.gmail.com>
	<20140401142051.GO28304@titan.lakedaemon.net>
	<alpine.DEB.2.02.1404031353280.14073@nftneq.ynat.uz>
	<20140404151542.GB28334@titan.lakedaemon.net>
	<533EDB15.40305@linux.com>
	<CACV2jQCxfQzRydFD6KizFnquasqtqaz1O_yNnVDBetFA5UryrA@mail.gmail.com>
	<533FC8A6.6050905@linux.com>
	<20140407152003.GF28334@titan.lakedaemon.net>
	<534418C8.6080105@linux.com>
	<20140408172022.GC13102@titan.lakedaemon.net>
	<534431EB.1060803@linux.com>
Date: Sun, 13 Apr 2014 22:43:49 +0200
X-Google-Sender-Auth: xH9jcF6qd3sQrE88ZJ4phaTLIMU
Message-ID: <CAAsK9AHesqBOwYEaovg5m-Rxcd+_xnk-eN+EURxECYUBAsTC7A@mail.gmail.com>
Subject: Re: [RFC] QR encoding for Oops messages
From: Levente Kurusa <levex@linux.com>
To: Jason Cooper <jason@lakedaemon.net>,
        =?ISO-8859-2?B?VGVvZG9yYSBC42x1/uM=?= <teobaluta@gmail.com>
Cc: David Lang <david@lang.hm>, Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2014-04-08 19:29 GMT+02:00 Levente Kurusa <levex@linux.com>:
> Hi,
>
> On 04/08/2014 07:20 PM, Jason Cooper wrote:
>> On Tue, Apr 08, 2014 at 05:42:00PM +0200, Levente Kurusa wrote:
>>> On 04/07/2014 05:20 PM, Jason Cooper wrote:
>>>> On Sat, Apr 05, 2014 at 11:11:02AM +0200, Levente Kurusa wrote:
>>>>> Oh and another suggestion, I think placing it in the bottom-right
>>>>> corner would be better since then we wouldn't overwrite some of
>>>>> the timestamps and messages.
>>>>
>>>> The real text is still sent to the (hopefully written to disk) logs.  If
>>>> a user (or distro) builds with this feature, I would think centered and
>>>> scaled for ease of scanning would be highest priority.
>>>
>>> Yup, I'll be traveling on the train a lot this week, so I'll
>>> have plenty of time to implement scaling and centering. Maybe
>>> we could also implement this:
>>>
>>> qr_oops=center   (center the QR code with scale 1)
>>> qr_oops=center,3 (center the QR code with scale 3)
>>>
>>> 'center' could also be 'topleft', 'bottomright', etc.
>>> Or just remain at the KISS rule? (keep it simple)
>>>
>>> Any objections?
>>
>> KISS. ;-)
>>
>> Iff we find we need the feature later, we can always add qr_oops_pos or
>> similar.
>>
>
> Alright, I'll start the work on that tomorrow.
>
> Maybe I'll also find some time to clean up the library,
> since I guess that should be our primary priority.

Just a quick reminder that scaling was just merged in [0].
I'd highly appreciate feedback. Thanks!

Now that rendering is a bit cleaner I'll start cleaning up
the library. This is what I intend to do next week:

* Extract bitstream.c into a new kernel library. No point
  in restricting this to QR only.

* Rework bitstream to propagate errors, to use a caller
  allocation scheme and remove the ugly OOPness.

* Fix up the QR library so that it propagates errors
  from the new bitstream code.

Any objections?

[0]: https://github.com/teobaluta/qr-linux-kernel/commit/70401a9918e0810e7b0784fa6e1bdc766df20352

--
Regards,
Levente Kurusa
PGP: 4EF5D641

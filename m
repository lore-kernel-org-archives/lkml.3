Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778Ab3HBQZC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 12:25:02 -0400
Received: from mail-ve0-f177.google.com ([209.85.128.177]:38347 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860Ab3HBQZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 12:25:00 -0400
MIME-Version: 1.0
In-Reply-To: <1375460484.18144.11.camel@jlt4.sipsolutions.net>
References: <CALCETrU+C+sO8tJ0X5G4RDVLV=kHQQHurOnEQCoqbAouh60dng@mail.gmail.com>
 <1375460484.18144.11.camel@jlt4.sipsolutions.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 2 Aug 2013 09:24:38 -0700
Message-ID: <CALCETrVOhq3Q3ieyscQfuqWHyHxjcCbxiJ4jt9ru_88BtVB+HA@mail.gmail.com>
Subject: Re: Slow firmware timeouts again (Re: [3.11 regression?] iwlwifi
 firmware takes two minutes to load)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Linux Wireless List <linux-wireless@vger.kernel.org>,
        Intel Linux Wireless <ilw@linux.intel.com>,
        linux-hotplug@vger.kernel.org, linux-kernel@vger.kernel.org,
        systemd-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 2, 2013 at 9:21 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2013-08-02 at 09:04 -0700, Andy Lutomirski wrote:
>
>> > It wasn't exactly fixed and it's really more of a userspace problem - we
>> > probably request firmware version 8, and then it takes 30 seconds to
>> > time out for each of 8,7,6,5, after which the next request for 4 is
>> > successful.
>>
>> Why's it requesting those firmwares?  They don't seem to exist on
>> intellinuxwireless.org.
>
> Well for one you've never even mentioned what device you have, and then
> also it's not requesting 8/7 only 6,5,4 -- I guess the timeout was
> increased to 60 seconds (or I'm remembering wrong and it always was? I
> thought it was 30s)

I have an "Ultimate-N 6300 (rev 35)".  It's requesting at least
versions 6 and 5 (I saw them in udevadm monitor).  It looks like the
g2a and g2b variants have -5 and -6 versions, but 6000-4 appears to be
the only relevant version for my hardware.

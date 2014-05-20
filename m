Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750948AbaETEAF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 00:00:05 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:55790 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731AbaETEAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 00:00:03 -0400
MIME-Version: 1.0
In-Reply-To: <537A0247.1030503@ti.com>
References: <1400230809-11401-1-git-send-email-chander.kashyap@linaro.org>
	<537A0247.1030503@ti.com>
Date: Tue, 20 May 2014 09:30:02 +0530
Message-ID: <CAKohpoknoFuz8qnDpunA7oxr5E_18=+EQsFEy0P39fcU=4Ps9w@mail.gmail.com>
Subject: Re: [PATCH v3] PM / OPP: discard duplicate OPPs
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Nishanth Menon <nm@ti.com>
Cc: Chander Kashyap <chander.kashyap@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        "Brown, Len" <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chander Kashyap <k.chander@samsung.com>,
        Inderpal Singh <inderpal.s@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 May 2014 18:38, Nishanth Menon <nm@ti.com> wrote:

>> +     if (new_opp->rate == opp->rate) {
>> +             mutex_unlock(&dev_opp_list_lock);
>> +             kfree(new_opp);
>> +             return 0;
>
> IF we decide on ensuring that the OPP additions are done one time[1] -

Fingers crossed :)

But that doesn't mean we covered everything. First of all platforms can
still add OPPs directly and then there are other OPPs than CPU's.

> then returning -EEXIST is appropriate here. we want to be able to
> catch warnings of sequencing errors, and returning 0 is not the way to
> do it.

I have asked this on the earlier thread as well, let me ask it again.
What would callers do on return value of EEXIST ? Is there anything
special we may want to handle ?

Yes, we shouldn't fix everything silently and so a pr_warn() can/should
be added here. But returning is zero is better in order not to complicate
error handling at callers side.

Isn't it ?

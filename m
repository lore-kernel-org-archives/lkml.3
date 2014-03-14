Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756525AbaCNVpU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 17:45:20 -0400
Received: from mail-ve0-f172.google.com ([209.85.128.172]:39612 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756201AbaCNVpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 17:45:18 -0400
MIME-Version: 1.0
In-Reply-To: <CAKb7Uvi-GfOu3_3BMU_Cu4qYS8PQRWzxVm1XETY7y_TJjGPs_A@mail.gmail.com>
References: <20140314211456.GA23213@amd.pavel.ucw.cz>
	<CAKb7Uvi-GfOu3_3BMU_Cu4qYS8PQRWzxVm1XETY7y_TJjGPs_A@mail.gmail.com>
Date: Fri, 14 Mar 2014 22:45:17 +0100
Message-ID: <CAFLxGvz1Egbg1=Kxfc2DGw8OZUEootr5E=Uh7rW6qTSC8N9+Wg@mail.gmail.com>
Subject: Re: 3.14-rc: /proc/acpi/battery gone?
From: Richard Weinberger <richard.weinberger@gmail.com>
To: Ilia Mirkin <imirkin@alum.mit.edu>
Cc: Pavel Machek <pavel@ucw.cz>, rjw@rjwysocki.net,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>, tianyu.lan@intel.com,
        rafael.j.wysocki@intel.com,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2014 at 10:29 PM, Ilia Mirkin <imirkin@alum.mit.edu> wrote:
> On Fri, Mar 14, 2014 at 5:14 PM, Pavel Machek <pavel@ucw.cz> wrote:
>> Hi!
>>
>> It seems /proc/acpi/battery interface is gone, and I don't see any
>> option to reintroduce it... what is going on?
>
> The interface went away in a semi-recent kernel release (3.13 or
> 3.12), breaking pretty much every battery app. (Admittedly the
> interface was marked as deprecated for quite some time, but that
> didn't stop everyone from using it and not caring about the new
> thing.) I've yet to find a windowmaker dock app that works with the
> current sysfs API :(
>

commit 1e2d9cdfb4494fce682b4ae010d86a2766816d36
Author: Lan Tianyu <tianyu.lan@intel.com>
Date:   Fri Oct 11 09:54:08 2013 +0800

    ACPI / Battery: Remove battery's proc directory

    The battery's proc directory isn't useded and remove it.

    Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
    Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Looks like this one is the said commit.
If it breaks userspace we have to revert it IMHO.

-- 
Thanks,
//richard

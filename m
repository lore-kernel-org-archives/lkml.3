Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760103Ab3DBFEY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 01:04:24 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:45896 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759915Ab3DBFEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 01:04:22 -0400
MIME-Version: 1.0
In-Reply-To: <20130402005618.GA12199@gulag1.americas.sgi.com>
References: <5159C147.70800@sgi.com>
	<1364847069-2887-1-git-send-email-nzimmer@sgi.com>
	<1364847069-2887-3-git-send-email-nzimmer@sgi.com>
	<1479737.lmOfIzUVqh@vostro.rjw.lan>
	<20130402005618.GA12199@gulag1.americas.sgi.com>
Date: Tue, 2 Apr 2013 10:34:21 +0530
Message-ID: <CAKohpo=MVrz5YFqDkLkHCh4uTDrCc6KhVO23kyMPz3MHqOztsA@mail.gmail.com>
Subject: Re: [PATCH v6 2/2] cpufreq: covert the cpufreq_data_lock to a spinlock
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Nathan Zimmer <nzimmer@sgi.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2 April 2013 06:26, Nathan Zimmer <nzimmer@sgi.com> wrote:
> On Mon, Apr 01, 2013 at 10:41:27PM +0200, Rafael J. Wysocki wrote:
>> On Monday, April 01, 2013 03:11:09 PM Nathan Zimmer wrote:
>> > This eliminates the rest of the contention found in __cpufreq_cpu_get.
>> > I am not seeing a way to use the rcu so we will have to make due with a
>> > rwlock for now.
>> >
>> > Cc: Viresh Kumar <viresh.kumar@linaro.org>
>> > Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
>> > Signed-off-by: Nathan Zimmer <nzimmer@sgi.com>
>>
>> I've already applied this one.
>>
>> Can you please check if the version in my tree is OK?
>>
>> Rafael
>>
>
> Nope, the previous version was too different, probably best to just replace it.

Nathan,

First of all I should accept that I didn't had your last patch while
reviewing this
one earlier. Thanks Rafael.

Now, I believe the previous patch which Rafael has pushed was good and we
can simply keep it. What you can do is, just add a patch over it (which would
mostly be 1/2 of your patchset), that simply separates rcu stuff out of the lock
and leave lock for cpufreq_data..

--
viresh

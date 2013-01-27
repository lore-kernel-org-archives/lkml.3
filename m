Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756851Ab3A0XVa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 18:21:30 -0500
Received: from mail-bk0-f47.google.com ([209.85.214.47]:41412 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756822Ab3A0XV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 18:21:26 -0500
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <1927528.ZDbEpScRU3@vostro.rjw.lan>
References: <1359300060-2967-1-git-send-email-rui.zhang@intel.com>
	<1359300060-2967-3-git-send-email-rui.zhang@intel.com>
	<CAKMK7uF4u-3XFogzdQQCBqA2Q61D1s3PhVF7BOT90d88TkqT0g@mail.gmail.com>
	<1927528.ZDbEpScRU3@vostro.rjw.lan>
Date: Mon, 28 Jan 2013 00:21:24 +0100
X-Google-Sender-Auth: 81eHrNr8MQ163U3vE3GrB7HQrcI
Message-ID: <CAKMK7uH5D9-LAj7FPKuAhgQZk=1vsjzzX8jfJ2sw8krDUFaQ=w@mail.gmail.com>
Subject: Re: [Intel-gfx] [RFC PATCH 3/3] i915: ignore lid open event when resuming
From: Daniel Vetter <daniel@ffwll.ch>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Zhang Rui <rui.zhang@intel.com>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, lenb@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 27, 2013 at 11:21 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> Given that this essentially requires users to manually set this module
>> option to make stuff work I don't like this.
>>
>> I see a few possible options:
>> - plug the races between all the different parts - I've never really
>> understood why acpi sends us events before the resume code has
>> completed ...
>
> This particular one may be a result of patch [2/3] in the series,
> actually, because that patch makes SCI work over the whole cycle.
>
>> If that's indeed intentional, we could delay the
>> handling a bit until at least the i915 resume code completed.
>
> I would do that for now at least if possible.  It shouldn't hurt anyway.

Since I lack a bit clue about how the pm stuff works exactly: Is there
a ready-made helper for that kind of synchronization, where a notifier
callback can be called from a different device's resume callbacks,
which is someplace completely unrelated in the device-tree? Or any
anti-patterns to avoid?
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch

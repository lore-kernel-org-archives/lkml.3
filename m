Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756976Ab3BNEIZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 23:08:25 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:65313 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755089Ab3BNEIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 23:08:23 -0500
MIME-Version: 1.0
In-Reply-To: <511BC16C.7040807@gmail.com>
References: <1360170133-5066-1-git-send-email-dirk.brandewie@gmail.com>
	<20130212214949.GA1003@redhat.com>
	<511BC16C.7040807@gmail.com>
Date: Thu, 14 Feb 2013 09:38:21 +0530
X-Google-Sender-Auth: UOcfMTP-0c4_O8MuqoEn3qIXjhM
Message-ID: <CAOh2x=nwHbbngQm1PE7SfOLbHs3oMMb74zHXD9721OJzWo1+Tg@mail.gmail.com>
Subject: Re: [PATCH 0/5] Add P state driver for Intel Core Processors
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Dirk Brandewie <dirk.brandewie@gmail.com>
Cc: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2013 at 10:08 PM, Dirk Brandewie
<dirk.brandewie@gmail.com> wrote:
> For the case where both are built-in the load order works my driver uses
> device_initcall() and acpi_cpufreq uses late_initcall().
>
> For the case where both are a module (which I was sure I tested) you are
> right
> I will have to do something.
>
> For now I propose to make my driver built-in only while I sort out the right
> solution for the module build.  Does this seem reasonable to everyone?

Of-course i am missing something here. Why would anybody want to insert
acpi-cpufreq module when the system supports the pstate driver.

In case they are mutually exclusive, then we can have something like
depends on !ACPI-DRIVER in the kconfig option of pstate driver.

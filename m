Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271AbaHYKar (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 06:30:47 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:37440 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755221AbaHYKap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 06:30:45 -0400
MIME-Version: 1.0
In-Reply-To: <53F6AF66.10204@linux.vnet.ibm.com>
References: <1408015178-21745-1-git-send-email-shilpa.bhat@linux.vnet.ibm.com>
	<CAKohponDNHYrD9b==cp+pVmAi2ygA9-HcLZWqr4w3DDivB=-Ng@mail.gmail.com>
	<53F57E51.4060200@gmail.com>
	<CAKohpon8ANWoy52B=_nSuNyHALrsQOLX4cA+690E=CifnVRFtg@mail.gmail.com>
	<53F6AF66.10204@linux.vnet.ibm.com>
Date: Mon, 25 Aug 2014 16:00:45 +0530
Message-ID: <CAKohpokMXSC_oTbg1b0adPxFsht7aZJd61YwSpzqsUi=KOAwXw@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: powernv: Register the driver with reboot notifier
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: Shilpasri G Bhat <shilpabhatppc@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Shilpasri G Bhat <shilpa.bhat@linux.vnet.ibm.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 August 2014 08:18, Preeti U Murthy <preeti@linux.vnet.ibm.com> wrote:
> At the moment this looks like the best way forward. We need to do this
> cleanly by ensuring that we stop the governors and then call into the
> driver to deal with the cpu frequency in its own way during reboot. The
> best way to do this would be by calling this routine. Either this or
> cpufreq_suspend() should be called in the reboot path generically. The
> latter might not be an enticing option for other platforms.

Its not that I am doubting if this will work or not. But this Hack is using
routines not meant for this purpose. And that being a core routine,
things aren't that straightforward anymore.

@Rafael: Ping!!

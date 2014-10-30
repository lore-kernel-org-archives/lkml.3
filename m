Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934323AbaJ3TIY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 15:08:24 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:51187 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426AbaJ3TIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 15:08:23 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Tina Ruchandani <ruchandani.tina@gmail.com>
Cc: pavel@ucw.cz, len.brown@intel.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, opw-kernel@googlegroups.com,
        rjw@rjwysocki.net
Subject: Re: [PATCH] PM / Hibernate: Migrate to ktime_t
Date: Thu, 30 Oct 2014 20:08:17 +0100
Message-ID: <3436721.isgG5Fql2m@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141030180453.GA55907@localhost>
References: <20141030180453.GA55907@localhost>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:mugUDOMwjLRF2ZZrmNaV57ogBVJXwo7QWl2+KliBVz+
 +r0IEhlHEqpOxfFnigDFdsRWLfEAKYO1bHHal93hG/QrEGeSa6
 UVUL/Et+1roZQGiKMXcfwXtJ1khpeTXdmkSebqlFfCJSMe245S
 KzVZyZa/2Ss7Fkum83fsJCwauFU3hMiAsU9qdtewbeDOOgYhDE
 4lhqgGPo++3xMTdGjvfwH6icuhY0hu7QNjrNKrGyJ+VReKXUE6
 /IRFG2nZiMElfGZoVPQoPBck9zdplEhXU7emmeLLEMXKNuCitt
 P9LCzqOcF6nFtMN8Evk9QnXKjBTh2U0SW9WJiKdq3dTXQizajS
 8hNSMVw1L0dcXb5L3Jrk=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 30 October 2014 11:04:53 Tina Ruchandani wrote:
> This patch migrates swsusp_show_speed and its callers to using ktime_t instead
> of 'struct timeval' which suffers from the y2038 problem.
> 
> Changes to swsusp_show_speed:
>         - use ktime_t for start and stop times
>         - pass start and stop times by value
> Calling functions affected:
>         - load_image
>         - load_image_lzo
>         - save_image
>         - save_image_lzo
>         - hibernate_preallocate_memory
> Design decisions:
>         - use ktime_t to preserve same granularity of reporting as before
>         - use centisecs logic as before to avoid 'div by zero' issues caused by
>           using seconds and nanoseconds directly
>         - use monotonic time (ktime_get()) since we only care about elapsed time.
> 
> Signed-off-by: Tina Ruchandani <ruchandani.tina@gmail.com>
> Suggested-by: Arnd Bergmann <arnd@arndb.de>

Reviewed-by: Arnd Bergmann <arnd@arndb.de>

> --
> Changes in v4:
>  - Rebased patch off of 3.18-rc1
> Changes in v3:
> 

Note: you need three '-' characters to separate the patch description from
any extra information that you want in the mail but not in the changelog.

	Arnd

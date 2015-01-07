Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748AbbAGVMX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 16:12:23 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:62840 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919AbbAGVMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 16:12:22 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: John Stultz <john.stultz@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Corey Minyard <minyard@acm.org>,
        openipmi-developer@lists.sourceforge.net
Subject: Re: [PATCH 2/2][RFC] ipmi: Update timespec usage to timespec64
Date: Wed, 07 Jan 2015 22:12:12 +0100
Message-ID: <2142273.XSm0MMUjAB@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1420663910-6406-2-git-send-email-john.stultz@linaro.org>
References: <1420663910-6406-1-git-send-email-john.stultz@linaro.org> <1420663910-6406-2-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:wlxxjtJ1Tar2p+8cwhmRfTTmW79Y4/A9zvjq0oqfcv5UmsMZixA
 A9FWcwkNJC24oPZuOvBR4zxz4XFwkT0N8z4AKL1MDZy1zdlCDCegb/5E5N9qsqZtOlJz6iL
 pY1mJ3G63/9Q5JslfNCljNQZZcAHmSzor5hbDJtpHz3/4V2EW2HXW4TQOrhUcy7Fgxaej+1
 fuuwGPybxh/igUwUh1cYA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 January 2015 12:51:50 John Stultz wrote:
> As part of the internal y2038 cleanup, this patch removes
> timespec usage in the ipmi driver, replacing it timespec64
> 
> Cc: Corey Minyard <minyard@acm.org>
> Cc: openipmi-developer@lists.sourceforge.net
> Cc: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: John Stultz <john.stultz@linaro.org>
> 

In other drivers, we tended to use ktime_t and monotonic time,
but your approach is definitely simpler because it doesn't have
to rework the ipmi_si_is_busy logic and just do a
s/timespec/timespec64/ conversion.

Do you think it makes sense to use ktime_get_ts64 instead of
getnstimeofday64 to get a monotonic time? The advantage would
be to have the code work slightly better when racing against
settimeofday, the downside would be that the debug printk
shows the changed time base, but that would hopefully be
irrelevant to someone debugging the code.

	Arnd

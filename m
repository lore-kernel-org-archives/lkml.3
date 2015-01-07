Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726AbbAGVh5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 16:37:57 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:50606 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208AbbAGVhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 16:37:54 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: John Stultz <john.stultz@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, linux-ide@vger.kernel.org
Subject: Re: [PATCH][RFC] ide: pdc202xxx_new: Remove do_gettimeofday() usage for ktime_get
Date: Wed, 07 Jan 2015 22:37:50 +0100
Message-ID: <1721240.TWtHUuoOhJ@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1420664493-7041-1-git-send-email-john.stultz@linaro.org>
References: <1420664493-7041-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:K+N/xhpqEi50yrA1HJTb80qRrxXdwUVhZ4A/YO5cyl/1Zui5LOF
 RB1QBXgQZPrSMPmOu+LuvYNvss2Kirk2zFhiQLSuCYXSDBBniBFT11sg+3fpOo/j7rBHpkr
 w9Ev4oDLwPoaKgZW8g0YLvzcZNBEXF2BWOTbVO+C2n7Nz8VhiMu0x7HvtxIPXCqGnJtZ33p
 rVz+yH2nZMijzCm13bH7Q==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 January 2015 13:01:33 John Stultz wrote:
> +       usec_elapsed = (long)ktime_to_ns(ktime_sub(end_time, start_time))/1000;
> 

This should use ktime_us_delta for brevity. Doing the 32-bit division that
you have here is probably slightly more efficient because it avoids do_div(),
but it's not performance critical.

	Arnd

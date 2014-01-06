Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486AbaAFLXX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 06:23:23 -0500
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:30377 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005AbaAFLXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 06:23:16 -0500
X-IronPort-AV: E=Sophos;i="4.95,612,1384329600"; 
   d="scan'208";a="7854285"
Message-ID: <52CA9221.7090906@broadcom.com>
Date: Mon, 6 Jan 2014 12:23:13 +0100
From: Arend van Spriel <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>, <linux-kernel@vger.kernel.org>
Subject: Re: Build regressions/improvements in v3.13-rc7
References: <1388998868-31448-1-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1388998868-31448-1-git-send-email-geert@linux-m68k.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2014 10:01 AM, Geert Uytterhoeven wrote:
>   + /scratch/kisskb/src/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c: warning: 'str_mask' may be used uninitialized in this function [-Wuninitialized]:  => 789:19
>   + /scratch/kisskb/src/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c: warning: 'str_shift' may be used uninitialized in this function [-Wuninitialized]:  => 790:21

This is a false negative. These variables are used within 'if (strtab !=
NULL) {...}'. strtab is initialized to NULL and when set to non-NULL
also str_mask and str_shift are set.

So it seems gcc falls short on -Wuninitialized here.

Regards,
Arend

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756257Ab3BNIMP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 03:12:15 -0500
Received: from webbox1416.server-home.net ([77.236.96.61]:54490 "EHLO
	webbox1416.server-home.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756160Ab3BNIMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 03:12:14 -0500
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: Wim Van Sebroeck <wim@iguana.be>, Wenyou Yang <wenyou.yang@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, nicolas.ferre@atmel.com,
        plagnioj@jcrosoft.com, fabio.porcedda@gmail.com, JM.Lin@atmel.com,
        linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 4/8] watchdog/at91sam9_wdt: Adjust the options of watchdog_info
Date: Thu, 14 Feb 2013 09:12:10 +0100
Message-ID: <1459249.A0040oxoB3@ws-stein>
User-Agent: KMail/4.9.5 (Linux/3.6.11-gentoo+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130213231522.GH7867@spo001.leaseweb.com>
References: <1359702386-21284-1-git-send-email-wenyou.yang@atmel.com> <1359702386-21284-5-git-send-email-wenyou.yang@atmel.com> <20130213231522.GH7867@spo001.leaseweb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thursday 14 February 2013 00:15:22, Wim Van Sebroeck wrote:
> Hi Wenyou,
> 
> > Since the Watchdog Timer Mode Register can be only written only once,
> > so the watchdog_info shall not support WDIOF_SETTIMEOUT
> > and WDIOF_MAGICCLOSE options, remove them.
> 
> Ik you keep using the timer, then you don't have to remove this.

Why removing especially WDIOF_MAGICCLOSE (and the timer needed for that)? This is a feature removal. Without there isn't even a need for nowayout option as it is implicitly set anyway.
Nevertheless I would prefere keeping the timer to allow a user to let the kernel triggering the timer upon MAGICCLOSE.

Alexander


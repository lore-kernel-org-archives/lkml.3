Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760536AbaJ3Onv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 10:43:51 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:52396 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760415AbaJ3Ont (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 10:43:49 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Wim Van Sebroeck <wim@iguana.be>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org
Subject: Re: [PATCH] watchdog: at91rm9200: allow building when using device tree
Date: Thu, 30 Oct 2014 15:43:43 +0100
Message-ID: <2000678.14fQbcst9s@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141030153624.6643c1b4@bbrezillon>
References: <1414678534-2677-1-git-send-email-alexandre.belloni@free-electrons.com> <20141030153624.6643c1b4@bbrezillon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:KD8OIslML+FAagDUpQPomzEDnTWT0yDYD1Bi0H/VZVl
 d7tYl96anM0yJKvPjkNH+GA8SDSZNVy8f+cvpJtzxg9qmnFEQT
 JiUpuNqEG3yfdVArX4LwWDUv1f9Y/mEselMWR+SLecA0U2K1vh
 1XOHMnYlPSkUdOwXIDwdZYgx5tGunNtY6zZNo6Blb6xVG+Y6V6
 CjvC/oWXQwJFBuulYY3IROrXk8RHIkiBmIUeQZCddTZb0UUZqV
 4S4TpuAFCv1JQLqqPDZb+nhdka00DV0EsESflB17HJY3Yex8Lb
 4mKGLe+UDF3FC9OpcOuW/7upOc2LlL/P5Gzd5z5rbqshaGQCdI
 4qoQMwuu8f2MD+gUZ5P0=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 30 October 2014 15:36:24 Boris Brezillon wrote:
> On Thu, 30 Oct 2014 15:15:34 +0100
> Alexandre Belloni <alexandre.belloni@free-electrons.com> wrote:
> 
> > When building with device tree, ARCH_AT91RM9200 may not be selected. Allow
> > building that driver by also depending on ARCH_AT91.
> > 
> > Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> 
> Acked-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> 

Doesn't this reintroduce the bug fixed by commit 09549cd0172 ("watchdog:
Revert the AT91RM9200_WATCHDOG dependency")?

At least in 3.18-rc2, the driver still uses at91_st_write/at91_st_read.

	Arnd

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761588Ab3LIVIb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 16:08:31 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:52782 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755958Ab3LIVI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 16:08:28 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: boris brezillon <b.brezillon@overkiz.com>
Subject: Re: [PATCH v4 3/6] ARM: at91/dt: define sama5d3 clocks
Date: Mon, 9 Dec 2013 22:05:08 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Mike Turquette <mturquette@linaro.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1385650171-8756-1-git-send-email-b.brezillon@overkiz.com> <201312091748.58386.arnd@arndb.de> <52A5F79D.9070408@overkiz.com>
In-Reply-To: <52A5F79D.9070408@overkiz.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201312092205.08933.arnd@arndb.de>
X-Provags-ID: V02:K0:vwMOSCf5z73Lu6krdml1q9bjdhgCIS50VrNDeG3/l1g
 TWBXu5zBP+8TfiJco96/bFesEWJUIL2nEEOcgNvBS4Bng/tH6c
 JodDCtod2rLWsv9nRxhDAW070EOTnnGPZglQ/CBZ2s/PkQC+ef
 +QhYdxzl91ceIOvyXh+mrRNvDyOKgX4tVrPxy6Q3hOi9e0nmIu
 5+sEJIijUERUTAxcToCd2Jn5orkpE9ANwhnuq6ft0E6n9AOS5T
 giem2RJeOXvhffqRSJx6Ax79ccTlR5Q+Bq5D2YWKnZVTEux+BZ
 jDWUP7AyTqQQGDToPGEyqb11Delpu43Mu//2XtM8YOVDy/A2Gu
 ntIWGTHQxLeA6lNhvFIM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 December 2013, boris brezillon wrote:
> Are you talking about drivers or clk binding documentation ?
> In either cases they're not defined :-), but I'd like to know which 
> file(s) I should update.

I mean bindings for the devices using these clocks. Each of them should
list among its properties something like

|Mandatory properties:
|  clocks:	One phandle and clock specifier for xxxx
|  clock-names:	The name of this clock, must be "xxxx"

Of course if we decide to make it an anonymous clock, we still need to
document the fact that the clock is required.

> I'd rather not change the static clock lookup tables, but if you prefer this
> approach (and Nicolas agrees), I'll propose a series modifying the drivers
> and clk lookup table.
> 
> Whatever solution is choosen, I guess I'll have to update the drivers dt
> binding documentation anyway ;-).

Ok. FWIW, I think the best way to stage the clock updates (if the decision
is to make them anonymous) would be to duplicate all the clocks in question
in a first patch, and then submit changes for each driver to the respective
subsystem maintainers with a patch based on the first changeset.

Once all the drivers are converted (i.e. the following merge window), we can
remove the obsolete entries.

	Arnd

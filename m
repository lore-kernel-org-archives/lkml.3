Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364AbaLDJXn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 04:23:43 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:49689 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700AbaLDJXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 04:23:40 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-omap@vger.kernel.org, Sebastian Reichel <sre@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH] hsi / OMAP / PM: Replace CONFIG_PM_RUNTIME with CONFIG_PM
Date: Thu, 04 Dec 2014 10:23:35 +0100
Message-ID: <8906994.EV0QeHVvVO@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <22524926.vCRamu0d6Y@vostro.rjw.lan>
References: <6319344.XVfdONE5DJ@vostro.rjw.lan> <2553100.3OLsEPLv6G@wuerfel> <22524926.vCRamu0d6Y@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:/lZyP42M5zUq8I7zxCtl0yvnesFoU3VgAtYDAU6qK0jdsDRkBtJ
 2x80KnlhzCb5BsQcH/bWGV/YLBqqXbFFPwANCnb72pqvpIaMThmkDu9yD67IWkWEsy5CAmz
 Y9ojQDe6XKkP4A/dPvEDV+gjX/GU0SNrrh/PyAqQ++E8zzERpx24i2e01FD+vpx/O5cKnAI
 kcr+JCQKa/X9Ky8Q5R/5w==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 December 2014 23:45:22 Rafael J. Wysocki wrote:
> http://marc.info/?l=linux-kernel&m=141712284917133&w=4
> 
> > Before we do lots of s/CONFIG_PM_SLEEP/CONFIG_PM/ changes in lots of
> > other drivers, it would be nice to come up with a new set of macros
> > to replace all the SET_RUNTIME_PM_OPS/SIMPLE_DEV_PM_OPS/..._OPS
> > with a version that avoided the #ifdefs altogether.
> 
> I don't think we can avoid all of the #ifdefs and the macros still work
> (except for one which is redundant, but I have a patch to clean that up).

Right, while we can create a version that does not require the #ifdef,
that would still mean we'd have to touch every file and replace
SET_RUNTIME_PM_OPS with PM_SET_RUNTIME_OPS or something like that
because the new macro would not work if the function is not defined.

	Arnd

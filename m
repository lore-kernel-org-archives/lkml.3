Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751912AbbAMUe2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 15:34:28 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:63669 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbbAMUe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 15:34:27 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Alessandro Zummo <a.zummo@towertech.it>
Cc: Xunlei Pang <xlpang@126.com>, linux-kernel@vger.kernel.org,
        John Stultz <john.stultz@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>, rtc-linux@googlegroups.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Xunlei Pang <pang.xunlei@linaro.org>
Subject: Re: [RFC PATCH v2 2/9] time: Provide y2106 safe get_seconds() replacement
Date: Tue, 13 Jan 2015 21:34:19 +0100
Message-ID: <1647943.u0FuNbvWB1@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20150113171744.69254bfd@linux.lan.towertech.it>
References: <1421163897-8020-1-git-send-email-xlpang@126.com> <1421163897-8020-3-git-send-email-xlpang@126.com> <20150113171744.69254bfd@linux.lan.towertech.it>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:A3Hx68Z6y88B4njhRAr/xF1y61E9uy2FtPO/J5XyKvHXxjybem5
 wHTiwkzRB25abrdCeBAbX7+pYPd8bOZN+oOOxSF1tX00cBk3gF4M56ofZ6ySGyKe6q1Legw
 zwqpoPvDMmHYa5Mv+u++gSlhnUwNoURqlirDxQ8ZVK9NdCrdr+HC3zND68192p2V2++ZmJD
 NMD7iEHBegwV+9X3qRxQQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 January 2015 17:17:44 Alessandro Zummo wrote:
> On Tue, 13 Jan 2015 23:44:50 +0800
> Xunlei Pang <xlpang@126.com> wrote:
> 
> > -EXPORT_SYMBOL(get_seconds);
> > +EXPORT_SYMBOL(get_seconds64);
> 
>  Please leave get_seconds untouched
> 

The patch leaves it in place. However, we already have ktime_get_seconds()
and ktime_get_real_seconds(). Code that currently uses get_seconds can
trivially be converted to the latter.

	Arnd

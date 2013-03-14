Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964855Ab3CNRUq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 13:20:46 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:42908 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755509Ab3CNRUp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 13:20:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Roberto Oppedisano <roberto.oppedisano@infracom.it>
Cc: LKML <linux-kernel@vger.kernel.org>, toshi.kani@hp.com,
        isimatu.yasuaki@jp.fujitsu.com, yinghai@kernel.org
Subject: Re: Regression: Fixing recursive fault but reboot is needed at boot on HP 6730B - bisected
Date: Thu, 14 Mar 2013 18:27:51 +0100
Message-ID: <1453029.sQIX9a1hrM@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc1+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <51418863.8000902@infracom.it>
References: <513D8F3A.8030308@gmail.com> <51418863.8000902@infracom.it>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, March 14, 2013 09:20:51 AM Roberto Oppedisano wrote:
> Hi
> 
> Il 11/03/2013 09:00, Roberto Oppedisano ha scritto:
> > Hello
> >     I'm observing this kind of boot failure when my laptop
> > is not docked; I didn't notice before because I seldom reboot
> > it when it's not connected to a docking station.
> >
> > The failure is reproducible at 80-90%, meaning that one boot
> > over 8-10 will complete also with the laptop undocked; it seems
> > that being attached to a power supply (via jack, not docking) or
> > on batteries makes no difference WRT this failure.
> 
> following the results of a bisection:
> 
> b17b537ac1429a609addb55bf985f5ebfcf4ae7b is the first bad commit
> commit b17b537ac1429a609addb55bf985f5ebfcf4ae7b
> Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Date:   Tue Jan 15 13:23:44 2013 +0100
> 
>      ACPI / scan: Drop the second argument of acpi_device_unregister()
> 
>      Drop the second argument of acpi_device_unregister(), type, which is
>      not used by that function.
> 
>      Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>      Acked-by: Toshi Kani <toshi.kani@hp.com>
>      Acked-by: Yinghai Lu <yinghai@kernel.org>
>      Acked-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> 
> :040000 040000 13aeb8bccbd062e65bc3710bb426fe8ac7d0cad5 
> 17d4603977ea57133d149814dc34e274ca0c2deb M      drivers
> 
> Trying to revert this commit on current master gave me an error.
> 
> Let me know if you need more info or testing.

As Toshi said, this particular commit doesn't make any functional changes.

Can you please verify if the immediately preceding commit
6af9a803f4d2e4137d9f74a8fc9af4857fbda001 works for you?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

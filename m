Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753109Ab3CNIU6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 04:20:58 -0400
Received: from mx02.infracom.it ([62.196.48.10]:48199 "EHLO mx02.infracom.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751339Ab3CNIUz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 04:20:55 -0400
Message-ID: <51418863.8000902@infracom.it>
Date: Thu, 14 Mar 2013 09:20:51 +0100
From: Roberto Oppedisano <roberto.oppedisano@infracom.it>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: LKML <linux-kernel@vger.kernel.org>, <toshi.kani@hp.com>,
        <isimatu.yasuaki@jp.fujitsu.com>, <yinghai@kernel.org>
Subject: Re: Regression: Fixing recursive fault but reboot is needed at boot
 on HP 6730B - bisected
References: <513D8F3A.8030308@gmail.com>
In-Reply-To: <513D8F3A.8030308@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Il 11/03/2013 09:00, Roberto Oppedisano ha scritto:
> Hello
>     I'm observing this kind of boot failure when my laptop
> is not docked; I didn't notice before because I seldom reboot
> it when it's not connected to a docking station.
>
> The failure is reproducible at 80-90%, meaning that one boot
> over 8-10 will complete also with the laptop undocked; it seems
> that being attached to a power supply (via jack, not docking) or
> on batteries makes no difference WRT this failure.

following the results of a bisection:

b17b537ac1429a609addb55bf985f5ebfcf4ae7b is the first bad commit
commit b17b537ac1429a609addb55bf985f5ebfcf4ae7b
Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Date:   Tue Jan 15 13:23:44 2013 +0100

     ACPI / scan: Drop the second argument of acpi_device_unregister()

     Drop the second argument of acpi_device_unregister(), type, which is
     not used by that function.

     Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
     Acked-by: Toshi Kani <toshi.kani@hp.com>
     Acked-by: Yinghai Lu <yinghai@kernel.org>
     Acked-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

:040000 040000 13aeb8bccbd062e65bc3710bb426fe8ac7d0cad5 
17d4603977ea57133d149814dc34e274ca0c2deb M      drivers

Trying to revert this commit on current master gave me an error.

Let me know if you need more info or testing.

R


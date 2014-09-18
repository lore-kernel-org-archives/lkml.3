Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987AbaIRM6J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 08:58:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59486 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751292AbaIRM6H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 08:58:07 -0400
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH 0/4] drivers/bus: Freescale Management Complex bus driver patch series
From: Alexander Graf <agraf@suse.de>
X-Mailer: iPhone Mail (11B554a)
In-Reply-To: <541A253F.7030305@freescale.com>
Date: Thu, 18 Sep 2014 14:58:00 +0200
Cc: Kim Phillips <kim.phillips@freescale.com>,
        "<gregkh@linuxfoundation.org>" <gregkh@linuxfoundation.org>,
        "<arnd@arndb.de>" <arnd@arndb.de>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>,
        "<stuart.yoder@freescale.com>" <stuart.yoder@freescale.com>,
        "<scottwood@freescale.com>" <scottwood@freescale.com>,
        "<linuxppc-release@linux.freescale.net>" 
	<linuxppc-release@linux.freescale.net>
Content-Transfer-Encoding: 8BIT
Message-Id: <B83A7221-35BF-4E20-8AC4-333A2C0A39B7@suse.de>
References: <1410456864-27890-1-git-send-email-German.Rivera@freescale.com> <20140915184423.2189d18282c9c2030e564f7c@freescale.com> <541A253F.7030305@freescale.com>
To: German Rivera <German.Rivera@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> Am 18.09.2014 um 02:20 schrieb German Rivera <German.Rivera@freescale.com>:
> 
>> On 09/15/2014 06:44 PM, Kim Phillips wrote:
>> On Thu, 11 Sep 2014 12:34:20 -0500
>> "J. German Rivera" <German.Rivera@freescale.com> wrote:
>> 
>>> This patch series introduces Linux support for the Freescale
>>> Management Complex (fsl-mc) hardware.
>> 
>> here are the results of using some tools to check this patchseries:
>> 
>> make C=1 CF="-D__CHECK_ENDIAN__":
>> 
>> drivers/bus/fsl-mc/fsl_mc_sys.c:235:9: warning: context imbalance in 'mc_send_command' - different lock contexts for basic block
>> drivers/bus/fsl-mc/fsl_mc_dprc.c: In function 'dprc_add_new_devices':
>> drivers/bus/fsl-mc/fsl_mc_dprc.c:173:6: warning: format '%lu' expects argument of type 'long unsigned int', but argument 3 has type 'uint32_t' [-Wformat=]
>>       region_desc.size);
>>       ^
> I'll fix this in v2 respin.
> 
>> When built as a module (CONFIG_FSL_MC_BUS=m):
>> 
>> ERROR: ".dprc_get_obj" [drivers/bus/fsl-mc/fsl_mc_dprc.ko] undefined!
>> ERROR: ".dprc_get_obj_count" [drivers/bus/fsl-mc/fsl_mc_dprc.ko] undefined!
>> ERROR: ".dprc_close" [drivers/bus/fsl-mc/fsl_mc_dprc.ko] undefined!
>> ERROR: ".dprc_open" [drivers/bus/fsl-mc/fsl_mc_dprc.ko] undefined!
>> ERROR: ".dprc_get_obj_region" [drivers/bus/fsl-mc/fsl_mc_dprc.ko] undefined!
>> make[1]: *** [__modpost] Error 1
>> make: *** [modules] Error 2
> I'll fix this in v2 respin.
> 
>> checkpatch:
>> 
>> WARNING: added, moved or deleted file(s), does MAINTAINERS need updating?
>> 
>> WARNING: DT compatible string "fsl,qoriq-mc" appears un-documented -- check ./Documentation/devicetree/bindings/
>> #690: FILE: drivers/bus/fsl-mc/fsl_mc_bus.c:528:
>> +    {.compatible = "fsl,qoriq-mc",},
>> 
>> For the former warning, I'd suggest moving patch 4/4's contents up
>> in the series.
> I tried moving 4/4 to be 1/4 but still get the the same warning from checkpatch. So, this suggestion does not work. Besides, I took a look
> at other commits that update the MAINTAINERS such as
> 563da3a90364fc29cd09bed034162592e591747a, and that commit comes after the commits that added the new files.

The alternative would be to add MAINTAINERS entries for the files you add in the patch that adds the files.


Alex


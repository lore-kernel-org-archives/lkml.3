Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751509AbaJOHhh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 03:37:37 -0400
Received: from bay004-omc1s2.hotmail.com ([65.54.190.13]:63075 "EHLO
	BAY004-OMC1S2.hotmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264AbaJOHhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 03:37:36 -0400
X-TMN: [Q/t1t1BvDuEoo5s8EjsX7om13l5fLe7t]
X-Originating-Email: [dudlx@outlook.com]
Message-ID: <BAY404-EAS403B2330316886B8E056845BDAA0@phx.gbl>
From: Dudley Du <dudlx@outlook.com>
To: <dmitry.torokhov@gmail.com>, <rydberg@euromail.se>
CC: <bleung@google.com>, <patrikf@google.com>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <1413357567-26177-1-git-send-email-dudl@cypress.com>
In-Reply-To: <1413357567-26177-1-git-send-email-dudl@cypress.com>
Subject: RE: [PATCH 00/13] input: cyapa: intruction of cyapa patches
Date: Wed, 15 Oct 2014 15:37:33 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQHP6EhzzShZjRDUpkyrt2Qcfutix5wwxFFA
Content-Language: zh-cn
X-OriginalArrivalTime: 15 Oct 2014 07:37:35.0663 (UTC) FILETIME=[E35AB3F0:01CFE84A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

This "input: cyapa" patches are v8 patches updated based on previous reviews.
I'm sorry for lost the patch version information.

Thanks,
Dudley

> -----Original Message-----
> From: Dudley Du [mailto:dudley.dulixin@gmail.com]
> Sent: 2014?10?15? 15:19
> To: dmitry.torokhov@gmail.com; rydberg@euromail.se
> Cc: Dudley Du; bleung@google.com; patrikf@google.com;
> linux-input@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: [PATCH 00/13] input: cyapa: intruction of cyapa patches
> 
> Based on Dmitry's comments, I made v8 patches of cyapa trackpad device
> with below updates compared with v7 patches:
> 1) [PATCH v8 01/13] - Remove the async thread for device detect in
>    proble routine, now the device detect process is completly done within
>    the device proble routine.
> 2) [PATCH v8 01/13] - Split the irq cmd hander function to separated
>    function cyapa_default_irq_cmd_handler() and set it to interface
>    cyapa_default_ops.irq_cmd_handler.
> 3) [PATCH v8 06/13] - Add cyapa->gen check in cyapa_gen3_irq_cmd_handler()
>    to avoid miss-enter when device protocol is still in detecting.
> 
> 
> V7 patches have below updates compared with v6 patches:
> 1) [PATCH v7 01/13] - Split the irq cmd hander function to separated
>    function cyapa_default_irq_cmd_handler() and set it to interface
>    cyapa_default_ops.irq_cmd_handler.
> 2) [PATCH v7 06/13] - Add cyapa->gen check in cyapa_gen3_irq_cmd_handler()
>    to avoid miss-enter when device protocol is still in detecting.
> 
> 
> V6 patches have below updates compared with v5 patches:
> 1) Remove patch 14 of the lid filtering from the cyapa driver.
> 
> V5 patches have below updates compared with v4 patches:
> 1) Uses get_device()/put_device() instead of kobject_get()/kobject_put();
> 2) Fix memories freed before debugfs entries issue;
> 3) Make cyapa_debugs_root valid in driver module level
>    in module_init()/moudle_exit() ;
> 4) Fix i2c_transfer() may return partial transfer issues.
> 5) Add cyapa->removed flag to avoid detecting thread may still running
>    when driver module is removed.
> 6) Fix the meanings of some comments and return error code not clear issue.
> 
> This patch set is aimed to re-architecture the cyapa driver to support
> old gen3 trackpad device and new gen5 trackpad device in one
> cyapa driver for easily productions support based on
> customers' requirements, and add sysfs functions and interfaces
> supported that required by users and customers.
> Because the earlier gen3 and the latest gen5 trackpad devies using
> two different chipsets, and have different protocol and interfaces.
> If supported these two trackpad devices in two different drivers, then
> it will be difficult to manage productions and later firmware updates.
> it will cause customer don't know which one to use and update
> because these two trackpad devices have been used and integrated
> in same one productions at a time, so must to support these two trackpad
> devices in same on driver.
> 
> The new architecture is made of:
> cyapa.c - the core of the architecture, supply interfaces and
> functions to system and read trackpad devices.
> cyapa.h - header file including macros and data structure definitions.
> cyapa_gen3.c - functions support for gen3 trackpad devices,
> cyapa_gen5.c - functions support for gen5 trackpad devices.
> 
> Beside this introduction patch, it has 14 patches listed as below.
> For these patches each one is patched based on previous one.
> 
> patch 1/13: re-architecture cyapa driver with core functions,
> and applying the device detecting function in async thread to speed
> up system boot time.
> 
> patch 2/13: add cyapa driver power management interfaces support.
> 
> patch 3/13: add cyapa driver runtime power management interfaces support.
> 
> patch 4/13: add cyapa key function interfaces in sysfs system.
> Including read firmware version, get production ID, read baseline,
> re-calibrate trackpad baselines and do trackpad firmware update.
> 
> patch 5/13: add read firmware image and read raw trackpad device'
> sensors' raw data interface in debugfs system.
> 
> patch 6/13: add gen3 trackpad device basic functions support.
> 
> patch 7/13: add gen3 trackpad device firmware update function support.
> 
> patch 8/13: add gen3 trackpad device report baseline and do force
> re-calibrate functions support.
> 
> patch 9/13: add gen3 trackpad device read firmware image function support.
> 
> patch 10/13: add gen5 trackpad device basic functions support.
> 
> patch 11/13: add gen5 trackpad device firmware update function support.
> 
> patch 12/13: add gen5 trackpad device report baseline and do force
> re-calibrate functions support.
> 
> patch 13/13: add gen5 trackpad device read firmware image and report
> sensors' raw data values functions support.
> 
> This message and any attachments may contain Cypress (or its subsidiaries)
> confidential information. If it has been received in error, please advise the
sender
> and immediately delete this message.

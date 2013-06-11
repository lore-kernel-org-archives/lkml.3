Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139Ab3FKJFx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 05:05:53 -0400
Received: from service87.mimecast.com ([91.220.42.44]:34629 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250Ab3FKJFu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 05:05:50 -0400
Date: Tue, 11 Jun 2013 10:05:45 +0100
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Pawel Moll <Pawel.Moll@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Jon Medhurst <tixy@linaro.org>, Achin Gupta <Achin.Gupta@arm.com>,
        Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
Subject: Re: [RFC PATCH v3 0/2] drivers: mfd: Versatile Express SPC support
Message-ID: <20130611090545.GC8164@e102568-lin.cambridge.arm.com>
References: <1370512763-32200-1-git-send-email-lorenzo.pieralisi@arm.com>
MIME-Version: 1.0
In-Reply-To: <1370512763-32200-1-git-send-email-lorenzo.pieralisi@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 11 Jun 2013 09:05:45.0984 (UTC) FILETIME=[DBCE6000:01CE6682]
X-MC-Unique: 113061110054801501
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

if nobody has objections I think this set is ready to get merged. As
Nico mentioned in:

http://lists.infradead.org/pipermail/linux-arm-kernel/2013-June/173541.html

since we would like to get it merged through the ARM SoC tree owing to
dependencies between this code and ARM power management back-ends, your ack
would be appreciated, if you think it is worth it of course.

Thank you very much indeed,
Lorenzo

On Thu, Jun 06, 2013 at 10:59:21AM +0100, Lorenzo Pieralisi wrote:
> This patch is v3 of a previous posting:
> 
> http://lists.infradead.org/pipermail/linux-arm-kernel/2013-June/173464.html
> 
> v3 changes:
> 
> - added __refdata to spc_check_loaded pointer
> - removed some exported symbols
> - added node pointer check in vexpress_spc_init()
> 
> v2 changes:
> 
> - Dropped timeout interface patch
> - Converted interfaces to non-timeout ones, integrated and retested
> - Removed mutex used at init
> - Refactored code to work around init sections warning
> - Fixed two minor bugs
> 
> This patch series introduces support for the Versatile Express Serial
> Power Controller (SPC) present in ARM Versatile Express TC2 core tiles.
> SPC driver is a fundamental component of TC2 power management and allows
> to carry out C-state management and DVFS for A15 and A7 clusters.
> 
> First patch provides changes required by SPC to comply with the
> Versatile Express config API, second patch is the SPC driver implementation.
> 
> Code extensively exercised through CPUidle and CPUfreq power states and
> operating point transitions.
> 
> Lorenzo Pieralisi (1):
>   drivers: mfd: vexpress: add Serial Power Controller (SPC) support
> 
> Pawel Moll (1):
>   drivers: mfd: refactor the vexpress config bridge API
> 
>  Documentation/devicetree/bindings/mfd/vexpress-spc.txt |  35 +
>  drivers/mfd/Kconfig                                    |   7 +
>  drivers/mfd/Makefile                                   |   1 +
>  drivers/mfd/vexpress-config.c                          |  61 +-
>  drivers/mfd/vexpress-spc.c                             | 633 ++++++++++
>  drivers/mfd/vexpress-sysreg.c                          |   2 +-
>  include/linux/vexpress.h                               |  59 +-
>  7 files changed, 770 insertions(+), 28 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/mfd/vexpress-spc.txt
>  create mode 100644 drivers/mfd/vexpress-spc.c
> 
> -- 
> 1.8.2.2
> 


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755014AbaDOSwr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 14:52:47 -0400
Received: from www84.your-server.de ([213.133.104.84]:53505 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920AbaDOSwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 14:52:45 -0400
Message-ID: <1397587915.21321.9.camel@vger.seibold.net>
Subject: Re: X86: kexec issues with i915 in 3.14
From: Stefani Seibold <stefani@seibold.net>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: "Woodhouse, David" <david.woodhouse@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "daniel.vetter@ffwll.ch" <daniel.vetter@ffwll.ch>,
        "Zanoni, Paulo R" <paulo.r.zanoni@intel.com>,
        "greg@kroah.com" <greg@kroah.com>
Date: Tue, 15 Apr 2014 20:51:55 +0200
In-Reply-To: <534CF3B1.7020508@linux.intel.com>
References: <1397419299.1407.18.camel@vger.seibold.net>
	 <1397435291.19944.176.camel@shinybook.infradead.org>
	 <1397504974.1059.5.camel@vger.seibold.net>
	 <534CF3B1.7020508@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 15.04.2014, 16:54 +0800 wrote Jiang Liu:
> Hi Stefanin,
> 	As David has mentioned, the warning messages indicates the VGA
> controller hasn't been shut down correctly during reboot and keeps doing
> DMA write operations after loading the new kernel. Do you have found
> any older kernel without this issue?
> 	There is a patch set to solve similar issue for crashdump,
> please refer to https://lkml.org/lkml/2014/1/10/518.
> 
> Thanks!
> Gerry
> 

I still understand. 

Maybe the above patch will cure the symptoms but i will not heal the
cause.

But the driver for the intel VGA must not assume the current state of
the device. It is necessary to setup the whole VGA device during the
probe phase. 

Otherwise when kexec a kernel there are tons of log entries or in many
cases a garbaged screen output and the whole kernels will hang.

- Stefani



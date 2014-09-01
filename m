Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753582AbaIAMk3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 08:40:29 -0400
Received: from mail-qg0-f51.google.com ([209.85.192.51]:50069 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514AbaIAMk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 08:40:27 -0400
Date: Mon, 1 Sep 2014 08:40:23 -0400
From: Tejun Heo <tj@kernel.org>
To: Chuansheng Liu <chuansheng.liu@intel.com>
Cc: MyMailClone@t-online.de, rjw@rjwysocki.net, aaron.lu@intel.com,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ata: Disabling the async PM for JMicron chip 363/361
Message-ID: <20140901124023.GA3255@mtj.dyndns.org>
References: <1409531883-17260-1-git-send-email-chuansheng.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409531883-17260-1-git-send-email-chuansheng.liu@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 01, 2014 at 08:38:03AM +0800, Chuansheng Liu wrote:
> After enabled the PM feature that supporting async noirq(76569faa62
> (PM / sleep: Asynchronous threads for resume_noirq)),
> Jay hit the system resuming issue, that one of the JMicron controller
> can not be powered up.
> 
> His device tree is like below:
>              +-1c.4-[02]--+-00.0  JMicron Technology Corp. JMB363 SATA/IDE Controller
>              |            \-00.1  JMicron Technology Corp. JMB363 SATA/IDE Controller
> 
> After investigation, we found the the Micron chip 363 included
> one SATA controller(0000:02:00.0) and one PATA controller(0000:02:00.1),
> these two controllers do not have parent-children relationship,
> but the PATA controller only can be powered on after the SATA controller
> has finished the powering on.
> 
> If we enabled the async noirq(), then the below error is hit during noirq
> phase:
> pata_jmicron 0000:02:00.1: Refused to change power state, currently in D3
> 
> Here for JMicron chip 363/361, we need forcedly to disable the async method.
> 
> Bug detail: https://bugzilla.kernel.org/show_bug.cgi?id=81551
> 
> Reported-by: Jay <MyMailClone@t-online.de>
> Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>

Applied to libata/for-3.17-fixes.

Thanks.

-- 
tejun

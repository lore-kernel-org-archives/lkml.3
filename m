Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760490Ab3GSPSl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 11:18:41 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:32844 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760300Ab3GSPSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 11:18:40 -0400
Message-ID: <51E958CC.5070906@wwwdotorg.org>
Date: Fri, 19 Jul 2013 09:18:36 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Russell King <linux@arm.linux.org.uk>
CC: ebiederm@xmission.com, Simon Horman <horms@verge.net.au>,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Will Deacon <will.deacon@arm.com>, Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] ARM: kexec: validate CPU hotplug support
References: <1373582931-11956-1-git-send-email-swarren@wwwdotorg.org>
In-Reply-To: <1373582931-11956-1-git-send-email-swarren@wwwdotorg.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2013 04:48 PM, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
> 
> Architectures should fully validate whether kexec is possible as part of
> machine_kexec_prepare(), so that user-space's kexec_load() operation can
> report any problems. Performing validation in machine_kexec() itself is
> too late, since it is not allowed to return.
> 
> Prior to this patch, ARM's machine_kexec() was testing after-the-fact
> whether machine_kexec_prepare() was able to disable all but one CPU.
> Instead, modify machine_kexec_prepare() to validate all conditions
> necessary for machine_kexec_prepare()'s to succeed. BUG if the validation
> succeeded, yet disabling the CPUs didn't actually work.

Russell, does this look good to put into the ARM patch tracker?

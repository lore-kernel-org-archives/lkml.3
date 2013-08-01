Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755780Ab3HANpl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 09:45:41 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39574 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755293Ab3HANpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 09:45:39 -0400
Date: Thu, 1 Aug 2013 14:41:19 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: ebiederm@xmission.com, Simon Horman <horms@verge.net.au>,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Will Deacon <will.deacon@arm.com>, Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] ARM: kexec: validate CPU hotplug support
Message-ID: <20130801134119.GG24642@n2100.arm.linux.org.uk>
References: <1373582931-11956-1-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373582931-11956-1-git-send-email-swarren@wwwdotorg.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 11, 2013 at 04:48:51PM -0600, Stephen Warren wrote:
> +int platform_can_cpu_hotplug(void)
> +{
> +	if (!IS_ENABLED(CONFIG_HOTPLUG_CPU) || !smp_ops.cpu_kill)
> +		return 0;

This is an inappropriate usage of IS_ENABLED().  When hotplug CPU is
disabled, there is no cpu_kill member in smp_ops, so this leads to
build failure.

Dropping your patch.

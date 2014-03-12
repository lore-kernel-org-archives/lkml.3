Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537AbaCLQhE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 12:37:04 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:39909 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755374AbaCLQgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 12:36:23 -0400
Message-ID: <53208CDD.7030106@ti.com>
Date: Thu, 13 Mar 2014 00:35:41 +0800
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Felipe Balbi <balbi@ti.com>, <robh+dt@kernel.org>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>
CC: <linux@arm.linux.org.uk>, <devicetree@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm: boot: dts: build keystone devicetree blob
References: <1394639330-1288-1-git-send-email-balbi@ti.com>
In-Reply-To: <1394639330-1288-1-git-send-email-balbi@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 March 2014 11:48 PM, Felipe Balbi wrote:
> Currently, even when building keystone only
> kernel builds, DTB won't get build because
> we lack a Makefile rule to get it compiled.
> 
> This patch adds that rule so mainline kernel
> users have a chance to use up-to-date DTB on
> keystone 2 platforms.
> 
> Signed-off-by: Felipe Balbi <balbi@ti.com>
> ---
>
We have been building dtbs with explicit command
instead of dtbs since it was just one dtb so far
supported. Was planning to add the rule once more
boards get added. Now with Lamarr and Edision in
for next merge window, will do that post 3.15-rc1.

> note that I just tried this on top of linux-next
> (commit 69d5cdda16b3c9767b82d80b07edb9bb056448e3)
> and, even though dtb builds fine, I still couldn't
> get keystone_defconfig uImage to boot fine.
> 
> It's probably my LOADADDR which is wrong.
> 
> Santosh, what's the LOADADDR I should be using
> for keystone boots ?
>
LOADADDR is same 0x80008000. You might have missed
to configure the environment u-boot variable to
disable higher address space switch.
'setenv mem_lpae 0'. Also ensure to update
the boot loaders since the default ones comes with
EVM are long back outdated.

Regards,
Santosh
 


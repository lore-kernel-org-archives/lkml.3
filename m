Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564AbbAIQfY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 11:35:24 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:55915 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751659AbbAIQfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 11:35:23 -0500
Date: Fri, 9 Jan 2015 16:35:05 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: "Jon Medhurst (Tixy)" <tixy@linaro.org>
Cc: Wang Nan <wangnan0@huawei.com>, masami.hiramatsu.pt@hitachi.com,
        lizefan@huawei.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v20 08/11] ARM: kprobes: enable OPTPROBES for ARM 32
Message-ID: <20150109163505.GS12302@n2100.arm.linux.org.uk>
References: <1420457376-77366-1-git-send-email-wangnan0@huawei.com>
 <1420785456-21900-1-git-send-email-wangnan0@huawei.com>
 <1420799154.4160.19.camel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420799154.4160.19.camel@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 09, 2015 at 10:25:54AM +0000, Jon Medhurst (Tixy) wrote:
> On Fri, 2015-01-09 at 14:37 +0800, Wang Nan wrote:
> > +			"	and	r4, sp, #4\n"
> > +			"	sub	sp, sp, r4\n"
> > +#if __LINUX_ARM_ARCH__ >= 5
> > +			"	blx	r2\n"
> > +#else
> > +			"	mov     lr, pc\n"
> > +			"	bx	r2\n"
> 
> I think the BX instruction is not supported for ARMv4 chips that don't
> have Thumb support (e.g. SA110), at least an old ARM ARM I have says BX
> is supported on "Version 5 and above, and T variants of version 4".

Correct.

> Though building assabet_defconfig with kprobes enabled doesn't produce
> an error for the BX instruction (!?)

Which config are you using?  Does it have CONFIG_CPU_32v4 enabled?
That should result in "-D__LINUX_ARM_ARCH__=4 -march=armv4" being
passed to the compiler (please check with make V=1).

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.

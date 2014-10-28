Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504AbaJ1Oh5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 10:37:57 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:58747 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253AbaJ1Oh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 10:37:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Xia Kaixu <kaixu.xia@linaro.org>, arm@kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 3/5] ARM: restrict CPU_BIG_ENDIAN configuration option
Date: Tue, 28 Oct 2014 15:37:52 +0100
Message-ID: <3137318.QMDnWOWDgo@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141028140021.GD27405@n2100.arm.linux.org.uk>
References: <1414503095-25986-1-git-send-email-kaixu.xia@linaro.org> <1414503095-25986-4-git-send-email-kaixu.xia@linaro.org> <20141028140021.GD27405@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Nlu0uKjkznOOm7fgimJb/5ecZenGtdKNx2//t3CM1jW
 Skdwn7+a3Qf21rTVX6Y/BbuKOVKnlkZI+oXRqsGYBcNJJb3zDK
 DLXm80AlucJl+nD2NxUWgwpZlxPk1bjGMoVqStNAFhZfpjJm3J
 NjFguURWE06EflZ6n/ZNPRRkTK82OqKFDvcSaTRz3o8oz9jEry
 cFhLx+9qhTtZqqnWsmmF3XuYuTzm4DbgAFIJfp8pc21LvuCODh
 81zmEq7HPFaJgSRQot+Ef1dfiE9XsT18MECbk4gDwUQ7QMBgiQ
 0XDjVSZoP+6pvXkmQCebem01knPYy6xralMS65iPKhKr3DoINj
 X7EELlnnoXGqtwOInjIQ=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 October 2014 14:00:22 Russell King - ARM Linux wrote:
> On Tue, Oct 28, 2014 at 09:31:33PM +0800, Xia Kaixu wrote:
> > Some platforms don't work when CPU_BIG_ENDIAN is enabled.
> > So It can get a dependency on !ARCH_MULTIPLATFORM_STRICT.
> 
> What if big endian wants to build a multiplatform kernel?

They can turn off ARCH_MULTIPLATFORM_STRICT easily.
 
> This doesn't look right to me.  Instead, we should be arranging for
> those which do not work in BE mode to depend on !CPU_BIG_ENDIAN.
> Yes, it's a larger patch but IMHO is a much more correct solution.

I've also asked Kaixu to put this one in, mostly for the side-effect
of getting an allmodconfig kernel to be little-endian, but also
because we don't really know which platforms are ok to run on
big-endian. I would assume that most platforms have at least some
platform-specific drivers that are not endian-clean, and even if
the platform works big-endian in principle, it's unclear if
everything works.

The most important aspect is probably user space though: If you
build a multiplatform kernel (or one for ARMv4/5 and one for ARMv6/7)
that runs on all sorts of machines, you can have a common user space
that is built for ARMv4 little-endian and that will run everywhere.
As soon as you enable big-endian, you have a fundamental ABI change
and nothing works unless you replace the entire user space side.

	Arnd

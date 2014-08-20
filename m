Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993AbaHTKBd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 06:01:33 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:55755 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750944AbaHTKBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 06:01:32 -0400
Date: Wed, 20 Aug 2014 11:01:18 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Wang Long <long.wanglong@huawei.com>
Cc: nicolas.pitre@linaro.org, ben.dooks@codethink.co.uk,
        taras.kondratiuk@linaro.org, heiko@sntech.de,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: avoid corrupts register in mcaro kputc kphex etc.
Message-ID: <20140820100118.GH30401@n2100.arm.linux.org.uk>
References: <1408528202-152139-1-git-send-email-long.wanglong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408528202-152139-1-git-send-email-long.wanglong@huawei.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2014 at 05:50:02PM +0800, Wang Long wrote:
> when use macro 'kputc' kphex' to print the content of
> register r0-r3, they will corrupts these registers.
> 
> the same as the macro 'debug_reloc_start' and 'debug_reloc_end'.
> 
> so using 'push' when enter the macro and 'pop' when leave
> the macro to fix it.

NAK.  These are expected to corrupt r0-r3, and it is expected that
users of these macros save r0-r3 if they contain important values.
This is especially important as these get used in places where there
is no stack to save registers.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.

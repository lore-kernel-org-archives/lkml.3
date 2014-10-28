Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681AbaJ1OAn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 10:00:43 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:47214 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751986AbaJ1OAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 10:00:41 -0400
Date: Tue, 28 Oct 2014 14:00:22 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Xia Kaixu <kaixu.xia@linaro.org>
Cc: arm@kernel.org, arnd@arndb.de, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 3/5] ARM: restrict CPU_BIG_ENDIAN configuration option
Message-ID: <20141028140021.GD27405@n2100.arm.linux.org.uk>
References: <1414503095-25986-1-git-send-email-kaixu.xia@linaro.org>
 <1414503095-25986-4-git-send-email-kaixu.xia@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414503095-25986-4-git-send-email-kaixu.xia@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 09:31:33PM +0800, Xia Kaixu wrote:
> Some platforms don't work when CPU_BIG_ENDIAN is enabled.
> So It can get a dependency on !ARCH_MULTIPLATFORM_STRICT.

What if big endian wants to build a multiplatform kernel?

This doesn't look right to me.  Instead, we should be arranging for
those which do not work in BE mode to depend on !CPU_BIG_ENDIAN.
Yes, it's a larger patch but IMHO is a much more correct solution.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.

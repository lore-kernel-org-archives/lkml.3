Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756804AbaFROcY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 10:32:24 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:50408 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756769AbaFROcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 10:32:23 -0400
Date: Wed, 18 Jun 2014 15:31:45 +0100
From: Will Deacon <will.deacon@arm.com>
To: Andrey Ryabinin <a.ryabinin@samsung.com>
Cc: Russell King <linux@arm.linux.org.uk>, Nicolas Pitre <nico@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] arm: get rid of hardcoded assumptions about kernel stack
 size
Message-ID: <20140618143145.GH2186@arm.com>
References: <1403099422-850-1-git-send-email-a.ryabinin@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403099422-850-1-git-send-email-a.ryabinin@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 02:50:22PM +0100, Andrey Ryabinin wrote:
> Changing kernel stack size on arm is not as simple as it should be:
> 1) THRED_SIZE macro doen't respect PAGE_SIZE and THREAD_SIZE_ORDER

THREAD_SIZE

> 2) stack size is hardcoded in get_thread_info macro
> 
> This patch fixes it by caculating THREAD_SIZE and thread_info address
> taking into account PAGE_SIZE and THREAD_SIZE_ORDER.
> 
> Now changing stack size becomes simply changing THREAD_SIZE_ORDER.

Curious: is this just a cleanup, or are you actually running out of kernel
stack on an ARM platform?

Will

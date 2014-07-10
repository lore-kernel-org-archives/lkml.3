Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157AbaGJIsh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 04:48:37 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:51809 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751344AbaGJIsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 04:48:35 -0400
Date: Thu, 10 Jul 2014 09:48:10 +0100
From: Will Deacon <will.deacon@arm.com>
To: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: "wad@chromium.org" <wad@chromium.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND PATCH v4 2/2] arm64: Add seccomp support
Message-ID: <20140710084810.GD2449@arm.com>
References: <1404459115-8292-1-git-send-email-takahiro.akashi@linaro.org>
 <1404459115-8292-3-git-send-email-takahiro.akashi@linaro.org>
 <20140709111239.GH9485@arm.com>
 <53BE17AE.7080301@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53BE17AE.7080301@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2014 at 05:33:50AM +0100, AKASHI Takahiro wrote:
> Will,
> 
>  >  (1) Updating syscallno based on w8, but this ties us to the current ABI
>  >      and could get messy if this register changes in the future.
> 
> So, is this the conclusion that I should follow?

I think so, with the exception that if the tracer/debugger sets it to -1 to
abort the syscall, then we should restore the original value.

Will

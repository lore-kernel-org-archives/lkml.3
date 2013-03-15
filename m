Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212Ab3CORfQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 13:35:16 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36359 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753772Ab3CORfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 13:35:15 -0400
Date: Fri, 15 Mar 2013 17:34:52 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: kpark3469@gmail.com
Cc: keun-o.park@windriver.com, dave.martin@linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3] arm: fix a wrong value returned from CALLER_ADDRn
Message-ID: <20130315173452.GQ4977@n2100.arm.linux.org.uk>
References: <1363235701-21342-1-git-send-email-kpark3469@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363235701-21342-1-git-send-email-kpark3469@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 14, 2013 at 01:35:01PM +0900, kpark3469@gmail.com wrote:
> From: Sahara <keun-o.park@windriver.com>
> 
> This makes return_address() return a correct value for CALLER_ADDRn.
> To have a correct value from CALLER_ADDRn, we need to fix three points.
> 
> * The unwind_frame() does not update frame->lr but frame->pc for backtrace.
> So frame->pc is meaningful for backtrace.
> 
> * data.level should be adjusted by adding 2 additional iteration levels.
> With the current +1 level adjustment, the result of CALLER_ADDR1 will
> be the same return address with CALLER_ADDR0.
> 
> * The initialization of data.addr to NULL is needed.
> When unwind_fame() fails right after data.level reaches zero,
> the routine returns data.addr which has uninitialized garbage value.
> 
> Signed-off-by: Sahara <keun-o.park@windriver.com>
> Reviewed-by: Dave Martin <dave.martin@linaro.org>

Please send this to the patch system.  I think we should let this sit
in -next for a bit (which we'll get anyway) to see what the effect is.

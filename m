Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757985Ab3KHRFG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 12:05:06 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:56534 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757967Ab3KHRFA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 12:05:00 -0500
Message-ID: <527D19A2.5050604@ti.com>
Date: Fri, 8 Nov 2013 12:04:34 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: <linux-arm-kernel@lists.infradead.org>,
        Mahesh Sivasubramanian <msivasub@codeaurora.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: Save/Restore 64-bit TTBR registers on LPAE suspend/resume
References: <1383873633-2499-1-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1383873633-2499-1-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 November 2013 08:20 PM, Stephen Boyd wrote:
> From: Mahesh Sivasubramanian <msivasub@codeaurora.org>
> 
> LPAE enabled kernels use the 64-bit version of TTBR0 and TTBR1
> registers. If we're running an LPAE kernel, fill the upper half
> of TTBR0 with 0 because we're setting it to the idmap here (the
> idmap is guaranteed to be < 4Gb) and fully restore TTBR1 instead
> of just restoring the lower 32 bits. Failure to do so can cause
> failures on resume from suspend when these registers are only
> half restored.
> 
> Signed-off-by: Mahesh Sivasubramanian <msivasub@codeaurora.org>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
Looks like the trick of TTBR1 as discussed on irc worked for you.
Patch looks good to me. 
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>



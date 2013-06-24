Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751444Ab3FXOFE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 10:05:04 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:38451 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750845Ab3FXOFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 10:05:02 -0400
Date: Mon, 24 Jun 2013 15:04:24 +0100
From: Will Deacon <will.deacon@arm.com>
To: Christopher Covington <cov@codeaurora.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Nicolas Pitre <nico@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: Add support for LPAE style CONTEXTIDR
Message-ID: <20130624140424.GA24861@mudshark.cambridge.arm.com>
References: <1372080405-13365-1-git-send-email-cov@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372080405-13365-1-git-send-email-cov@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christopher,

On Mon, Jun 24, 2013 at 02:26:45PM +0100, Christopher Covington wrote:
> Using the long-descriptor translation table format changes
> the layout of the CONTEXTIDR register.
> 
> Signed-off-by: Christopher Covington <cov@codeaurora.org>
> ---
>  arch/arm/mm/context.c | 37 +++++++++++++++++++++++++++----------
>  1 file changed, 27 insertions(+), 10 deletions(-)

Hmm, I'd deliberately written the code as-is, so that debuggers wouldn't
need context-sensitive parsing of the contextidr register depending on the
type of page tables in use.

What's the advantage of this approach, other than you get an extra byte's
worth of PID?

Will

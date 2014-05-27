Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696AbaE0OC5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 10:02:57 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:64789 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441AbaE0OCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 10:02:52 -0400
Date: Tue, 27 May 2014 16:02:47 +0200
From: Christoffer Dall <christoffer.dall@linaro.org>
To: Jungseok Lee <jays.lee@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Catalin.Marinas@arm.com, Marc Zyngier <Marc.Zyngier@arm.com>,
        linux-kernel@vger.kernel.org,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        steve.capper@linaro.org, sungjinn.chung@samsung.com,
        Arnd Bergmann <arnd@arndb.de>, kgene.kim@samsung.com,
        ilho215.lee@samsung.com
Subject: Re: [RESEND PATCH v6 7/7] arm64: KVM: Implement 4 levels of
 translation tables for HYP and stage2
Message-ID: <20140527140247.GK31431@lvm>
References: <000001cf6dc8$60eaa170$22bfe450$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000001cf6dc8$60eaa170$22bfe450$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2014 at 06:56:00PM +0900, Jungseok Lee wrote:
> This patch adds 4 levels of translation tables implementation for both
> HYP and stage2.
> 
> Both symmetric and asymmetric configurations for page size and translation
> levels are are validated on Fast Models:
> 
>  1) 4KB  + 3 levels guest on 4KB  + 4 levels host
>  2) 4KB  + 4 levels guest on 4KB  + 4 levels host
>  3) 64KB + 2 levels guest on 4KB  + 4 levels host
>  4) 4KB  + 3 levels guest on 64KB + 2 levels host
>  5) 4KB  + 4 levels guest on 64KB + 2 levels host
>  6) 64KB + 2 levels guest on 64KB + 2 levels host
> 
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Christoffer Dall <christoffer.dall@linaro.org>
> Signed-off-by: Jungseok Lee <jays.lee@samsung.com>
> Reviewed-by: Sungjinn Chung <sungjinn.chung@samsung.com>
> Acked-by: Kukjin Kim <kgene.kim@samsung.com>

I'm going to hold off giving this a final review until we have that
previous VTTBR_X patch sorted out.

Given the number of open questions in that one, I recommend you factor
that patch out of this patch set, get that sorted out first, and then
send a new version of this patch set once we have an agreement on the
other patch.

-Christoffer

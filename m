Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806Ab3JNQB2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 12:01:28 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:54242 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969Ab3JNQB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 12:01:26 -0400
Message-ID: <525C1550.5090208@gmail.com>
Date: Tue, 15 Oct 2013 00:01:20 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Will Deacon <Will.Deacon@arm.com>, Jiang Liu <jiang.liu@huawei.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christopher Covington <cov@codeaurora.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFT PATCH v2 3/4] arm64: reduce duplicated code when saving/restoring
 FPSIMD for signal handling
References: <1381674029-430-1-git-send-email-liuj97@gmail.com> <1381674029-430-3-git-send-email-liuj97@gmail.com> <20131014154401.GG7682@arm.com>
In-Reply-To: <20131014154401.GG7682@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2013 11:44 PM, Catalin Marinas wrote:
> On Sun, Oct 13, 2013 at 03:20:19PM +0100, Jiang Liu wrote:
>> +void fpsimd_prepare_sigctx(struct fpsimd_state *state)
>> +{
>> +	/* dump the hardware registers to the fpsimd_state structure */
>> +	fpsimd_save_state(state);
>> +	fpsimd_clear_fpsr();
>> +}
> 
> What don't particularly like is that you save the FP context and then
> corrupt it. Can we get preempted after this function and before we save
> it on the signal stack?
> 
Yeah, good point!
There's a race window to get preempted, will fix it.
Thanks!
Gerry


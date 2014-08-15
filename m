Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751547AbaHOPXr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 11:23:47 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:58146 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306AbaHOPXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 11:23:46 -0400
Message-ID: <53EE25FB.4070201@hitachi.com>
Date: Sat, 16 Aug 2014 00:23:39 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Wang Nan <wangnan0@huawei.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "Jon Medhurst (Tixy)" <tixy@linaro.org>, ananth@in.ibm.com,
        anil.s.keshavamurthy@intel.com, davem@davemloft.net,
        Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        peifeiyue@huawei.com, lizefan@huawei.com
Subject: Re: [PATCH v4] kprobes: arm: enable OPTPROBES for ARM 32
References: <1407819388-52145-1-git-send-email-wangnan0@huawei.com>
In-Reply-To: <1407819388-52145-1-git-send-email-wangnan0@huawei.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/08/12 13:56), Wang Nan wrote:
> +/* Caller must ensure addr & 3 == 0 */
> +static int can_optimize(unsigned long paddr)
> +{
> +	return 1;
> +}

As we have talked on another thread, we'd better filter-out all stack-pushing
instructions here, since (as you said) that will corrupt pt_regs on the stack.

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com



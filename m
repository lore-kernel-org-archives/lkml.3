Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869AbaHLTiP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 15:38:15 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:37404 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754794AbaHLTiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 15:38:13 -0400
Message-ID: <53EA6D24.3000609@codeaurora.org>
Date: Tue, 12 Aug 2014 12:38:12 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: linux-kernel@vger.kernel.org, Nicolas Pitre <nicolas.pitre@linaro.org>,
        Rob Herring <robh@kernel.org>, Laura Abbott <lauraa@codeaurora.org>,
        Liu hua <sdu.liu@huawei.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Will Deacon <will.deacon@arm.com>,
        Doug Anderson <dianders@chromium.org>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Doug Anderson <dianders@google.com>, Rabin Vincent <rabin@rab.in>,
        Nikolay Borisov <Nikolay.Borisov@arm.com>,
        Mark Salter <msalter@redhat.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 5/7] arm: kgdb: Handle read-only text / modules
References: <1407867869-5194-1-git-send-email-keescook@chromium.org> <1407867869-5194-6-git-send-email-keescook@chromium.org>
In-Reply-To: <1407867869-5194-6-git-send-email-keescook@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/14 11:24, Kees Cook wrote:
> @@ -244,6 +248,32 @@ void kgdb_arch_exit(void)
>  	unregister_die_notifier(&kgdb_notifier);
>  }
>  
> +int kgdb_arch_set_breakpoint(struct kgdb_bkpt *bpt)
> +{
> +	int err;
> +
> +	/* patch_text() only supports int-sized breakpoints */
> +	if (sizeof(int) != BREAK_INSTR_SIZE)
> +		return -EINVAL;

Could this be a BUILD_BUG_ON too?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation


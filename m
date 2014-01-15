Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751760AbaAOAzK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 19:55:10 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60409 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750918AbaAOAzH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 19:55:07 -0500
Message-ID: <52D5DC51.9010606@zytor.com>
Date: Tue, 14 Jan 2014 16:54:41 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: mingo@kernel.org, linux-kernel@vger.kernel.org,
        aravind.gopalakrishnan@amd.com, tglx@linutronix.de, bp@suse.de,
        hpa@linux.intel.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86, cpu, amd: Add workaround for family 16h,
 erratum 793
References: <20140114230711.GS29865@pd.tnic> <tip-3b56496865f9f7d9bcb2f93b44c63f274f08e3b6@git.kernel.org>
In-Reply-To: <tip-3b56496865f9f7d9bcb2f93b44c63f274f08e3b6@git.kernel.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2014 04:45 PM, tip-bot for Borislav Petkov wrote:
> +		rdmsrl(MSR_AMD64_LS_CFG, val);
> +		if (!(val & BIT(15)))
> +			wrmsrl(MSR_AMD64_LS_CFG, val | BIT(15));

Incidentally, I'm wondering if we shouldn't have a
set_in_msr()/clear_in_msr() set of functions which would incorporate the
above construct:

void set_in_msr(u32 msr, u64 mask)
{
	u64 old, new;

	old = rdmsrl(msr);
	new = old | mask;
	if (old != new)
		wrmsrl(msr, new);
}

... and the obvious equivalent for clear_in_msr().

The perhaps only question is if it should be "set/clear_bit_in_msr()"
rather than having to haul a full 64-bit mask in the common case.

	-hpa



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469Ab3CTAGN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 20:06:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41892 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752651Ab3CTAGL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 20:06:11 -0400
Message-ID: <5148FCE1.9010009@zytor.com>
Date: Tue, 19 Mar 2013 17:03:45 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: "Yu, Fenghua" <fenghua.yu@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        "penguin-kernel@i-love.sakura.ne.jp" 
	<penguin-kernel@i-love.sakura.ne.jp>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Subject: Re: [PATCH] x86/microcode_intel_early.c: Get 32-bit physical address
 by __pa_nodebug()
References: <1363705484-27645-1-git-send-email-fenghua.yu@intel.com> <CAE9FiQVhziaB9vEUNw-EBvA1Bfey=uMEw+CERuqSyPgU3qCJUA@mail.gmail.com> <3E5A0FA7E9CA944F9D5414FEC6C7122055946F9E@ORSMSX105.amr.corp.intel.com> <CAE9FiQVHqt+Tx4vLuHQUQoZ-PcaGO4-oq7SjA5oq_M6mJh9DDQ@mail.gmail.com>
In-Reply-To: <CAE9FiQVHqt+Tx4vLuHQUQoZ-PcaGO4-oq7SjA5oq_M6mJh9DDQ@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2013 04:48 PM, Yinghai Lu wrote:
> 
> So do you mean we have to change all __pa_symbol before
> setup.c::setup_arch/find_low_pfn_range ?
> because only at that time max_low_pfn get setup.
> 

No, I suspect the problem is that the debugging code fails to notice
that max_low_pfn isn't set up yet because it is in linear mode, and so
it reads the wrong address when it checks max_low_pfn.

	-hpa


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145AbaAQRbf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 12:31:35 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58055 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753049AbaAQRbO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 12:31:14 -0500
Message-ID: <52D968C5.9080102@zytor.com>
Date: Fri, 17 Jan 2014 09:30:45 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Ren Qiaowei <qiaowei.ren@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] x86, mpx: hook #BR exception handler to allocate
 bound tables
References: <1389518403-7715-1-git-send-email-qiaowei.ren@intel.com> <1389518403-7715-2-git-send-email-qiaowei.ren@intel.com> <20140112092019.GA3664@pd.tnic> <52D35ABB.8070904@intel.com> <20140113103808.GC5388@pd.tnic> <52D95AD4.6060603@zytor.com> <20140117164855.GF8715@pd.tnic> <52D95F93.3030000@zytor.com> <20140117165656.GA9024@pd.tnic> <52D96149.8070706@zytor.com> <20140117170410.GH8715@pd.tnic>
In-Reply-To: <20140117170410.GH8715@pd.tnic>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2014 09:04 AM, Borislav Petkov wrote:
> On Fri, Jan 17, 2014 at 08:58:49AM -0800, H. Peter Anvin wrote:
>> #BR exception from kernel space -> panic.
>>
>> We have tons of rules on kernel code... e.g. no FPU usage.  This one is
>> minor in comparison.
> 
> So basically review should catch those wrong BOUND usages?
> 

Yes.  It would take some serious effort to get BOUND or MPX instructions
into the kernel -- you'd have to put them in inline assembly, and BOUND
doesn't even exist in 64-bit mode.

	-hpa


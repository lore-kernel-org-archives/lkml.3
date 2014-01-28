Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180AbaA1Gwn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 01:52:43 -0500
Received: from mga09.intel.com ([134.134.136.24]:54949 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750816AbaA1Gwm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 01:52:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,734,1384329600"; 
   d="scan'208";a="445649524"
Message-ID: <52E75261.5030307@intel.com>
Date: Tue, 28 Jan 2014 14:46:57 +0800
From: Ren Qiaowei <qiaowei.ren@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 2/4] x86, mpx: hook #BR exception handler to allocate
 bound tables
References: <1390727338-20487-1-git-send-email-qiaowei.ren@intel.com> <1390727338-20487-3-git-send-email-qiaowei.ren@intel.com> <52E6C33C.8050706@amacapital.net> <52E72573.9090108@intel.com> <CALCETrW0L79gjXRD5J5RZQTiZT+MYDYHQ0u7hoeKP=XVqDT5HA@mail.gmail.com> <52E742A0.8000209@intel.com> <CALCETrUr9FxtmB03XcAFCtWfbfVzLEPmSUZD9HnTqTinS+aWuQ@mail.gmail.com>
In-Reply-To: <CALCETrUr9FxtmB03XcAFCtWfbfVzLEPmSUZD9HnTqTinS+aWuQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2014 02:42 PM, Andy Lutomirski wrote:
> I just read it.  do_trap_no_signal presumably calls fixup_exception
> because #UD uses it and #UD needs that handling.  (I'm guessing that
> there is actually a legitimate use for a kernel fixup on #UD somewhere
> -- there's probably something that isn't covered by cpuid.)
>
> There should not be a #BR from the kernel using the fixup mechanism.
> IMO if the exception comes from the kernel, it should unconditionally
> call die.
>
Oh. I agree with you, and if a #BR from the kernel it should 
unconditionally call die.

	if (!user_mode(regs))
		die("bounds", regs, error_code);

Thanks,
Qiaowei

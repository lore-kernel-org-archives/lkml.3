Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763AbaAQRve (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 12:51:34 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58261 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750937AbaAQRv3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 12:51:29 -0500
Message-ID: <52D96D85.5060708@zytor.com>
Date: Fri, 17 Jan 2014 09:51:01 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Borislav Petkov <bp@alien8.de>, "Ren, Qiaowei" <qiaowei.ren@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] x86, mpx: hook #BR exception handler to allocate
 bound tables
References: <1389518403-7715-1-git-send-email-qiaowei.ren@intel.com>	<1389518403-7715-2-git-send-email-qiaowei.ren@intel.com>	<20140112092019.GA3664@pd.tnic>	<52D35ABB.8070904@intel.com>	<20140113103808.GC5388@pd.tnic>	<9E0BE1322F2F2246BD820DA9FC397ADE014E575D@SHSMSX102.ccr.corp.intel.com>	<20140117164736.GE8715@pd.tnic>	<52D95F77.4030908@zytor.com> <20140117121457.0847cde3@gandalf.local.home>
In-Reply-To: <20140117121457.0847cde3@gandalf.local.home>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2014 09:14 AM, Steven Rostedt wrote:
>>
>>> All I'm trying to say is, it might not be such a good idea to sleep in a
>>> fault handler...
>>
>> A fault handler from user space is really nothing other than a different
>> kind of system call.  It is nothing magic about it.
> 
> Exactly. I was saying that #BR should be just like #PF, as it can
> detect bugs in the kernel too. The first thing the handler should do is
> check to see if the fault occurred in userspace or kernel space. If it
> is userspace, then there's no restrictions. If it is kernel space then
> we should do the bare minimum to report the bug and then kill whatever
> task happened to do it.
> 

Yes.  We call this "oopsing" ;)

	-hpa



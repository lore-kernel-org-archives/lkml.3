Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590AbaAQQbm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 11:31:42 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57024 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752521AbaAQQbk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 11:31:40 -0500
Message-ID: <52D95AD4.6060603@zytor.com>
Date: Fri, 17 Jan 2014 08:31:16 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Ren Qiaowei <qiaowei.ren@intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] x86, mpx: hook #BR exception handler to allocate
 bound tables
References: <1389518403-7715-1-git-send-email-qiaowei.ren@intel.com> <1389518403-7715-2-git-send-email-qiaowei.ren@intel.com> <20140112092019.GA3664@pd.tnic> <52D35ABB.8070904@intel.com> <20140113103808.GC5388@pd.tnic>
In-Reply-To: <20140113103808.GC5388@pd.tnic>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2014 02:38 AM, Borislav Petkov wrote:
> On Mon, Jan 13, 2014 at 11:17:15AM +0800, Ren Qiaowei wrote:
>> Yes, I run this with lockdep enabled.
> 
> Ok, but you still are doing memory allocation in the exception handler,
> AFAICT:
> 

Sure... what is the problem with that?  We do that in several other
exception handlers, e.g. #NM, and of course page faults.  As long as the
exception originates from user space there shouldn't be any issue.

	-hpa



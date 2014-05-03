Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386AbaECWUX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 18:20:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34097 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972AbaECWUW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 18:20:22 -0400
Message-ID: <53656B7A.8050606@zytor.com>
Date: Sat, 03 May 2014 15:19:38 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Andy Lutomirski <luto@amacapital.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        x86@kernel.org, Gleb Natapov <gleb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2] x86: Return to kernel without IRET
References: <6cfe29821979c42cd812878e05577f69f99fafaf.1399074748.git.luto@amacapital.net>	<53646A7E.8010400@zytor.com> <20140503072428.54f89688@gandalf.local.home>
In-Reply-To: <20140503072428.54f89688@gandalf.local.home>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2014 04:24 AM, Steven Rostedt wrote:
> On Fri, 02 May 2014 21:03:10 -0700
> "H. Peter Anvin" <hpa@zytor.com> wrote:
> 
>>
>> I'd really like to see a workload which would genuinely benefit before
>> adding more complexity.  Now... if we can determine that it doesn't harm
>> anything and would solve the NMI nesting problem cleaner than the
>> current solution, that would justify things, too...
>>
> 
> As I stated before. It doesn't solve the NMI nesting problem. It only
> handles page faults. We would have to implement this for breakpoint
> return paths too. Is that a plan as well?
> 

I would assume we would do it for *ALL* the IRETs.  There are only three
IRETs in the kernel last I checked...

	-hpa



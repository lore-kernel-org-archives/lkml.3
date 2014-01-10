Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954AbaAJCOK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 21:14:10 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36240 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753435AbaAJCOI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 21:14:08 -0500
Message-ID: <52CF573F.8030300@zytor.com>
Date: Thu, 09 Jan 2014 18:13:19 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>
CC: halfdog <me@halfdog.net>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: Re: Sanitize CPU-state when switching tasks (was sanitize CPU-state
 when switching from virtual-8086 mode to other task)
References: <52C0C9F4.50101@zytor.com>	<52C196C3.1040300@halfdog.net>	<52C31027.2030101@zytor.com>	<20131231192106.GA22535@phenom.dumpdata.com>	<52C347F0.8070902@zytor.com>	<52CD022E.9040107@halfdog.net>	<52CD8E10.3010204@zytor.com>	<20140108193655.GD5098@pd.tnic>	<52CDC316.4050503@halfdog.net>	<52CDD3AE.4030301@zytor.com>	<20140109225815.GI11594@pd.tnic> <CA+55aFxQnY_PCG_n4=0w-VG=YLXL-yr7oMxyy0WU2gCBAf3ydg@mail.gmail.com>
In-Reply-To: <CA+55aFxQnY_PCG_n4=0w-VG=YLXL-yr7oMxyy0WU2gCBAf3ydg@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2014 04:42 PM, Linus Torvalds wrote:
> On Fri, Jan 10, 2014 at 6:58 AM, Borislav Petkov <bp@alien8.de> wrote:
>>
>> Ok, I was able to reproduce
> 
> Looking at this, I think this is just a bug in our
> restore_fpu_checking() hackery for X86_FEATURE_FXSAVE_LEAK..
> 
> Which also explains why it only triggers on E-350 - it's only relevant
> for those K7/K8 CPU's that use this.
> 
> Maybe just add a fcnlex to before the emms? Something like this
> (TOTALLY UNTESTED!!) attached patch.
> 

OK, that sounds very reasonable.  Boris, halfdog, does something like
this resolve your problem?

	-hpa



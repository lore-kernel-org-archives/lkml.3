Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757725Ab3BSElJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 23:41:09 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38975 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755702Ab3BSElH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 23:41:07 -0500
Message-ID: <512301F7.4020709@zytor.com>
Date: Mon, 18 Feb 2013 20:39:19 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Seiji Aguchi <seiji.aguchi@hds.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Thomas Gleixner (tglx@linutronix.de)" <tglx@linutronix.de>,
        "'mingo@elte.hu' (mingo@elte.hu)" <mingo@elte.hu>,
        "Borislav Petkov (bp@alien8.de)" <bp@alien8.de>,
        Satoru Moriya <satoru.moriya@hds.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>
Subject: Re: [PATCH v9 2/3] trace,x86: add x86 irq vector tracepoints
References: <A5ED84D3BB3A384992CBB9C77DEDA4D414A64C4B@USINDEM103.corp.hds.com>    <511ECE53.8040801@zytor.com>   <1360979993.23152.122.camel@gandalf.local.home>   <511EEAE1.1040106@zytor.com>  <1360981364.23152.123.camel@gandalf.local.home>  <A5ED84D3BB3A384992CBB9C77DEDA4D414ABE178@USINDEM103.corp.hds.com>  <5122BE0C.9020403@zytor.com> <1361247854.23152.198.camel@gandalf.local.home>
In-Reply-To: <1361247854.23152.198.camel@gandalf.local.home>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2013 08:24 PM, Steven Rostedt wrote:
> On Mon, 2013-02-18 at 15:49 -0800, H. Peter Anvin wrote:
> 
>> What about the following:
>>
>>> The base address of the IDT doesn't generally change... the one
>>> exception is when we do the funny NMI workaround.
>>>
>>> For that reason, I would be happier if we just restored the standard
>>> value instead of saving/restoring stuff.
> 
> Basically what you are saying, is to have his code do what the NMI code
> originally did, but can't now, due to there being another IDT table
> (from Seiji's changes).
> 
> static void switch_to_trace_idt(void *arg)
> {
>      load_idt(&trace_idt_descr);
> }
> 
> static void restore_original_idt(void *arg)
> {
>      load_idt(this_cpu_ptr(&idt_descr));
> }
> 

Yes.  If there needs to be handshaking about whose IDT is currently
installed I'm much happier if that handshake is done explicitly, rather
than as a save/restore function which will break when we have to add
another one which for whatever reason isn't nesting.

	-hpa



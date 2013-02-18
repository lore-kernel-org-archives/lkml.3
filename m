Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757722Ab3BRXvh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 18:51:37 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37235 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757686Ab3BRXvf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 18:51:35 -0500
Message-ID: <5122BE0C.9020403@zytor.com>
Date: Mon, 18 Feb 2013 15:49:32 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Seiji Aguchi <seiji.aguchi@hds.com>
CC: Steven Rostedt <rostedt@goodmis.org>, "x86@kernel.org" <x86@kernel.org>,
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
References: <A5ED84D3BB3A384992CBB9C77DEDA4D414A64C4B@USINDEM103.corp.hds.com>   <511ECE53.8040801@zytor.com>  <1360979993.23152.122.camel@gandalf.local.home>  <511EEAE1.1040106@zytor.com> <1360981364.23152.123.camel@gandalf.local.home> <A5ED84D3BB3A384992CBB9C77DEDA4D414ABE178@USINDEM103.corp.hds.com>
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D414ABE178@USINDEM103.corp.hds.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2013 03:45 PM, Seiji Aguchi wrote:
>>> Not-yet-signed-off-by: Steven Rostedt <rostedt@goodmis.org>
>>>
>>> ... so I was holding off on doing anything with it.
>>
>> Heh, and I was waiting for comments from you before doing anything further with it ;-)
>>
>> Email review deadlock!
>
> So, how do you plan to push ahead with this patch?
>
> https://lkml.org/lkml/2013/2/1/532
>
> <snip>
> I think I got all the cases, as NMIs causes the store/restore functions to be re-entrent without any locks.
> <snip>
>
> Steven,
> if you think you got all the cases, you can do more testing.
> What is your concern?
>
> I hope this patch will be included in 3.9.
>

What about the following:

> The base address of the IDT doesn't generally change... the one
> exception is when we do the funny NMI workaround.
>
> For that reason, I would be happier if we just restored the standard
> value instead of saving/restoring stuff.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.


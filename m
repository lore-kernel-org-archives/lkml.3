Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932852Ab3HGRxB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 13:53:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52208 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932144Ab3HGRxA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 13:53:00 -0400
Message-ID: <5202892F.7010804@zytor.com>
Date: Wed, 07 Aug 2013 10:51:43 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Jason Baron <jbaron@akamai.com>
Subject: Re: [PATCH 4/4] x86/jump-label: Show where and what was wrong on
 errors
References: <20130807164934.149920591@goodmis.org>  <20130807165114.147890467@goodmis.org> <20130807172044.GC18272@pd.tnic>  <1375896786.6848.14.camel@gandalf.local.home>  <20130807173744.GD18272@pd.tnic> <1375897584.6848.15.camel@gandalf.local.home>
In-Reply-To: <1375897584.6848.15.camel@gandalf.local.home>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2013 10:46 AM, Steven Rostedt wrote:
> On Wed, 2013-08-07 at 19:37 +0200, Borislav Petkov wrote:
>> On Wed, Aug 07, 2013 at 01:33:06PM -0400, Steven Rostedt wrote:
>>> Right, and this code keeps the same logic as it was before. If it was
>>> disabled by CONFIG_EXPERT, it stays disabled, but at least you get to
>>> see a warning that your kernel may be corrupt now :-)
>>
>> Don't we really want to panic instead of running a corrupt kernel? IOW,
>> to change the logic to panic unconditionally because the image in memory
>> has been violated and not in a good way, at that :-)
> 
> Well, there's lots of places that use BUG() for a corrupt kernel. If you
> are stupid enough to disable it, you get what you asked for.
> 

A bigger issue is probably if panic-on-bug should be the default, with
!panic being an opt-in debugging option.

	-hpa



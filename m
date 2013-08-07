Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757239Ab3HGSqn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 14:46:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52580 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755416Ab3HGSqm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 14:46:42 -0400
Message-ID: <520295C9.5080608@zytor.com>
Date: Wed, 07 Aug 2013 11:45:29 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Jason Baron <jbaron@akamai.com>
Subject: Re: [PATCH 4/4] x86/jump-label: Show where and what was wrong on
 errors
References: <20130807164934.149920591@goodmis.org> <20130807165114.147890467@goodmis.org> <20130807172044.GC18272@pd.tnic> <1375896786.6848.14.camel@gandalf.local.home> <20130807173744.GD18272@pd.tnic> <1375897584.6848.15.camel@gandalf.local.home> <5202892F.7010804@zytor.com> <20130807184114.GK17920@pd.tnic>
In-Reply-To: <20130807184114.GK17920@pd.tnic>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2013 11:41 AM, Borislav Petkov wrote:
> On Wed, Aug 07, 2013 at 10:51:43AM -0700, H. Peter Anvin wrote:
>> A bigger issue is probably if panic-on-bug should be the default, with
>> !panic being an opt-in debugging option.
> 
> Yes, it might make sense although embedded wants to disable CONFIG_BUG
> on systems which cannot report errors:
> 

There is another thread going on to convert BUG to trap even on machines
where CONFIG_BUG is disabled, i.e. CONFIG_BUG would control the metadata
only.  With the configuration option off, you would get the address of
the failure only.

	-hpa



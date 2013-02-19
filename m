Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758764Ab3BSRkF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 12:40:05 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44479 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755229Ab3BSRkE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 12:40:04 -0500
Message-ID: <5123B897.9010607@zytor.com>
Date: Tue, 19 Feb 2013 09:38:31 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>, Boris Ostrovsky <boris.ostrovsky@amd.com>
CC: Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] x86/cpu changes for v3.9
References: <20130219152503.GA14862@gmail.com> <20130219153655.GD26748@pd.tnic> <20130219154721.GA15876@gmail.com>
In-Reply-To: <20130219154721.GA15876@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2013 07:47 AM, Ingo Molnar wrote:
>>
>> Those kill a kvm guest with a #GP. Can we apply the fix for it too pls?
>>
>> http://marc.info/?l=linux-kernel&m=136077007423065&w=2
>
> Linus, please skip this pull request, we'll sort it out.
>

My fault... I was tracking the fix and lost track of the thread.

The problem is that the fix is necessary but not sufficient, as it 
introduces an undesirable host-guest dependency.  In order to allow 
neerw guests to work on older hosts we also should use the 
{rd,wr}msr_safe() functions to manipulate this MSR, with a comment as to 
why.

Boris, could you prepare such a patch, please?

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.


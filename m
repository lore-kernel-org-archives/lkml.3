Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757184Ab3EFV3J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 17:29:09 -0400
Received: from plane.gmane.org ([80.91.229.3]:39346 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756648Ab3EFV3H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 17:29:07 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
Subject: Re: [PATCH] alpha: spinlock: don't perform memory access in locked critical section
Date: Mon, 06 May 2013 22:28:38 +0100
Message-ID: <yw1xmws74x2x.fsf@unicorn.mansr.com>
References: <1367870465-23948-1-git-send-email-will.deacon@arm.com>
	<CAEdQ38HnWbUB=ZNCZeYz8GZH3U4bv_Uag8WL2zT0D=GMcoT+2A@mail.gmail.com>
	<20130506205329.GO25399@ZenIV.linux.org.uk>
	<20130506211238.GA24282@mudshark.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 46-65-204-42.zone16.bethere.co.uk
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
Cancel-Lock: sha1:EAL4apZFMRfAXbYIy29drML7EjQ=
Cc: linux-alpha@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will Deacon <will.deacon@arm.com> writes:

> Hi Al, Matt,
>
> On Mon, May 06, 2013 at 09:53:30PM +0100, Al Viro wrote:
>> On Mon, May 06, 2013 at 01:19:51PM -0700, Matt Turner wrote:
>> 
>> > I'm not sure of the interpretation that LDA counts as a memory access.
>> > 
>> > The manual says it's Ra <- Rbv + SEXT(disp).
>> > 
>> > It's not touching memory that I can see.
>> 
>> More to the point, the same manual gives explicit list of instructions
>> that shouldn't occur between LDx_L and STx_C, and LDA does not belong to any
>> of those.  I suspect that Will has misparsed the notations in there - LDx is
>> present in the list, but it's _not_ "all instructions with mnemonics starting
>> with LD", just the 4 "load integer from memory" ones.  FWIW, instructions
>> with that encoding (x01xxx<a:5><b:5><offs:16>) are grouped so:
>> 	LDAx - LDA, LDAH; load address
>> 	LDx -  LDL, LDQ, LDBU, LDWU; load memory data into integer register
>> 	LDQ_U; load unaligned
>> 	LDx_L - LDL_L, LDQ_L; load locked
>> 	STx_C - STL_C, STQ_C; store conditional
>> 	STx - STL, STQ, STB, STW; store
>> 	STQ_U; store unaligned
>
> Your suspicions are right! I did assume that LDA fell under the LDx class,
> so apologies for the false alarm. I suspect I should try and get out more,
> rather than ponder over this reference manual.

LDA uses the address generation circuitry from the load/store unit, but
it does not actually access memory.  It is merely a convenient way of
performing certain arithmetic operations, be it for scheduling reasons
or for the different range of immediate values available.

-- 
Måns Rullgård
mans@mansr.com


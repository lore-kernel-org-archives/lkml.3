Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756405Ab3H2SS4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 14:18:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40568 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753653Ab3H2SSz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 14:18:55 -0400
Message-ID: <521F9076.1050405@zytor.com>
Date: Thu, 29 Aug 2013 11:18:30 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Jan-Simon_M=F6ller?= <dl9pf@gmx.de>
CC: llvmlinux@lists.linuxfoundation.org, pageexec@freemail.hu, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [llvmlinux] [PATCH] [RFC] [X86] Fix a compilation issue with
 clang.
References: <1377796428-12719-1-git-send-email-dl9pf@gmx.de> <6320951.e8eKRZ5b9s@aragorn.auenland.lan> <521F8ED4.2080009@zytor.com> <3804425.88935NyK6A@aragorn.auenland.lan>
In-Reply-To: <3804425.88935NyK6A@aragorn.auenland.lan>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/2013 11:11 AM, Jan-Simon Möller wrote:
> On Thursday 29 August 2013 11:11:32 H. Peter Anvin wrote:
>> On 08/29/2013 11:00 AM, Jan-Simon Möller wrote:
>>>> You just changed the sematics of the _ASM_* macros... that doesn't seem
>>>> like a great idea.  It's probably okay for the registers, but still...
>>>
>>> Well, we followed your idea for the _ASM_DX macros as you mentioned them
>>> earlier.
>>
>> We can probably do this, because register names are usually not assumed
>> to have spaces around them... so it's probably okay.  Definitely a lot
>> less ugly than the rest.  That being said, if we're going to fix these
>> macros, we should also fix another piece of drain bramage:
>>
>> ALL instances of these have a % prepended.  The % should be part of the
>> macro.
> 
> Ok, I can make a follow-up patch for the above change. Give me a bit to cook 
> it up.
> 

Actually, it might be a bad idea.  In C embedded assembly we sometimes
need %% and sometimes %.

	-hpa



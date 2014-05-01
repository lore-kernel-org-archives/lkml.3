Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719AbaEAWpw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 18:45:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41518 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752695AbaEAWpv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 18:45:51 -0400
Message-ID: <5362CE87.7010908@zytor.com>
Date: Thu, 01 May 2014 15:45:27 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>
CC: Andi Kleen <andi@firstfloor.org>, Andy Lutomirski <luto@amacapital.net>,
        X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/7] x86: Add support for rd/wr fs/gs base
References: <1398723161-21968-1-git-send-email-andi@firstfloor.org> <1398723161-21968-5-git-send-email-andi@firstfloor.org> <535FED4D.5000703@amacapital.net> <20140429233950.GE2382@two.firstfloor.org> <53608180.5070800@zytor.com> <CALCETrVQiZPb1M183Fq61dbFAjnJScuB2y+rdH8BQ+yp-MO+Mw@mail.gmail.com> <20140501211554.GH2382@two.firstfloor.org> <5362C37E.2090603@zytor.com> <20140501221836.GI19657@tassilo.jf.intel.com>
In-Reply-To: <20140501221836.GI19657@tassilo.jf.intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2014 03:18 PM, Andi Kleen wrote:
>> I haven't looked through the flows (I'm at LCE so I have limited screen
>> bandwidth) to see how that would be handled in this case, but in the
>> general paranoid case it comes down to the fact that in this particular
>> subcase we don't necessarily know exactly how many SWAPGS are between us
>> and userspace after we IRET.
> 
> There is none as far as I know. Certainly wasn't any when the code
> was originally written.
> 

This applies for an asynchronous entry from kernel space.  Obviously in
the case where we actually come directly from user space (the stack
frame CS.RPL == 3) then that doesn't apply.

	-hpa



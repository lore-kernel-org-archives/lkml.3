Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751685AbaESWSR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 18:18:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38527 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253AbaESWSO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 18:18:14 -0400
Message-ID: <537A8319.5010100@zytor.com>
Date: Mon, 19 May 2014 15:18:01 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>,
        "Theodore Ts'o" <tytso@mit.edu>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] random: mix all saved registers into entropy pool
References: <20140519211719.GA14563@logfs.org> <20140519212320.GB14563@logfs.org>
In-Reply-To: <20140519212320.GB14563@logfs.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/2014 02:23 PM, Jörn Engel wrote:
> On Mon, 19 May 2014 17:17:19 -0400, Jörn Engel wrote:
>>
>> Experimentation show this to be an excellent entropy source.  Doing 1000
>> boottests with kvm and dumping a hash of the registers for the first
>> 1024 interrupts each, >40% of all hashes were unique and >80% of all
>> hashes occurred less than once 1% of the time.
> 
> And since I previously claimed the opposite, the negative result was
> caused by a kvm oddity.  When starting kvm in the background, it will
> run just fine.  But when starting kvm with "-nographic" in the
> background, the process gets stopped.  No output is generated and the
> output file is not even truncated before kvm is stopped.  Therefore
> every single run will have identical kernel output - that of the
> previous run.
> 
> With that embarrassment out of the way, I find this approach hugely
> valuable.  Even if you disagree with some detail of this patch, we
> should definitely merge something roughly related.
> 
> Jörn
> 

I think this is likely to be particularly valuable during boot.  I can
see it becoming substantially less valuable after that point, but during
boot is when the most critical.

What I do see as an issue is that the value is probably impossible to
quantify, and so I feel more than a bit queasy about giving it
/dev/random credit.  However, making sure the pool is well stirred
during boot is really way more important.

	-hpa


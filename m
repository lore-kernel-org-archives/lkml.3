Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756704Ab3JRRK4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 13:10:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59226 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756533Ab3JRRKy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 13:10:54 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <20131018164218.GB4019@hmsreliant.think-freely.org>
References: <1381510298-20572-1-git-send-email-nhorman@tuxdriver.com> <5259CD44.2000200@zytor.com> <20131018164218.GB4019@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] x86: Run checksumming in parallel accross multiple alu's
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Fri, 18 Oct 2013 10:09:54 -0700
To: Neil Horman <nhorman@tuxdriver.com>
CC: linux-kernel@vger.kernel.org, sebastien.dugue@bull.net,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org
Message-ID: <b6c65074-a35e-4c50-8e97-096e48e0c506@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If implemented properly adcx/adox should give additional speedup... that is the whole reason for their existence.

Neil Horman <nhorman@tuxdriver.com> wrote:
>On Sat, Oct 12, 2013 at 03:29:24PM -0700, H. Peter Anvin wrote:
>> On 10/11/2013 09:51 AM, Neil Horman wrote:
>> > Sébastien Dugué reported to me that devices implementing ipoib
>(which don't have
>> > checksum offload hardware were spending a significant amount of
>time computing
>> > checksums.  We found that by splitting the checksum computation
>into two
>> > separate streams, each skipping successive elements of the buffer
>being summed,
>> > we could parallelize the checksum operation accros multiple alus. 
>Since neither
>> > chain is dependent on the result of the other, we get a speedup in
>execution (on
>> > hardware that has multiple alu's available, which is almost
>ubiquitous on x86),
>> > and only a negligible decrease on hardware that has only a single
>alu (an extra
>> > addition is introduced).  Since addition in commutative, the result
>is the same,
>> > only faster
>> 
>> On hardware that implement ADCX/ADOX then you should also be able to
>> have additional streams interleaved since those instructions allow
>for
>> dual carry chains.
>> 
>> 	-hpa
>> 
>I've been looking into this a bit more, and I'm a bit confused. 
>According to
>this:
>http://www.intel.com/content/www/us/en/intelligent-systems/intel-technology/ia-large-integer-arithmetic-paper.html
>
>by my read, this pair of instructions simply supports 2 carry bit
>chains,
>allowing for two parallel execution paths through the cpu that won't
>block on
>one another.  Its exactly the same as whats being done with the
>universally
>available addcq instruction, so theres no real speedup (that I can
>see).  Since
>we'd either have to use the alternatives macro to support adcx/adox
>here or the
>old instruction set, it seems not overly worth the effort to support
>the
>extension.  
>
>Or am I missing something?
>
>Neil

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.

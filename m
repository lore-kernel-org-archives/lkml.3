Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751510AbaBZDdP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 22:33:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5893 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751114AbaBZDdN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 22:33:13 -0500
Message-ID: <530D6056.40305@redhat.com>
Date: Tue, 25 Feb 2014 20:32:38 -0700
From: Jeff Law <law@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com, Linus Torvalds <torvalds@linux-foundation.org>
CC: Torvald Riegel <triegel@redhat.com>, Will Deacon <will.deacon@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        David Howells <dhowells@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
References: <20140223063426.GT4250@linux.vnet.ibm.com> <CA+55aFxMJvaQhoEwqgN=XA6gDOdZwoZQHdcAnB-FhAri_hK-6Q@mail.gmail.com> <CA+55aFw5tdjmNyHCdcyZ8NPpd1wCgOjLRzstRhp0Njs9azpi8Q@mail.gmail.com> <20140224172110.GO8264@linux.vnet.ibm.com> <CA+55aFyi45f7oaG4MYP41TOc=E8Ze8Om88dV2Lq4F=qebhxt4A@mail.gmail.com> <20140224185341.GU8264@linux.vnet.ibm.com> <CA+55aFzXyob0aKnv1u7Stbu0rH5Aq2jaA1rHb=TvQe9c1KY0oQ@mail.gmail.com> <20140224223701.GC8264@linux.vnet.ibm.com> <CA+55aFxGaKtvx5YnOFC5hU9+ischxn=LN_yWiqjXwpNZePvWmw@mail.gmail.com> <CA+55aFwo9ZKxyN76cnkN7iQi7pKB+_tVD=re+RoMP4MiSajC8w@mail.gmail.com> <20140226001558.GY8264@linux.vnet.ibm.com>
In-Reply-To: <20140226001558.GY8264@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/25/14 17:15, Paul E. McKenney wrote:
>> I have for the last several years been 100% convinced that the Intel
>> memory ordering is the right thing, and that people who like weak
>> memory ordering are wrong and should try to avoid reproducing if at
>> all possible. But given that we have memory orderings like power and
>> ARM, I don't actually see a sane way to get a good strong ordering.
>> You can teach compilers about cases like the above when they actually
>> see all the code and they could poison the value chain etc. But it
>> would be fairly painful, and once you cross object files (or even just
>> functions in the same compilation unit, for that matter), it goes from
>> painful to just "ridiculously not worth it".
>
> And I have indeed seen a post or two from you favoring stronger memory
> ordering over the past few years.  ;-)
I couldn't agree more.

>
> Are ARM and Power really the bad boys here?  Or are they instead playing
> the role of the canary in the coal mine?
That's a question I've been struggling with recently as well.  I suspect 
they (arm, power) are going to be the outliers rather than the canary. 
While the weaker model may give them some advantages WRT scalability, I 
don't think it'll ultimately be enough to overcome the difficulty in 
writing correct low level code for them.

Regardless, they're here and we have to deal with them.


Jeff

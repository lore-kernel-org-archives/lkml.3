Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544Ab3ITEoe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 00:44:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39832 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753060Ab3ITEoc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 00:44:32 -0400
Message-ID: <523BD277.2040302@zytor.com>
Date: Thu, 19 Sep 2013 23:43:35 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Mike Galbraith <bitbucket@online.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
Subject: Re: [PATCH 01/11] x86: Use asm goto to implement better modify_and_test()
 functions
References: <20130917082838.218329307@infradead.org> <20130917091143.387880231@infradead.org> <CA+55aFyVZNb3ZrLfh5FkV4E_P5_LE4-LpDHBwFNp=W1H7CnSBg@mail.gmail.com> <4ec87843-c29a-401a-a54f-2cd4d61fba62@email.android.com> <20130919083102.GB11427@tassilo.jf.intel.com>
In-Reply-To: <20130919083102.GB11427@tassilo.jf.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2013 03:31 AM, Andi Kleen wrote:
> On Wed, Sep 18, 2013 at 02:02:37PM -0500, H. Peter Anvin wrote:
>> Yes, a bit sad.  We allow bracketing with the get/put_user_try/catch blocks, but that is x86-specific.
>>
>> I don't think a generic option is possible without compiler support, but it might be possible to do better than we do know.
>
> Letting the compiler do it is a bit risky, because it may open it up for
> really large blocks, thus defeating the security advantages.
>
> -Andi
>

The compiler support. if done right, should avoid unannotated memory 
references.  This is a pretty big job in the compiler, though.

	-hpa


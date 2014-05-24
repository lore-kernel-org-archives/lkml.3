Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751520AbaEXMYq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 08:24:46 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:52497 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208AbaEXMYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 08:24:44 -0400
Message-ID: <5380387E.50308@gmail.com>
Date: Sat, 24 May 2014 08:13:18 +0200
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Miller <davem@davemloft.net>
CC: mtk.manpages@gmail.com, linux-kernel@vger.kernel.org,
        linux-man@vger.kernel.org, netdev@vger.kernel.org, neleai@seznam.cz,
        caitlin.bestler@gmail.com, nhorman@tuxdriver.com,
        eliedebrauwer@gmail.com, steve@chygwyn.com,
        remi.denis-courmont@nokia.com, paul@paul-moore.com,
        chris.friesen@windriver.com
Subject: Re: [PATCH/RFC] Re: recvmmsg() timeout behavior strangeness [RESEND]
References: <CAKgNAkgA_xTfRZhpyVwuACpCY7xMK89e0bK4PuVMG9reNV6Skw@mail.gmail.com> <20140512143451.GB13801@kernel.org> <20140521210535.GA5414@kernel.org> <20140523.150055.2214666905697701415.davem@davemloft.net> <20140523195522.GH2741@kernel.org>
In-Reply-To: <20140523195522.GH2741@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2014 09:55 PM, Arnaldo Carvalho de Melo wrote:
> Em Fri, May 23, 2014 at 03:00:55PM -0400, David Miller escreveu:
>> From: Arnaldo Carvalho de Melo <acme@kernel.org>
>> Date: Wed, 21 May 2014 18:05:35 -0300
> 
>>> But after thinking a bit more, looks like we need to do that, please
>>> take a look at the attached patch to see if it addresses the problem.
> 
>>> Mostly it adds a new timeop to the per protocol recvmsg()
>>> implementations, that, if not NULL, should be used instead of
>>> SO_RCVTIMEO.
> 
>>> since the underlying recvmsg implementations already check that timeout,
>>> return what is remaining, that will then be used in subsequent recvmsg
>>> calls, at the end we just convert it back to timespec format.
> 
>>> In most cases it is just passed to skb_recv_datagram, that will check
>>> the pointer, use it and update if not NULL.
> 
>>> Should have no problems, but I only did a boot with a system with this
>>> patch applied, no problems noticed on a normal desktop session, ssh,
>>> etc.
>  
>> This looks fine to me, but I have a small request:
>  
>> +	return noblock ? 0 : timeop ? *timeop : sk->sk_rcvtimeo;
>  
>> I keep forgetting which way these expressions associate, so if you could
>> parenthesize the innermost ?: I'd appreciate it. :)
> 
> Ok, I actually wrote a sample program to verify that these ternaries did
> what I meant 8)
> 
> I'll finish the cset log and do this clarification change.
> 
> Would be great to get Acked-by tags from the original reporter, Michael
> and whoever had a look at this change, if possible. Michael, Elie?

Arnaldo, I already sent you a reply (will reping on that one),
but got no response. My light testing got the expected results,
but I still had one question about the semantics.

Cheers,

Michael



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058Ab3JJFFW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 01:05:22 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:55986 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106Ab3JJFFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 01:05:20 -0400
Message-ID: <52563550.3070002@linux.vnet.ibm.com>
Date: Thu, 10 Oct 2013 10:34:16 +0530
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PPC dev <linuxppc-dev@ozlabs.org>,
        Michael Neuling <michael.neuling@au1.ibm.com>
Subject: Re: [PATCH V2 0/6] perf: New conditional branch filter
References: <1377836690-32710-1-git-send-email-khandual@linux.vnet.ibm.com> <1378778772.25578.1.camel@concordia> <CABPqkBREXH5VUkULAsWvmpCer-s4SCxuof6LdqRO0i-iBOG8pA@mail.gmail.com> <524006C4.3010006@linux.vnet.ibm.com> <CABPqkBR0koi7Swzqxg2nhjDsXyfLCSdR5qtB7XuBwxfCxaRO0A@mail.gmail.com>
In-Reply-To: <CABPqkBR0koi7Swzqxg2nhjDsXyfLCSdR5qtB7XuBwxfCxaRO0A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13101005-8878-0000-0000-0000092E7D30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2013 04:44 PM, Stephane Eranian wrote:
> So you are saying that the HW filter is exclusive. That seems odd. But
> I think it is
> because of the choices is ANY. ANY covers all the types of branches. Therefore
> it does not make a difference whether you add COND or not. And
> vice-versa, if you
> set COND, you need to disable ANY. I bet if you add other filters such
> as CALL, RETURN,
> then you could OR them and say: I want RETURN or CALLS.
> 
> But that's okay. The API operates in OR mode but if the HW does not
> support it, you
> can check the mask and reject if more than one type is set. That is
> arch-specific code.
> The alternative, if to only capture ANY and emulate the filter in SW.
> This will work, of
> course. But the downside, is that you lose the way to appreciate how
> many, for instance,
> COND branches you sampled out of the total number of COND branches
> retired. Unless
> you can count COND branches separately.

Hey Stephane,

Thanks for your reply. I am working on a solution where PMU will process
all the requested branch filters in HW only if it can filter all of them in an
OR manner else it will just leave the entire thing upto the SW to process and
do no filtering itself. This implies that branch filtering will either happen
completely in HW or completely in SW and never in a mixed manner. This way
it will conform to the OR mode defined in the API. I will post the revised
patch set soon.

Regards
Anshuman


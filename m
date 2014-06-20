Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757778AbaFTWR0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 18:17:26 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:36927 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754761AbaFTWRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 18:17:24 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Willy Tarreau <w@1wt.eu>
Cc: Luis Henriques <luis.henriques@canonical.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Michal Tesar <mtesar@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, tyler.hicks@canonical.com
References: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
	<20140512003203.088027167@1wt.eu> <20140611184644.GA5442@hercules>
	<20140611194657.GU28551@1wt.eu> <87sinanv6u.fsf@canonical.com>
	<20140614175047.GH15102@1wt.eu>
Date: Fri, 20 Jun 2014 15:16:07 -0700
In-Reply-To: <20140614175047.GH15102@1wt.eu> (Willy Tarreau's message of "Sat,
	14 Jun 2014 19:50:47 +0200")
Message-ID: <87simzgrbs.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19vtvh0ZjldyKVW00/X3M0KuJCSKc3fLVM=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4062]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Willy Tarreau <w@1wt.eu>
X-Spam-Relay-Country: 
Subject: Re: [ 059/143] sysctl net: Keep tcp_syn_retries inside the boundary
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau <w@1wt.eu> writes:

> Hi Luis,
>
> On Thu, Jun 12, 2014 at 01:55:53PM +0100, Luis Henriques wrote:
>> I was finally able to spend some more time with this and tried (a
>> modified) Tyler's patch on top of 2.6.32.62, and it seems to work.
>> Although I haven't done any extended testing, I don't see the two
>> stack traces and the /proc/sys/net/ipv4/ directory seems to be
>> correctly populated.
>> 
>> I'm attaching the patch I've used, based on Tyler's.
>
> Would any of you or Tyler please kindly pass me a signed-off-by with
> a commit message ? That would be great. Alternately I'd do it myself
> and mention you authored them.

If my memory serves it is possibe in 2.6.32 to set 
.ctl_name = CTL_UNNEEDED

and not need to implement a .strategy routine at all.

Given the fact that most people got the strategy routines
slightly wrong and that sys_sysctl is effectively unused
a strategy where you don't implement code that no-one
will use in a backport I would be preferable.

Since you have mentioned this has come up a couple of times if something
else this will be something to think about for next time.

I am puzzled why .ctl_name was populated in a backport at all.

Eric

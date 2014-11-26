Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023AbaKZFKv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 00:10:51 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:43086 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbaKZFKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 00:10:50 -0500
Message-ID: <547560C3.1090907@linux.vnet.ibm.com>
Date: Wed, 26 Nov 2014 10:40:27 +0530
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Shuah Khan <shuahkh@osg.samsung.com>, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org
CC: peterz@infradead.org, akpm@linux-foundation.org, tglx@linutronix.de,
        james.hogan@imgtec.com, avagin@openvz.org, Paul.Clothier@imgtec.com,
        palves@redhat.com, oleg@redhat.com, dhowells@redhat.com,
        davej@redhat.com, davem@davemloft.net, mikey@neuling.org,
        benh@kernel.crashing.org, sukadev@linux.vnet.ibm.com,
        mpe@ellerman.id.au, sam.bobroff@au1.ibm.com, kirjanov@gmail.com
Subject: Re: [V5 7/7] selftests, powerpc: Add test case for TM related ptrace
 interface
References: <1416902731-22446-1-git-send-email-khandual@linux.vnet.ibm.com> <1416902731-22446-8-git-send-email-khandual@linux.vnet.ibm.com> <5474B72A.7040403@osg.samsung.com>
In-Reply-To: <5474B72A.7040403@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14112605-0029-0000-0000-000000AD99FA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2014 10:36 PM, Shuah Khan wrote:
> On 11/25/2014 01:05 AM, Anshuman Khandual wrote:
>> > This patch adds one more test case called 'tm-ptrace' targeting TM
>> > related ptrace interface. This test creates one child process to
>> > run some basic TM transactions and the parent process attaches the
>> > child to do some ptrace probing using the recently added regset
>> > interfaces. The parent process then compares the received values
>> > against the expected values to verify whether it has passed the
>> > given test or not.
>> > 
>> > Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
>> > ---
>> >  tools/testing/selftests/powerpc/tm/Makefile    |   2 +-
>> >  tools/testing/selftests/powerpc/tm/tm-ptrace.c | 542 +++++++++++++++++++++++++
>> >  2 files changed, 543 insertions(+), 1 deletion(-)
>> >  create mode 100644 tools/testing/selftests/powerpc/tm/tm-ptrace.c
>> > 
>> > diff --git a/tools/testing/selftests/powerpc/tm/Makefile b/tools/testing/selftests/powerpc/tm/Makefile
>> > index 2cede23..71d400a 100644
>> > --- a/tools/testing/selftests/powerpc/tm/Makefile
>> > +++ b/tools/testing/selftests/powerpc/tm/Makefile
>> > @@ -1,4 +1,4 @@
>> > -PROGS := tm-resched-dscr
>> > +PROGS := tm-resched-dscr tm-ptrace
>> >  
> Could you please add .gitignore for the binaries in this directory
> to avoid git status including the binaries it in its output.

Sure, will add one.


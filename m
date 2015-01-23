Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717AbbAWJcJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 04:32:09 -0500
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:54924 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192AbbAWJcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 04:32:07 -0500
Date: Fri, 23 Jan 2015 10:32:00 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>, linux390@de.ibm.com,
        Michael Holzheu <holzheu@linux.vnet.ibm.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Borislav Petkov <bp@alien8.de>, Tony Luck <tony.luck@intel.com>,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [Resend Patch v4 14/16] smp, s390: Kill SMP single function call
 interrupt
Message-ID: <20150123093200.GB5101@osiris>
References: <1421991416-20297-1-git-send-email-jiang.liu@linux.intel.com>
 <1421991416-20297-15-git-send-email-jiang.liu@linux.intel.com>
 <20150123065410.GA5101@osiris>
 <54C212A6.5030702@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54C212A6.5030702@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012309-0041-0000-0000-000002FA71D7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2015 at 05:21:42PM +0800, Jiang Liu wrote:
> On 2015/1/23 14:54, Heiko Carstens wrote:
> > On Fri, Jan 23, 2015 at 01:36:53PM +0800, Jiang Liu wrote:
> >> Commit 9a46ad6d6df3b54 "smp: make smp_call_function_many() use logic
> >> similar to smp_call_function_single()" has unified the way to handle
> >> single and multiple cross-CPU function calls. Now only one interrupt
> >> is needed for architecture specific code to support generic SMP function
> >> call interfaces, so kill the redundant single function call interrupt.
> >>
> >> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
> >> Acked-by: Heiko Carstens <heiko.carst...@de.ibm.com>
> > 
> > Is this really the patch I acked, whenever that was? Because the patch
> > description doesn't match what your patch does.
> > All it does is renaming ec_call_function_single to ec_call_function,
> > nothing else.
> > 
> > Could you please resend with a proper patch description?
> > Thanks!
> > 
> >> ---
> >>  arch/s390/kernel/smp.c |   10 +++++-----
> >>  1 file changed, 5 insertions(+), 5 deletions(-)
> >>
> >> diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
> >> index 0b499f5cbe19..5b89eabc3a01 100644
> >> --- a/arch/s390/kernel/smp.c
> >> +++ b/arch/s390/kernel/smp.c
> >> @@ -50,7 +50,7 @@
> >>
> >>  enum {
> >>  	ec_schedule = 0,
> >> -	ec_call_function_single,
> >> +	ec_call_function,
> >>  	ec_stop_cpu,
> >>  };
> >>
> >> @@ -416,8 +416,8 @@ static void smp_handle_ext_call(void)
> >>  		smp_stop_cpu();
> >>  	if (test_bit(ec_schedule, &bits))
> >>  		scheduler_ipi();
> >> -	if (test_bit(ec_call_function_single, &bits))
> >> -		generic_smp_call_function_single_interrupt();
> HI Heiko,
> 	The background is that the generic smp_call_xxx() interfaces
> only use on interrupt now, previously it used two (FUNC_CALL and
> FUNC_CALL_SINGLE). So the whole patch set is to kill
> FUNC_CALL_SINGLE from all architectures.
> 	Above code kills generic_smp_call_function_single_interrupt().
> We also replaces ec_call_function_single with ec_call_function so
> only one interrupt will be used to support smp_call_xxx().

Ah right, I missed that while looking at your patch. Apologies!


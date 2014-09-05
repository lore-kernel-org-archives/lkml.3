Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977AbaIEUaG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 16:30:06 -0400
Received: from mx0a-0014ca01.pphosted.com ([208.84.65.235]:7159 "EHLO
	mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751144AbaIEUaC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 16:30:02 -0400
X-Greylist: delayed 2984 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Sep 2014 16:30:02 EDT
From: Marc Gauthier <marc@cadence.com>
To: "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        Peter Hurley <peter@hurleysoftware.com>
CC: Michael Cree <mcree@orcon.net.nz>, "H. Peter Anvin" <hpa@zytor.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Laight <David.Laight@ACULAB.COM>,
        Jakub Jelinek <jakub@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Miroslav Franc <mfranc@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        "linux-alpha@vger.kernel.org" <linux-alpha@vger.kernel.org>
Date: Fri, 5 Sep 2014 12:38:56 -0700
Subject: RE: bit fields && data tearing
Thread-Topic: bit fields && data tearing
Thread-Index: Ac/JPd380KP5u2JFSQ6cINmaJt/uXQAAoQ5Q
Message-ID: <8CA974F497CA064FA9926E10ABCC061F05F97E7B77@MAILSJ4.global.cadence.com>
References: <54079B70.4050200@hurleysoftware.com>
 <1409785893.30640.118.camel@pasglop>
 <063D6719AE5E284EB5DD2968C1650D6D17487172@AcuExch.aculab.com>
 <1409824374.4246.62.camel@pasglop> <5408E458.3@zytor.com>
 <54090AF4.7060406@hurleysoftware.com> <54091B30.2090509@zytor.com>
 <20140905081648.GB5281@omega> <20140905180950.GU5001@linux.vnet.ibm.com>
 <540A05F7.1070202@hurleysoftware.com>
 <20140905190506.GV5001@linux.vnet.ibm.com>
In-Reply-To: <20140905190506.GV5001@linux.vnet.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
>On Fri, Sep 05, 2014 at 02:50:31PM -0400, Peter Hurley wrote:
>>On 09/05/2014 02:09 PM, Paul E. McKenney wrote:
>>> This commit documents the fact that it is not safe to use bitfields as
>>> shared variables in synchronization algorithms.  It also documents that
>>> CPUs must provide one-byte and two-byte load and store instructions
>>                    ^
>>                 atomic
> 
> Here you meant non-atomic?  My guess is that you are referring to the
> fact that you could emulate a one-byte store on pre-EV56 Alpha CPUs
> using the ll and sc atomic-read-modify-write instructions, correct?
> 
>>> in order to be supported by the Linux kernel.  (Michael Cree
>>> has agreed to the resulting non-support of pre-EV56 Alpha CPUs:
>>> https://lkml.org/lkml/2014/9/5/143.
[...]

>>> +     and 64-bit systems, respectively.  Note that this means that the
>>> +     Linux kernel does not support pre-EV56 Alpha CPUs, because these
>>> +     older CPUs do not provide one-byte and two-byte loads and stores.
>>                                  ^
>>                             non-atomic
> 
> I took this, thank you!

Eum, am I totally lost, or aren't both of these supposed to say "atomic" ?

Can't imagine requiring a CPU to provide non-atomic loads and stores
(i.e. requiring old Alpha behavior?).

-Marc

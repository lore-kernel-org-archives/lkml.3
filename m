Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788AbaIEVMm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 17:12:42 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:44740 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750869AbaIEVMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 17:12:39 -0400
Message-ID: <540A273C.7020804@hurleysoftware.com>
Date: Fri, 05 Sep 2014 17:12:28 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Michael Cree <mcree@orcon.net.nz>, Marc Gauthier <marc@cadence.com>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
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
Subject: Re: bit fields && data tearing
References: <1409824374.4246.62.camel@pasglop> <5408E458.3@zytor.com> <54090AF4.7060406@hurleysoftware.com> <54091B30.2090509@zytor.com> <20140905081648.GB5281@omega> <20140905180950.GU5001@linux.vnet.ibm.com> <540A05F7.1070202@hurleysoftware.com> <20140905190506.GV5001@linux.vnet.ibm.com> <8CA974F497CA064FA9926E10ABCC061F05F97E7B77@MAILSJ4.global.cadence.com> <540A19B8.4010907@hurleysoftware.com> <20140905203951.GA4053@omega>
In-Reply-To: <20140905203951.GA4053@omega>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2014 04:39 PM, Michael Cree wrote:
> On Fri, Sep 05, 2014 at 04:14:48PM -0400, Peter Hurley wrote:
>> Second, in the body of the document:
>>
>> "The Linux kernel no longer supports pre-EV56 Alpha CPUs, because these
>> older CPUs _do not provide_ atomic one-byte and two-byte loads and stores."
> 
> Let's be clear here, the pre-EV56 Alpha CPUs do provide an atomic
> one-byte and two-byte load and store; it's just that one must use
> locked load and store sequences to achieve atomicity.  The point,
> I think, is that the pre-EV56 Alpha CPUs provide non-atomic one-byte
> and two-byte load and stores as the norm, and that is the problem.

I'm all for an Alpha expert to jump in here and meet the criteria;
which is that byte stores cannot corrupt adjacent storage (nor can
aligned short stores).

To my mind, a quick look at Documentation/circular-buffers.txt will
pretty much convince anyone that trying to differentiate by execution
context is undoable.

If someone wants to make Alphas do cmpxchg loops for every byte store,
then ok. Or any other solution that doesn't require subsystem code
changes.

Regards,
Peter Hurley

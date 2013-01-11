Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848Ab3AKUFb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 15:05:31 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:38622 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753326Ab3AKUF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 15:05:29 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: David Vrabel <david.vrabel@citrix.com>
Cc: Daniel Kiper <daniel.kiper@oracle.com>,
        "xen-devel\@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "konrad.wilk\@oracle.com" <konrad.wilk@oracle.com>,
        Andrew Cooper <Andrew.Cooper3@citrix.com>,
        "x86\@kernel.org" <x86@kernel.org>,
        "kexec\@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization\@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "mingo\@redhat.com" <mingo@redhat.com>,
        "jbeulich\@suse.com" <jbeulich@suse.com>,
        "maxim.uvarov\@oracle.com" <maxim.uvarov@oracle.com>,
        "tglx\@linutronix.de" <tglx@linutronix.de>,
        "vgoyal\@redhat.com" <vgoyal@redhat.com>
References: <1356574740-6806-1-git-send-email-daniel.kiper@oracle.com>
	<50DBC856.6030208@zytor.com>
	<791b4922-078f-4adc-b3f3-0651f2266147@email.android.com>
	<50DC58C4.3000307@citrix.com> <874nj7qsor.fsf@xmission.com>
	<50E41973.9050705@citrix.com>
	<20130104142257.GC3346@host-192-168-1-59.local.net-space.pl>
	<50E6E974.5090805@citrix.com>
	<20130104170120.GA3472@host-192-168-1-59.local.net-space.pl>
	<50EECE0B.2080604@citrix.com>
	<20130111132212.GB5150@host-192-168-1-59.local.net-space.pl>
	<50F02E3B.3090506@citrix.com>
Date: Fri, 11 Jan 2013 12:05:16 -0800
In-Reply-To: <50F02E3B.3090506@citrix.com> (David Vrabel's message of "Fri, 11
	Jan 2013 15:22:35 +0000")
Message-ID: <87pq1bxz7n.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18ms5WmhtyEkbRcBUtNyuWuB2rn2BCo8rw=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.0 T_XMDrugObfuBody_14 obfuscated drug references
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;David Vrabel <david.vrabel@citrix.com>
X-Spam-Relay-Country: 
Subject: Re: [Xen-devel] [PATCH v3 00/11] xen: Initial kexec/kdump implementation
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Vrabel <david.vrabel@citrix.com> writes:

> On 11/01/13 13:22, Daniel Kiper wrote:
>> On Thu, Jan 10, 2013 at 02:19:55PM +0000, David Vrabel wrote:
>>> On 04/01/13 17:01, Daniel Kiper wrote:
>>>> My .5 cents:
>>>>   - We should focus on KEXEC_CMD_kexec_load and KEXEC_CMD_kexec_unload;
>>>>     probably we should introduce KEXEC_CMD_kexec_load2 and KEXEC_CMD_kexec_unload2;
>>>>     load should __LOAD__ kernel image and other things into hypervisor memory;
>>>
>>> Yes, but I don't see how we can easily support both ABIs easily.  I'd be
>>> in favour of replacing the existing hypercalls and requiring updated
>>> kexec tools in dom0 (this isn't that different to requiring the correct
>>> libxc in dom0).
>> 
>> Why? Just define new strutures for new functions of kexec hypercall.
>> That should suffice.
>
> The current hypervisor ABI depends on an internal kernel ABI (i.e., the
> ABI provided by relocate_kernel).  We do not want hypervisor internals
> to be constrained by having to be compatible with kernel internals.

I think this is violent agreement.  A new call with new arguments seems
agreed upon.  The only question seems to be what happens to the old
hypercall.  Keeping the current deprecated hypercall with the current
ABI and not updating it, or modifying the current hypercall to return
the xen equivalant of -ENOSYS seems to be the only question.

Certainly /sbin/kexec will only support the new hypercall once the
support has merged.

>> No, please do not do that. When you call HYPERVISOR_kexec_op(KEXEC_CMD_kexec)
>> system is completly shutdown. Return form HYPERVISOR_kexec_op(KEXEC_CMD_kexec)
>> would require to restore some kernel functionalities. It maybe impossible
>> in some cases. Additionally, it means that some changes should be made
>> in generic kexec code path. As I know kexec maintainers are very reluctant
>> to make such things.
>
> Huh?  There only needs to be a call to a new hypervisor_crash_kexec()
> function (which would then call the Xen specific crash hypercall) at the
> very beginning of crash_kexec().  If this returns the normal
> crash/shutdown path is done (which could even include a guest kexec!).

Can you imagine what crash_kexec would look like if every architecture
would hard code their own little piece in there?

The practical issue with changing crash_kexec is that you are hard
coding Xen policy just before a jump to a piece of code whose purpose
is to implement policy.

>From a maintenance and code comprehension stand-ponit it is much cleaner
to put the hypervisor_crash_kexec() hypercall into the code that is
loaded with sys_kexec_load and is branched to by crash_kexec.  I would
have no problem with hard coding that behavior into /sbin/kexec in
the case of Xen dom0.

Having any code have different semantics when running under Xen is a
maintenance nightmare, and why we are having the conversation years and
years after the initial deployment of Xen.  A tiny hard coded stub that
calls a hypercall should work indefinitely with no one having to do
anything.

Eric


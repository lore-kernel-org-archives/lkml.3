Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151Ab3AKERJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 23:17:09 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:48420 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753070Ab3AKERH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 23:17:07 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Daniel Kiper <daniel.kiper@oracle.com>,
        "xen-devel\@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        "x86\@kernel.org" <x86@kernel.org>,
        "kexec\@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization\@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "mingo\@redhat.com" <mingo@redhat.com>,
        Jan Beulich <JBeulich@suse.com>,
        "maxim.uvarov\@oracle.com" <maxim.uvarov@oracle.com>,
        "tglx\@linutronix.de" <tglx@linutronix.de>,
        "vgoyal\@redhat.com" <vgoyal@redhat.com>
References: <50DBC856.6030208@zytor.com>
	<791b4922-078f-4adc-b3f3-0651f2266147@email.android.com>
	<50DC58C4.3000307@citrix.com> <874nj7qsor.fsf@xmission.com>
	<50E41973.9050705@citrix.com>
	<20130104142257.GC3346@host-192-168-1-59.local.net-space.pl>
	<50E6F81D02000078000B3245@nat28.tlf.novell.com>
	<20130104170751.GB3472@host-192-168-1-59.local.net-space.pl>
	<20130104191146.GC6721@phenom.dumpdata.com>
	<20130107123404.GA2927@host-192-168-1-59.local.net-space.pl>
	<20130107162018.GJ3219@phenom.dumpdata.com>
Date: Thu, 10 Jan 2013 20:16:48 -0800
In-Reply-To: <20130107162018.GJ3219@phenom.dumpdata.com> (Konrad Rzeszutek
	Wilk's message of "Mon, 7 Jan 2013 11:20:18 -0500")
Message-ID: <87ehhsqrpr.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/mtqv7cG3fjWD66cdpwKStx+6k9agnYT8=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
X-Spam-Relay-Country: 
Subject: Re: [Xen-devel] [PATCH v3 00/11] xen: Initial kexec/kdump implementation
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> writes:

> On Mon, Jan 07, 2013 at 01:34:04PM +0100, Daniel Kiper wrote:
>> I think that new kexec hypercall function should mimics kexec syscall.
>> It means that all arguments passed to hypercall should have same types
>> if it is possible or if it is not possible then conversion should be done
>> in very easy way. Additionally, I think that one call of new hypercall
>> load function should load all needed thinks in right place and
>> return relevant status. Last but not least, new functionality should
>
> We are not restricted to just _one_ hypercall. And this loading
> thing could be similar to the micrcode hypercall - which just points
> to a virtual address along with the length - and says 'load me'.
>
>> be available through /dev/xen/privcmd or directly from kernel without
>> bigger effort.
>
> Perhaps we should have a email thread on xen-devel where we hash out
> some ideas. Eric, would you be OK included on this - it would make
> sense for this mechanism to be as future-proof as possible - and I am not
> sure what your plans for kexec are in the future?

The basic kexec interface is.

load ranges of virtual addresses physical addresses.
jump to the physical address  with identity mapped page tables.

There are a few flags to allow for different usage scenarios like
kexec on panic vs normal kexec.

It is very very simple and very extensible.  All of the weird glue
happens in userspace.

Eric

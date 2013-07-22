Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932489Ab3GVRUf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 13:20:35 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:51766 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932101Ab3GVRUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 13:20:34 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Daniel Kiper <daniel.kiper@oracle.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Greg KH <gregkh@linuxfoundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, Brandon Philips <brandon@ifup.org>,
        xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org
References: <20130719020603.GA22932@kroah.com>
	<20130719131819.GC11233@debian70-amd64.local.net-space.pl>
	<20130719151243.GA15488@kroah.com>
	<20130719183235.GA12267@debian70-amd64.local.net-space.pl>
	<20130719191449.GA1882@kroah.com> <51E9A85D.2060206@zytor.com>
	<20130722170307.GB14451@debian70-amd64.local.net-space.pl>
Date: Mon, 22 Jul 2013 10:20:14 -0700
In-Reply-To: <20130722170307.GB14451@debian70-amd64.local.net-space.pl>
	(Daniel Kiper's message of "Mon, 22 Jul 2013 19:03:07 +0200")
Message-ID: <87wqoise9d.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/z0MuKw4jpTiTcfZpyWgY6Q7/9Fo4NTi4=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Daniel Kiper <daniel.kiper@oracle.com>
X-Spam-Relay-Country: 
Subject: Re: is kexec on Xen domU possible?
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Kiper <daniel.kiper@oracle.com> writes:

> On Fri, Jul 19, 2013 at 01:58:05PM -0700, H. Peter Anvin wrote:
>> On 07/19/2013 12:14 PM, Greg KH wrote:
>> >>
>> >>> The errors that the kexec tools seem to run into is finding the memory
>> >>> to place the new kernel into, is that just an issue that PV guests
>> >>> aren't given enough kernel memory in which to replicate themselves from
>> >>> dom0?
>> >>
>> >> There are a lot of differences between baremetal machines and PV guests.
>> >> For example you are not able to do identity mapping per se in PV guests.
>> >> Arguments to new kernel are passed in completely different way. etc.
>> >
>> > Ok, thanks for confirming that it is possible, but doesn't currently
>> > work for pv guests.
>> >
>>
>> Also, in any virtualized environment the hypervisor can do a better job
>> for things like kdump, simply because it can provide two things that are
>> otherwise hard to do:
>>
>> 1. a known-good system state;
>> 2. a known-clean kdump image.
>>
>> As such, I do encourage the virtualization people to (also) develop
>> hypervisor-*aware* solutions for these kinds of things.
>
> In general I agree but if you could not change hypervisor
> and/or dom0 (e.g. you are using cloud providers which are
> stick to old versions of Xen) then you have no choice.

Which tends to be where kexec on panic comes in most cases.  Getting
platform vendors to do something sane tends to be a multi-year political
effort of dubious worth while just solving the problem locally actually
gets the problem solved for those who care.

Eric

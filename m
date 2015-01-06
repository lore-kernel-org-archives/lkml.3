Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665AbbAFIms (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 03:42:48 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:64842 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754614AbbAFImo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 03:42:44 -0500
Message-ID: <54AB9FFD.6070309@redhat.com>
Date: Tue, 06 Jan 2015 09:42:37 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
Newsgroups: gmane.comp.emulators.kvm.devel,gmane.linux.kernel
To: Marcelo Tosatti <mtosatti@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>
CC: Gleb Natapov <gleb@kernel.org>, kvm list <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>
Subject: Re: [RFC 2/2] x86, vdso, pvclock: Simplify and speed up the vdso
 pvclock reader
References: <cover.1419295081.git.luto@amacapital.net> <8d09c16eb39cbe264417cc66c4aca730af10b70b.1419295081.git.luto@amacapital.net> <20150105152511.GA9172@amt.cnet> <CALCETrXRs4NmhMvp+7kydrfyGCiNymkTe_sP6HFVvhMCC2Ei0Q@mail.gmail.com> <20150105191756.GA31201@amt.cnet> <CALCETrVWmbcv1w5a3N1VzyWEobP0qW+RQkhWO9yOkxzdKdJgeg@mail.gmail.com> <20150105224858.GA6846@amt.cnet>
In-Reply-To: <20150105224858.GA6846@amt.cnet>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 05/01/2015 23:48, Marcelo Tosatti wrote:
>>> > > But there is no guarantee that vCPU-N has updated its pvti when
>>> > > vCPU-M resumes guest instruction execution.
>> > 
>> > Still confused.  So we can freeze all vCPUs in the host, then update
>> > pvti 1, then resume vCPU 1, then update pvti 0?  In that case, we have
>> > a problem, because vCPU 1 can observe pvti 0 mid-update, and KVM
>> > doesn't increment the version pre-update, and we can return completely
>> > bogus results.
> Yes.

But then the getcpu test would fail (1->0).  Even if you have an ABA
situation (1->0->1), it's okay because the pvti that is fetched is the
one returned by the first getcpu.

Paolo

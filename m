Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069AbbAFIkG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 03:40:06 -0500
Received: from mail-we0-f175.google.com ([74.125.82.175]:39676 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753348AbbAFIkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 03:40:03 -0500
Message-ID: <54AB9F5D.6070504@redhat.com>
Date: Tue, 06 Jan 2015 09:39:57 +0100
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
References: <cover.1419295081.git.luto@amacapital.net> <8d09c16eb39cbe264417cc66c4aca730af10b70b.1419295081.git.luto@amacapital.net> <20150105152511.GA9172@amt.cnet> <CALCETrXRs4NmhMvp+7kydrfyGCiNymkTe_sP6HFVvhMCC2Ei0Q@mail.gmail.com> <20150105191756.GA31201@amt.cnet>
In-Reply-To: <20150105191756.GA31201@amt.cnet>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 05/01/2015 20:17, Marcelo Tosatti wrote:
> But there is no guarantee that vCPU-N has updated its pvti when
> vCPU-M resumes guest instruction execution.

You're right.

> So the cost this patch removes is mainly from __getcpu (==RDTSCP?) ?
> Perhaps you can use Gleb's idea to stick vcpu id into version field ?

Or just replace __getcpu with rdtscp.

Paolo

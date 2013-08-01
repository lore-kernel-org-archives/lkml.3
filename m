Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001Ab3HAUBC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 16:01:02 -0400
Received: from plane.gmane.org ([80.91.229.3]:43060 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751362Ab3HAUBA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 16:01:00 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Alex Elsayed <eternaleye@gmail.com>
Subject: Re: [QUERY] lguest64
Date: Thu, 01 Aug 2013 13:04:22 +0000
Message-ID: <kteepb$8qf$1@ger.gmane.org>
References: <CALkWK0n7zedKD4tnxKh-qMuDnMJ5RXjnPJ9EUWT=cCgiokX11A@mail.gmail.com> <51E97779.3020103@zytor.com> <CALkWK0ktHB34WkcYvGt_BOFoQbvbFJANDqGPUdZjT+Ui29pqAg@mail.gmail.com> <51E989A0.8050103@zytor.com> <CALkWK0=T6aqpqHKf=601EPc9+4cvgJ053xBU2HxmJuf2dVXoxw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: c-24-17-197-101.hsd1.wa.comcast.net
User-Agent: KNode/4.10.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ramkumar Ramachandra wrote:

> H. Peter Anvin wrote:
>> UML, lguest and Xen were done before the x86 architecture supported
>> hardware virtualization.
> 
> [...]
> 
>> but on KVM-enabled hardware KVM seems
>> like the better option (and is indeed what libguestfs uses.)
> 
> While we're still on the topic, I'd like a few clarifications. From
> your reply, I got the impression that KVM the only mechanism for
> non-pvops virtualization.  This seems quite contrary to what I read on
> lwn about ARM virtualization [1]. In short, ARM provides a "hypervisor
> mode", and the article says
> 
>   "the virtualization model provided by ARM fits the Xen
> hypervisor-based virtualization better than KVM's kernel-based model"
> 
> The Xen people call this "ARM PVH" (as opposed to ARM PV, which does
> not utilize hardware extensions) [2]. Although I wasn't able to find
> much information about the hardware aspect, what ARM provides seems to
> be quite different from VT-x and AMD-V. I'm also confused about what
> virt/kvm/arm is.
> 
> Thanks.
> 
> [1]: http://lwn.net/Articles/513940/
> [2]: http://www.xenproject.org/developers/teams/arm-hypervisor.html

ARM's virtualization extensions may be a more *natural* match to Xen's 
semantics and architecture, but that doesn't mean that KVM can't use it. LWN 
explains the details far better than I can: https://lwn.net/Articles/557132/

virt/kvm/arm is an implementation of KVM (the API) that takes advantage of 
ARM's virtualization extensions.


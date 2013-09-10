Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751594Ab3IJL7h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 07:59:37 -0400
Received: from mail-qe0-f50.google.com ([209.85.128.50]:43154 "EHLO
	mail-qe0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166Ab3IJL7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 07:59:36 -0400
Message-ID: <522F09AB.4000907@redhat.com>
Date: Tue, 10 Sep 2013 13:59:39 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Chris Metcalf <cmetcalf@tilera.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Jan Kiszka <jan.kiszka@siemens.com>
Subject: Re: [PATCH v3 1/3] tile: support KVM host mode
References: <20130826120445.GD8218@redhat.com> <4bbdcdd0e94f6a7db210ef47f4a30f06325137cd.1377736306.git.cmetcalf@tilera.com> <20130910105349.GY17294@redhat.com>
In-Reply-To: <20130910105349.GY17294@redhat.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 10/09/2013 12:53, Gleb Natapov ha scritto:
>> > +#ifndef __KERNEL__
>> > +/* For hv_*() */
>> > +#define KVM_EMULATE(name) [HV_SYS_##name] = qemu_emulate_illegal,
>> > +#define USER_EMULATE(name) [HV_SYS_##name] = qemu_emulate_hv_##name,
>> > +#define NO_EMULATE(name) [HV_SYS_##name] = qemu_emulate_illegal,
>> > +#define BOTH_EMULATE(name) [HV_SYS_##name] = qemu_emulate_hv_##name,
>> > +/* For others */
>> > +#define USER_HCALL(name) [KVM_HCALL_##name] = qemu_handle_##name,
> This does not belong to a kernel header. QEMU is not the only user of KVM
> kernel APIs. Please drop that and change all the references in comment
> from "qemu" to "userspace". If you add code that workarounds QEMU bugs it
> is appropriate to mention QEMU by name, otherwise interface to userspace
> should not be QEMU specific.
> 

In general, I believe that HCALL_DEFS should not be part of the public
interface.

Otherwise, adding a new hypercall would break compilation of userspace.
 Hypercalls (after the first commit) should always be associated to a
capability, so they shouldn't be generated unless userspace explicitly
requests them.

Rather, document the hypercalls under Documentation/virtual/kvm, noting
which are implemented in the kernel and which need to be handled in
userspace.

BTW, BOTH_EMULATE and USER_HCALL seem unused.

Paolo

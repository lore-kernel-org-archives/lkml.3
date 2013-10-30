Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628Ab3J3PmY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 11:42:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35881 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750983Ab3J3PmX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 11:42:23 -0400
Message-ID: <527128D7.9070603@redhat.com>
Date: Wed, 30 Oct 2013 16:42:15 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130923 Thunderbird/17.0.9
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        aik@ozlabs.ru, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] kvm: Destroy & free KVM devices on release
References: <20131029160019.22578.16409.stgit@bling.home> <20131029161322.22578.18997.stgit@bling.home> <20131030104029.GE4651@redhat.com> <1383143422.4097.170.camel@ul30vt.home> <20131030153338.GI4651@redhat.com>
In-Reply-To: <20131030153338.GI4651@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 30/10/2013 16:33, Gleb Natapov ha scritto:
> > Hmm, ok.  In that case I can drop this patch and I think the rest just
> > boils down to userspace use of the device.  I had been close()'ing the
> > kvm device fd when all QEMU vfio devices are detached, but I can just as
> > easily leave it open in case a new device is added later.  I'll send out
> > a new series after doing some more review and testing.  Do you have any
> > comments on the rest of the series?  Thanks,
>
> If I understand 4/4 correctly if there is VFIO device connected we
> assume non coherent domain. How hard it would be to do proper checking
> in this path series?

Yes, that's my understanding as well.  Is the performance impact measurable?

Paolo

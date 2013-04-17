Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966251Ab3DQNO2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 09:14:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52164 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965626Ab3DQNO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 09:14:27 -0400
Date: Wed, 17 Apr 2013 15:15:11 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: Victor Miasnikov <vvm@tut.by>, olaf@aepfle.de, bp@alien8.de,
        apw@canonical.com, x86@kernel.org, tglx@linutronix.de,
        devel@linuxdriverproject.org, gregkh@linuxfoundation.org,
        "K. Y. Srinivasan" <kys@microsoft.com>, jasowang@redhat.com,
        linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: KVM  "Hyper-V emulation"   -- this can be related "Linux on
 Hyper-V" ? Or  "KVM emulates Hyper-V" as  "Hyper-V emulates Hyper-V" ? Re:
 [PATCH 2/3] X86: Add a check to catch Xen emulation of Hyper-V
Message-ID: <20130417121511.GB6801@redhat.com>
References: <1359940910-32114-1-git-send-email-kys@microsoft.com>
 <1359940959-32168-1-git-send-email-kys@microsoft.com>
 <1359940959-32168-2-git-send-email-kys@microsoft.com>
 <20130417070616.GA4487@redhat.com>
 <39D7C3658A5B4979A3F025E1D944E743@local.st.by>
 <20130417101617.GF3881@redhat.com>
 <516EADD502000078000CE112@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <516EADD502000078000CE112@nat28.tlf.novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 17, 2013 at 01:12:37PM +0100, Jan Beulich wrote:
> >>> On 17.04.13 at 12:16, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > If the hypervisor says it's Hyper-V, that's because it wants
> > guests to use Hyper-V. I don't see why is guest second-guessing
> > this a good idea.
> 
> There are two reasons here: For one, when the hypervisor is not
> Hyper-V, but is providing some Hyper-V emulation, that's intended
> for Windows guests to use, not e.g. Linux ones,

Fact is that this patch changed the guest/hypervisor interface which
should not be done lightly. We don't know all uses that Linux is put
to.  I gave what seems, to me, like a perfectly valid reason to use
hyper-v emulation with Linux guests, which you snipped out :) Below is
a scanario that will now be broken:
	>>>It seems that one might want to use hyper-v emulation e.g. to test
	>>>hyper-v code without using windows, so the functionality
	>>>that this patch disables is not completely useless,
There could be others.

> such guests could use the native hypervisor interface with much
> greater benefit.

Why not disable the emulation in the hypervisor?  What overriding the
hypervisor will lead to, is hypervisors will try harder and mask their
real identity.  No one will win in this arms race.

> And second, there reportedly are features of (newer?) Hyper-V
> that some emulation may not provide, but that are also not easily
> detectable.
> 
> Jan

Could you be more explicit please?  What are these features?  How does a
windows guest able to use them if they are both new and not detectable?
Why not just fix the emulation?  How will Linux use the new features
when e.g. Xen adds them?

-- 
MST

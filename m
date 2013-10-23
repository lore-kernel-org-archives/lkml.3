Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751085Ab3JWEQX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 00:16:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46510 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949Ab3JWEQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 00:16:22 -0400
MIME-Version: 1.0
In-Reply-To: <526706FC.2070105@redhat.com>
References: <1382304926-1641-1-git-send-email-prarit@redhat.com>
	<1382304926-1641-2-git-send-email-prarit@redhat.com>
	<CACVXFVO_bbYsRRgZ+MfVKf5=VRNy=O3VUg0mh2fumEi7cObuiw@mail.gmail.com>
	<5265A9A4.2000100@redhat.com>
	<CACVXFVM7eKA2m+ten5-1EYNdJkc5SuZy2cimpH9j94OOdsb9Uw@mail.gmail.com>
	<526706FC.2070105@redhat.com>
Date: Wed, 23 Oct 2013 12:16:19 +0800
Message-ID: <CACVXFVMmp3gOpfEtjQ-fO62=RY+7_ZJ11UW89GXDPNKE61+keg@mail.gmail.com>
Subject: Re: [PATCH 1/2] firmware, fix request_firmware_nowait() freeze with
 no uevent
From: Ming Lei <ming.lei@canonical.com>
To: Prarit Bhargava <prarit@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Andreas Herrmann <herrmann.der.user@googlemail.com>,
        tigran@aivazian.fsnet.co.uk
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 23, 2013 at 7:15 AM, Prarit Bhargava <prarit@redhat.com> wrote:
> On 10/21/2013 10:35 PM, Ming Lei wrote:
>>
>> That is why NOHOTPLUG isn't encouraged to be taken, actually
>> I don't suggest you to do that too, :-)
> Okay ... I can certainly switch to HOTPLUG.

OK, that should be the right approach.

>
>>
>> You need to make sure your approach won't break micro-code
>> update application in current/previous distributions.
>
> I've tested the following distributions today on a Dell PE 1850:  Ubuntu, SuSe,
> Linux Mint, and of course Fedora.  I do not see any issues with either the
> microcode update or the dell_rbu driver.  Unfortunately I do not have access to

Actually I am wondering if your tests are enough because kernel
can't break user-space, which means lots of previous old version
distributions should surely be covered, :-)

If you keep HOTPLUG, only change to request_firmware_nowait(),
that should be OK since the loading protocol between userspace and
kernel won't change wrt. microcode updating.

> a system that uses the lattice-ecp3-config, however, from code inspection it
> looks like the driver looks at a specific place for the FW update and then
> applies it via the call function in request_firmware_nowait() so it looks like
> it is solid too.
>
> I think maybe this patchset should be split into two separate submits, one for
> the microcode and the second to figure out if the code really should wait
> indefinitely.  AFAICT neither use case in the kernel expects an indefinite wait.

If you switch to HOTPLUG, you needn't worry about waiting indefinitely,
need you?

Thanks,
--
Ming Lei

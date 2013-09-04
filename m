Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759518Ab3IDSJI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 14:09:08 -0400
Received: from b232-35.smtp-out.amazonses.com ([199.127.232.35]:30822 "EHLO
	b232-35.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753493Ab3IDSJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 14:09:06 -0400
Date: Wed, 4 Sep 2013 18:09:04 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Will Deacon <will.deacon@arm.com>
cc: Tejun Heo <tj@kernel.org>,
        "akpm@linuxfoundation.org" <akpm@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Steven Rostedt <srostedt@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [gcv v3 27/35] arm: Replace __get_cpu_var uses
In-Reply-To: <20130904174624.GB5599@mudshark.cambridge.arm.com>
Message-ID: <00000140ea29d3c8-5110dd9f-9dcf-470f-9b7e-4e7ff0874052-000000@email.amazonses.com>
References: <20130828193457.140443630@linux.com> <00000140c67834c9-cc2bec76-2d70-48d1-a35b-6e2d5dedf22b-000000@email.amazonses.com> <20130830100105.GF25628@mudshark.cambridge.arm.com> <00000140e4440576-ae4236ee-3073-4f94-b569-d17396e57513-000000@email.amazonses.com>
 <20130904093335.GA8007@mudshark.cambridge.arm.com> <00000140e9557be9-1523eeab-c0f6-45a0-881c-9336a8a6cf85-000000@email.amazonses.com> <20130904142324.GD3643@mudshark.cambridge.arm.com> <00000140e97747d2-ee164a4d-d692-409a-a919-083eff3a41ca-000000@email.amazonses.com>
 <20130904174624.GB5599@mudshark.cambridge.arm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.127.232.35
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Sep 2013, Will Deacon wrote:

> On ARM, yes. I'm worried that there may be an architecture where the change-
> or-fail operation would only fail if the access from the interrupt handler
> *also* used that change-or-fail instruction, which isn't the case with
> this_cpu_inc.
>
> I have no idea if such an architecture exists :)

Atomic operations use atomic_t. this_cpu operations can only use regular
scalars. So the set of variables that are updated by each should be
distinct.




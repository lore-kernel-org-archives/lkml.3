Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443AbaCQQ4q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 12:56:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36759 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752777AbaCQQ4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 12:56:44 -0400
Message-ID: <5327291D.60009@zytor.com>
Date: Mon, 17 Mar 2014 09:55:57 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: George Dunlap <George.Dunlap@eu.citrix.com>
CC: Sarah Newman <srn@prgmr.com>, David Vrabel <david.vrabel@citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>
Subject: Re: [Xen-devel] [PATCHv1] x86: don't schedule when handling #NM exception
References: <1394468273-13676-1-git-send-email-david.vrabel@citrix.com>	<531DEB11.2070709@zytor.com>	<531DF319.6010800@citrix.com>	<53266841.6090308@prgmr.com>	<1ebfa80c-4a68-4602-bc98-e5d5f0893998@email.android.com> <CAFLBxZZz4Ot0CgWRHNRaM5zVkpf+QdXveFz_m3aVYnKUd9cAdQ@mail.gmail.com>
In-Reply-To: <CAFLBxZZz4Ot0CgWRHNRaM5zVkpf+QdXveFz_m3aVYnKUd9cAdQ@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17/2014 05:19 AM, George Dunlap wrote:
> On Mon, Mar 17, 2014 at 3:33 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>> No, the right thing is to unf*ck the Xen braindamage and use eagerfpu as a workaround for the legacy hypervisor versions.
> 
> The interface wasn't an accident.  In the most common case you'll want
> to clear the bit anyway. In PV mode clearing it would require an extra
> trip up into the hypervisor.  So this saves one trip up into the
> hypervisor on every context switch which involves an FPU, at the
> expense of not being able to context-switch away when handling the
> trap.
> 
>  -George
> 

The interface was a complete faceplant, because it caused failures.
You're not infinitely unconstrained since you want to play in the same
sandbox as the native architecture, and if you want to have a hope of
avoiding these kinds of failures you really need to avoid making random
"improvements", certainly not without an explicit guest opt-in (the same
we do for the native CPU architecture when adding new features.)

So if this interface wasn't an accident it was active negligence and
incompetence.

	-hpa


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757362AbaCRSR4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 14:17:56 -0400
Received: from mail.xen.prgmr.com ([71.19.149.6]:33438 "EHLO
	mail.xen.prgmr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756119AbaCRSRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 14:17:55 -0400
Message-ID: <53288DD1.9060809@prgmr.com>
Date: Tue, 18 Mar 2014 11:17:53 -0700
From: Sarah Newman <srn@prgmr.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: George Dunlap <george.dunlap@eu.citrix.com>,
        Jan Beulich <JBeulich@suse.com>, "H. Peter Anvin" <hpa@zytor.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        Ingo Molnar <mingo@redhat.com>, David Vrabel <david.vrabel@citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Xen-devel] [PATCHv1] x86: don't schedule when handling #NM exception
References: <1394468273-13676-1-git-send-email-david.vrabel@citrix.com>	<531DEB11.2070709@zytor.com> <531DF319.6010800@citrix.com>	<53266841.6090308@prgmr.com>	<1ebfa80c-4a68-4602-bc98-e5d5f0893998@email.android.com>	<CAFLBxZZz4Ot0CgWRHNRaM5zVkpf+QdXveFz_m3aVYnKUd9cAdQ@mail.gmail.com>	<5327291D.60009@zytor.com>	<532739810200007800124E85@nat28.tlf.novell.com> <53272D79.5050605@eu.citrix.com>
In-Reply-To: <53272D79.5050605@eu.citrix.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17/2014 10:14 AM, George Dunlap wrote:
> On 03/17/2014 05:05 PM, Jan Beulich wrote:
>>>>> On 17.03.14 at 17:55, "H. Peter Anvin" <hpa@zytor.com> wrote:
>>> So if this interface wasn't an accident it was active negligence and
>>> incompetence.
>> I don't think so - while it (as we now see) disallows certain things
>> inside the guest, back at the time when this was designed there was
>> no sign of any sort of allocation/scheduling being done inside the
>> #NM handler. And furthermore, a PV specification is by its nature
>> allowed to define deviations from real hardware behavior, or else it
>> wouldn't be needed in the first place.
> 
> But it's certainly the case that deviating from the hardware in *this* way by default was always
> very likely to case the exact kind of bug we've seen here.  It is an "interface trap" that was bound
> to be tripped over (much like Intel's infamous sysret vulnerability).
> 
> Making it opt-in would have been a much better idea.  But the people who made that decision are long
> gone, and we now need to deal with the situation as we have it.

Should or has there been a review of the current xen PVABI to look for any other such deviations?

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235Ab3CAARa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 19:17:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42931 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751513Ab3CAAR3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 19:17:29 -0500
Message-ID: <512FF331.5050008@zytor.com>
Date: Thu, 28 Feb 2013 16:15:45 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Josh Boyer <jwboyer@redhat.com>
CC: Borislav Petkov <bp@alien8.de>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>, mingo@redhat.com,
        tglx@linutronix.de, konrad.wilk@oracle.com, rostedt@goodmis.org,
        gregkh@linuxfoundation.org, samu.kallio@aberdeencloud.com,
        kraman@redhat.com, xen-devel@lists.xen.org,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] mm/x86: Patch out arch_flush_lazy_mmu_mode() when running
 on bare metal
References: <1362092149-32381-1-git-send-email-boris.ostrovsky@oracle.com> <20130228233720.GB17468@pd.tnic> <20130301000539.GA31649@hansolo.jdub.homelinux.org>
In-Reply-To: <20130301000539.GA31649@hansolo.jdub.homelinux.org>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28/2013 04:05 PM, Josh Boyer wrote:
> On Fri, Mar 01, 2013 at 12:37:20AM +0100, Borislav Petkov wrote:
>> On Thu, Feb 28, 2013 at 05:55:49PM -0500, Boris Ostrovsky wrote:
>>> Invoking arch_flush_lazy_mmu_mode() results in calls to
>>> preempt_enable()/disable() which may have performance impact.
>>>
>>> Since lazy MMU is not used on bare metal we can patch away
>>> arch_flush_lazy_mmu_mode() so that it is never called in such
>>> environment.
>>>
>>> Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
>>
>> Looks straight-forward enough to me.
>>
>> Acked-by: Borislav Petkov <bp@suse.de>
> 
> I'll try to get someone to test this tomorrow.
> 

Sounds good.

I'd like look at this after the merge window close.  I'm kind of
bothered about having a choice with an oops on PV, a performance
regression on native, or putting a pretty complex patch in as a fix, but
since we'll be right after -rc1 it is probably reasonable to pick the
last option.

	-hpa


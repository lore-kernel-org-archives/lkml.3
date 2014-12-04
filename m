Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932227AbaLDNxi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 08:53:38 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:44634 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932110AbaLDNxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 08:53:36 -0500
Message-ID: <54806756.30503@redhat.com>
Date: Thu, 04 Dec 2014 14:53:26 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel,gmane.comp.emulators.kvm.devel
To: Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, linux-kernel@vger.kernel.org,
        Luiz Capitulino <lcapitulino@redhat.com>,
        Steven Rostedt <srostedt@redhat.com>, kvm@vger.kernel.org
Subject: Re: [patch -rt 2/2] KVM: lapic: mark LAPIC timer handler as irqsafe
References: <20141125172108.992070524@redhat.com> <20141125172329.580701786@redhat.com> <5474D476.3020506@redhat.com> <alpine.DEB.2.11.1411252123480.3961@nanos>
In-Reply-To: <alpine.DEB.2.11.1411252123480.3961@nanos>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 25/11/2014 21:24, Thomas Gleixner wrote:
> On Tue, 25 Nov 2014, Rik van Riel wrote:
>> On 11/25/2014 12:21 PM, Marcelo Tosatti wrote:
>>> Since lapic timer handler only wakes up a simple waitqueue,
>>> it can be executed from hardirq context.
>>>
>>> Reduces average cyclictest latency by 3us.
>>
>> Can this patch be merged in the KVM tree, and go
>> upstream via Paolo?
> 
> Not really as it has RT dependencies ....

Can hrtimer_start_expires even return ETIME on a non-RT kernel?  If yes,
I can take patch 2.  If not, it's better to keep both patches in the RT
tree.

Paolo

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601Ab3FZQHr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 12:07:47 -0400
Received: from relay3.sgi.com ([192.48.152.1]:35901 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752023Ab3FZQHp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 12:07:45 -0400
Message-ID: <51CB11CD.4080302@sgi.com>
Date: Wed, 26 Jun 2013 09:07:41 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Nathan Zimmer <nzimmer@sgi.com>, holt@sgi.com, rob@landley.net,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        yinghai@kernel.org, akpm@linux-foundation.org,
        gregkh@linuxfoundation.org, x86@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC 2/2] x86_64, mm: Reinsert the absent memory
References: <1371831934-156971-1-git-send-email-nzimmer@sgi.com> <1371831934-156971-3-git-send-email-nzimmer@sgi.com> <20130623092840.GB13445@gmail.com> <20130624203657.GA107621@asylum.americas.sgi.com> <20130626121430.GA4980@gmail.com>
In-Reply-To: <20130626121430.GA4980@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 6/26/2013 5:14 AM, Ingo Molnar wrote:
> 
> * Nathan Zimmer <nzimmer@sgi.com> wrote:
> 
>> perf seems to struggle with 512 cpus, but I did get some data.
> 
> Btw., mind outlining in what way it struggles?
> 
> Thanks,
> 
> 	Ingo
> 

I submitted some patches to Jason Wessel that updated the community
support for KDB & NMI quite awhile ago that addressed the issues
with perf and friends on UV.  But I have not heard back from him in a
couple of months.  Is there a new maintainer for NMI/PERF/KDB etc.?

The primary problem is that the current UV NMI handler is in the
primary NMI notifier chain causing excessive reads of a register in
the UV hub.  When perf is running these approach the millions per
second, and the MMIO read is not only expensive but also distrupts
the primary HUB activities of directing NUMA traffic.  Thus the
system slows down considerably, and perf can even lose events.

We've even updated the UV BIOS to make this a faster path but it
needs the newer NMI handler to use it.  Perhaps I should resubmit
them directly to you?

Thanks,
Mike

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051Ab3FZOtJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 10:49:09 -0400
Received: from relay2.sgi.com ([192.48.179.30]:37813 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750729Ab3FZOtH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 10:49:07 -0400
Date: Wed, 26 Jun 2013 09:49:04 -0500
From: Nathan Zimmer <nzimmer@sgi.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Nathan Zimmer <nzimmer@sgi.com>, holt@sgi.com, travis@sgi.com,
        rob@landley.net, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        yinghai@kernel.org, akpm@linux-foundation.org,
        gregkh@linuxfoundation.org, x86@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC 2/2] x86_64, mm: Reinsert the absent memory
Message-ID: <20130626144903.GA2210@asylum.americas.sgi.com>
References: <1371831934-156971-1-git-send-email-nzimmer@sgi.com> <1371831934-156971-3-git-send-email-nzimmer@sgi.com> <20130623092840.GB13445@gmail.com> <20130624203657.GA107621@asylum.americas.sgi.com> <20130626121430.GA4980@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130626121430.GA4980@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 02:14:30PM +0200, Ingo Molnar wrote:
> 
> * Nathan Zimmer <nzimmer@sgi.com> wrote:
> 
> > perf seems to struggle with 512 cpus, but I did get some data.
> 
> Btw., mind outlining in what way it struggles?
> 
> Thanks,
> 
> 	Ingo

System interactivity take a nose dive, including the ability to halt perf.
The commands do get through but they take a while.
Other processes tend to make signifigantly reduced progress.
Also it tends to slow down all running processes. 
My guess it is the NMIs overwhelming the system but I have not found a good way
to profile perf gone wild so it is only a guess.

The issue mitigate somewhat by restrictring the number of cpus perf is 
recording or by not using the -g option, but sometimes I do need data on the
whole system.


Nate


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751445Ab3FYSSJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 14:18:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45296 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101Ab3FYSSH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 14:18:07 -0400
Message-ID: <51C9DEC1.6030602@zytor.com>
Date: Tue, 25 Jun 2013 11:17:37 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Mike Travis <travis@sgi.com>
CC: Yinghai Lu <yinghai@kernel.org>, Greg KH <gregkh@linuxfoundation.org>,
        Nathan Zimmer <nzimmer@sgi.com>, Robin Holt <holt@sgi.com>,
        Rob Landley <rob@landley.net>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        the arch/x86 maintainers <x86@kernel.org>, linux-doc@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 0/2] Delay initializing of large sections of memory
References: <1371831934-156971-1-git-send-email-nzimmer@sgi.com> <20130621165142.GA32125@kroah.com> <51C48745.9030304@zytor.com> <CAE9FiQX3Opcv0E7+PXNAUoJtgoa0Cxv5wOK=R_ERvQjN79poXQ@mail.gmail.com> <20130621185056.GA23473@kroah.com> <51C4C5F3.3050800@sgi.com> <CAE9FiQXaUNbK9+g-7j6gfvLrSvUJFWWKapDv658LPe4VfbH=tQ@mail.gmail.com> <51C9D4ED.5070805@sgi.com>
In-Reply-To: <51C9D4ED.5070805@sgi.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2013 10:35 AM, Mike Travis wrote:
> 
> The two params that I couldn't figure out how to provide except via kernel
> param option was the memory block size (128M or 2G) and the physical
> address space per node.  The other 3 params can be automatically
> setup by a script when the total system size is known.  As soon as we
> verify on the 32TB system and surmise what will be needed for 64TB,
> then those 3 params can probably disappear.
> 

"Setup by script" is a no-go.  You *have* the total system size already,
it is in the e820 tables (anything which isn't in e820 is hotplug, that
automagically gets deferred.)

However, please consider Ingo's counterproposal of doing this via the
buddy allocator, i.e. hugepages being broken on demand.  That is a
*very* powerful model, although would require more infrastructure.

	-hpa



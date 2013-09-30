Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756484Ab3I3UEg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 16:04:36 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:63496 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755490Ab3I3UEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 16:04:35 -0400
MIME-Version: 1.0
In-Reply-To: <5249D897.1010109@hp.com>
References: <CA+55aFwp-RAKEMVvbMG53C=kTMqS09NPXy1eP4xEUYZpvV8X5Q@mail.gmail.com>
	<5249D897.1010109@hp.com>
Date: Mon, 30 Sep 2013 13:04:34 -0700
X-Google-Sender-Auth: 8VCm-YFVx3DUNJgWB06WM_3my7w
Message-ID: <CA+55aFw6tOVMw=pKE_knj4BOwTi_JAX=4N=-5_WduykNPotdww@mail.gmail.com>
Subject: Re: Avoiding the dentry d_lock on final dput(), part deux:
 transactional memory
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Waiman Long <waiman.long@hp.com>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        George Spelvin <linux@horizon.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 30, 2013 at 1:01 PM, Waiman Long <waiman.long@hp.com> wrote:
>
> I think this patch is worth a trial if relevant hardware is more widely
> available. The TSX code certainly need to be moved to an architecture
> specific area and should be runtime enabled using a static key. We also need
> more TSX support infrastructure in place first.

I think we can pick that up from Andi's patches, he should have that.
Although that did have very x86-specific naming (ie "xbegin"). And I
don't think he used "asm goto" to quite the same advantage as this -
and I think we do want to make sure that the overhead is minimal.

                  Linus

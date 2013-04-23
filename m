Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932181Ab3DWJy5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 05:54:57 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:47231 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755010Ab3DWJy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 05:54:56 -0400
Date: Tue, 23 Apr 2013 10:54:37 +0100
From: Will Deacon <will.deacon@arm.com>
To: Jacob Shin <jacob.shin@amd.com>
Cc: Ingo Molnar <mingo@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 1/4] perf: Add hardware breakpoint address mask
Message-ID: <20130423095437.GD17593@mudshark.cambridge.arm.com>
References: <1366703825-19373-1-git-send-email-jacob.shin@amd.com>
 <1366703825-19373-2-git-send-email-jacob.shin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366703825-19373-2-git-send-email-jacob.shin@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jacob,

On Tue, Apr 23, 2013 at 08:57:02AM +0100, Jacob Shin wrote:
> Some architectures (for us, AMD Family 16h) allow for "don't care" bit
> mask to further qualify a hardware breakpoint address, in order to
> trap on range of addresses. Update perf uapi to add bp_addr_mask field.

arm and arm64 have a similar feature to this, whereby we currently have to
translate the bp_len field into a mask, which is all the hardware
understands. Unlike what you describe, our mask indicates the bytes we *are*
interested in, but I think we could make use of the same functionality that
you're introducing here.

There are some funky restrictions on the alignment of the base address, but
we can detect those and tell userspace where to go if it tries any funny
stuff.

Can you see a problem if I simply invert the mask?

Will

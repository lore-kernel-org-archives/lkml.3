Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756457Ab3DWOen (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 10:34:43 -0400
Received: from co1ehsobe002.messaging.microsoft.com ([216.32.180.185]:34811
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756414Ab3DWOek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 10:34:40 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: VPS-5(zz98dI103dK1432Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzzz2dh668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1155h)
X-WSS-ID: 0MLPPT8-02-088-02
X-M-MSG: 
Date: Tue, 23 Apr 2013 09:34:23 -0500
From: Jacob Shin <jacob.shin@amd.com>
To: Will Deacon <will.deacon@arm.com>
CC: Ingo Molnar <mingo@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 1/4] perf: Add hardware breakpoint address mask
Message-ID: <20130423143423.GB17021@jshin-Toonie>
References: <1366703825-19373-1-git-send-email-jacob.shin@amd.com>
 <1366703825-19373-2-git-send-email-jacob.shin@amd.com>
 <20130423095437.GD17593@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130423095437.GD17593@mudshark.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 23, 2013 at 10:54:37AM +0100, Will Deacon wrote:
> Hi Jacob,
> 
> On Tue, Apr 23, 2013 at 08:57:02AM +0100, Jacob Shin wrote:
> > Some architectures (for us, AMD Family 16h) allow for "don't care" bit
> > mask to further qualify a hardware breakpoint address, in order to
> > trap on range of addresses. Update perf uapi to add bp_addr_mask field.
> 
> arm and arm64 have a similar feature to this, whereby we currently have to
> translate the bp_len field into a mask, which is all the hardware
> understands. Unlike what you describe, our mask indicates the bytes we *are*
> interested in, but I think we could make use of the same functionality that
> you're introducing here.
> 
> There are some funky restrictions on the alignment of the base address, but
> we can detect those and tell userspace where to go if it tries any funny
> stuff.
> 
> Can you see a problem if I simply invert the mask?

Hi,

That's great! No, I don't see a problem at all.

I guess now it can be debated if the mask coming in from userland should
be include or exclude mask. But I think exclude makes syntax easier:

To count writes to [0x1000 ~ 0x1010)

Include mask (my current patchset):

  perf stat -e mem:0x1000/0xf:w a.out

Exclude mask:

  perf stat -e mem:0x1000/0xfff0:w a.out

Thanks!


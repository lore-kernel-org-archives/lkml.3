Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933098Ab3CLRZM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 13:25:12 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:43025 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932270Ab3CLRZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 13:25:10 -0400
Date: Tue, 12 Mar 2013 10:25:05 -0700
From: Tejun Heo <tj@kernel.org>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Will Deacon <will.deacon@arm.com>, Nicolas Pitre <nico@linaro.org>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH v1] ARM: keep __my_cpu_offset consistent with generic one
Message-ID: <20130312172505.GA25266@htj.dyndns.org>
References: <1362663356-21151-1-git-send-email-tom.leiming@gmail.com>
 <CACVXFVOhr222CVrzkVP_oLgVkdReD9BXXSBg7fmp6Wvx9_peCw@mail.gmail.com>
 <20130312105638.GQ4977@n2100.arm.linux.org.uk>
 <CACVXFVOEvvFT805TJHoppqGRLTRuP18=Wg72LSXryffZD_WH1A@mail.gmail.com>
 <20130312113048.GS4977@n2100.arm.linux.org.uk>
 <CACVXFVP4NeZBg5yZW8q+vhgs0m3knkkdvyjv_hc9BLrFPqEBJA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVXFVP4NeZBg5yZW8q+vhgs0m3knkkdvyjv_hc9BLrFPqEBJA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Mar 12, 2013 at 07:44:55PM +0800, Ming Lei wrote:
> On Tue, Mar 12, 2013 at 7:30 PM, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
> >>
> >> Ingo and Peter, what is your opinion on the problem?
> >
> > Having discussed this with Ben Herrenschmidt, it seems that we do need
> > to have a more complex patch to sort this out - we need to setup our
> > private pointer inside setup_per_cpu_areas().
> 
> Suppose so, seems the patch is still needed to make CPU0 see
> static variables in '.data..percpu' section correctly.

If my memory serves me right, x86 also has places where CPU0 accesses
its per-cpu data in .data.percpu.  While those existed (not sure
they're still there but probably they're) mostly due to historical
reasons rather than by design, as long as the data is in consistent
state by and during percpu setup, nothing will break.

Thanks.

-- 
tejun

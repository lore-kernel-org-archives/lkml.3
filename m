Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754290AbaDWMYK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 08:24:10 -0400
Received: from moutng.kundenserver.de ([212.227.126.131]:51761 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773AbaDWMYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 08:24:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 04/28] nios2: Exception handling
Date: Wed, 23 Apr 2014 14:23:50 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Ley Foon Tan <lftan@altera.com>, "Linux-Arch" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        cltang@codesourcery.com
References: <1397824031-4892-1-git-send-email-lftan@altera.com> <CAFiDJ58oeUtXR_gqud9pw55wojY6PJRQp8PAyEfpDL_Let7u=Q@mail.gmail.com> <CAMuHMdX1xxuWhhBH0TKMtSEek5QDYchNVtC9QKoFQGr454_GVA@mail.gmail.com>
In-Reply-To: <CAMuHMdX1xxuWhhBH0TKMtSEek5QDYchNVtC9QKoFQGr454_GVA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201404231423.51221.arnd@arndb.de>
X-Provags-ID: V02:K0:0I9gPXfegTgfB4hEJaP5bTg9MH+03pEHIiy9kYDEOPf
 PzrTSoL8OEXqnYRpF1PzVUkG+S7GM8nCh3I/v8CHBfO/EebYSh
 TrfItZyc869nv/PBVPS+pTM4+K5ZitZ8tXJmJvcc+ysupWRNHA
 CUJmzuixo7q8rs2K8p3COCHj0wF+RV+m3idu5r3k6vuWvtTKrN
 DFfHgy94OKm4m/7kRFvDyuaee/o2pNBbsL8xtBAAHZJ7gCXw9I
 x5++p33H1vT2n+TBpgPF96336pCp794ef+PV2OwLNQRMg+YpAG
 pv/puY8MuiZ936w9NpYrY9wJBeFD9s1X3Cbg5N0iXOIU3isyDi
 uxAV6PAAn7qkBKEUWZ2M=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 April 2014, Geert Uytterhoeven wrote:
> On Wed, Apr 23, 2014 at 4:47 AM, Ley Foon Tan <lftan@altera.com> wrote:
> > On Tue, Apr 22, 2014 at 8:33 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> >> On Friday 18 April 2014, Ley Foon Tan wrote:
> >>> +static const struct file_operations misalign_fops = {
> >>> +       .open           = proc_misaligned_open,
> >>> +       .read           = seq_read,
> >>> +       .llseek         = seq_lseek,
> >>> +       .release        = single_release,
> >>> +       .write          = proc_misaligned_write,
> >>> +};
> >>> +#endif /* CONFIG_PROC_FS */
> >>
> >> We really shouldn't be doing new architecture specific procfs files
> >> any more. I suggest you drop this one for now, and add back the
> >> functionality using perf or ftrace at a later point.
> >
> > Okay, will remove this.
> 
> MIPS and powerpc handle this through debugfs, cfr.
> arch/mips/kernel/unaligned.c and arch/powerpc/kernel/traps.c.

Ah, right, that would work too. Being able to use perf from user
space sounds more flexible though. It's certainly something that
can be decided later.

	Arnd

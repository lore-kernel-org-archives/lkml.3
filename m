Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337AbaBTVY4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 16:24:56 -0500
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:53630 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751286AbaBTVYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 16:24:55 -0500
Message-ID: <1392931493.15264.17.camel@x220>
Subject: Re: [PATCH] drm/radeon: silence GCC warning on 32 bit
From: Paul Bolle <pebolle@tiscali.nl>
To: Ilia Mirkin <imirkin@alum.mit.edu>
Cc: Dave Airlie <airlied@linux.ie>,
        Christian =?ISO-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 20 Feb 2014 22:24:53 +0100
In-Reply-To: <CAKb7Uvg=U+b0d2uBM3rrXzotdCM=VZsJ0ArPU82Nzy95S=WZRw@mail.gmail.com>
References: <alpine.DEB.2.00.1401300249130.13810@skynet.skynet.ie>
	 <1391085212.5170.9.camel@x41> <1392930177.15264.5.camel@x220>
	 <CAKb7Uvg=U+b0d2uBM3rrXzotdCM=VZsJ0ArPU82Nzy95S=WZRw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Feb 2014 21:24:54.0300 (UTC) FILETIME=[3262DDC0:01CF2E82]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-02-20 at 16:07 -0500, Ilia Mirkin wrote:
> On Thu, Feb 20, 2014 at 4:02 PM, Paul Bolle <pebolle@tiscali.nl> wrote:
> > @@ -935,7 +935,7 @@ static ssize_t radeon_ttm_gtt_read(struct file *f, char __user *buf,
> >         while (size) {
> >                 loff_t p = *pos / PAGE_SIZE;
> >                 unsigned off = *pos & ~PAGE_MASK;
> > -               ssize_t cur_size = min(size, PAGE_SIZE - off);
> > +               ssize_t cur_size = min(size, (size_t)(PAGE_SIZE - off));
> 
> Isn't the usual way of dealing with these to do something like
> 
> ssize_t cur_size = min_t(ssize_t, size, PAGE_SIZE - off)

I wouldn't know. I did
    $ git grep -n "(size_t)(PAGE_SIZE"
    arch/powerpc/mm/dma-noncoherent.c:357:  size_t seg_size = min((size_t)(PAGE_SIZE - offset), size);
    arch/tile/kernel/pci-dma.c:176: size_t bytes = min(size, (size_t)(PAGE_SIZE - offset));
    arch/tile/kernel/pci-dma.c:192: size_t bytes = min(size, (size_t)(PAGE_SIZE - offset));
    drivers/net/wireless/ti/wlcore/main.c:806:      len = min(maxlen, (size_t)(PAGE_SIZE - wl->fwlog_size));
    drivers/scsi/libfc/fc_libfc.c:143:                             (size_t)(PAGE_SIZE - (off & ~PAGE_MASK)));
    drivers/target/tcm_fc/tfc_io.c:160:                     tlen = min(tlen, (size_t)(PAGE_SIZE -
    drivers/target/tcm_fc/tfc_io.c:311:             tlen = min(tlen, (size_t)(PAGE_SIZE -

and concluded my solution was acceptable. Is your alternative considered
to be better?


Paul Bolle


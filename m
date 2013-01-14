Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757772Ab3ANTUI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 14:20:08 -0500
Received: from mail.kernel.org ([198.145.19.201]:50177 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756551Ab3ANTUF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 14:20:05 -0500
Date: Mon, 14 Jan 2013 11:19:53 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Mitch Harder <mitch.harder@sabayonlinux.org>
Cc: Nitin Gupta <ngupta@vflare.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Jerome Marchand <jmarchan@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Minchan Kim <minchan.kim@gmail.com>,
        Linux Driver Project <devel@linuxdriverproject.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: zram: fix invalid memory references during disk write
Message-ID: <20130114191953.GA6588@kroah.com>
References: <1354257909-2380-1-git-send-email-ngupta@vflare.org>
 <20121211182720.GC29421@kroah.com>
 <CAPkvG_c0HayXO50SKCd==T-M4W1r8JUSi_VgGDiP+M+i=DpbZA@mail.gmail.com>
 <20121219034949.GA22281@kroah.com>
 <50D16AF8.7030401@vflare.org>
 <20121219150826.GA23953@kroah.com>
 <50D1E300.4000006@vflare.org>
 <20121219161705.GA24251@kroah.com>
 <50D1F799.4060800@vflare.org>
 <CAKcLGm9eFRQrAc_Nm0Z658ct46psVemWt4c8NbpETjhMF3A+jQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKcLGm9eFRQrAc_Nm0Z658ct46psVemWt4c8NbpETjhMF3A+jQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2012 at 11:39:15AM -0600, Mitch Harder wrote:
> On Wed, Dec 19, 2012 at 11:21 AM, Nitin Gupta <ngupta@vflare.org> wrote:
> > On 12/19/2012 08:17 AM, Greg KH wrote:
> >> On Wed, Dec 19, 2012 at 07:53:36AM -0800, Nitin Gupta wrote:
> >>> On 12/19/2012 07:08 AM, Greg KH wrote:
> >>>> On Tue, Dec 18, 2012 at 11:21:28PM -0800, Nitin Gupta wrote:
> >>>>> On 12/18/2012 07:49 PM, Greg KH wrote:
> >>>>>> On Tue, Dec 18, 2012 at 01:12:05PM -0800, Nitin Gupta wrote:
> >>>>>>> On Tue, Dec 11, 2012 at 10:27 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> >>>>>>>> On Thu, Nov 29, 2012 at 10:45:09PM -0800, Nitin Gupta wrote:
> >>>>>>>>> Fixes a bug introduced by commit c8f2f0db1 ("zram: Fix handling
> >>>>>>>>> of incompressible pages") which caused invalid memory references
> >>>>>>>>> during disk write. Invalid references could occur in two cases:
> >>>>>>>>>  - Incoming data expands on compression: In this case, reference was
> >>>>>>>>> made to kunmap()'ed bio page.
> >>>>>>>>>  - Partial (non PAGE_SIZE) write with incompressible data: In this
> >>>>>>>>> case, reference was made to a kfree()'ed buffer.
> >>>>>>>>>
> >>>>>>>>> Fixes bug 50081:
> >>>>>>>>> https://bugzilla.kernel.org/show_bug.cgi?id=50081
> >>>>>>>>>
> >>>>>>>>> Upstream commit ID: c8f2f0d: zram: Fix handling of incompressible pages
> >>>>>>>>> Apply to versions: 3.6.5, 3.6.6, 3.6.7, 3.6.8
> >>>>>>>>>
> >>>>>>>>> Cc: <stable@vger.kernel.org> # staging-next: 37b51fd: zram: factor-out
> >>>>>>>>>                               # zram_decompress_page() function
> >>>>>>>>> Signed-off-by: Nitin Gupta <ngupta@vflare.org>
> >>>>>>>>> Reported-by: Mihail Kasadjikov <hamer.mk@gmail.com>
> >>>>>>>>> Reported-by: Tomas M <tomas@slax.org>
> >>>>>>>>> Reviewed-by: Minchan Kim <minchan@kernel.org>
> >>>>>>>>> ---
> >>>>>>>>>  drivers/staging/zram/zram_drv.c |   39 ++++++++++++++++++++++++---------------
> >>>>>>>>>  1 file changed, 24 insertions(+), 15 deletions(-)
> >>>>>>>>
> >>>>>>>> This patch fails to apply to 3.6.10:
> >>>>>>>>
> >>>>>>>> patching file drivers/staging/zram/zram_drv.c
> >>>>>>>> Hunk #1 succeeded at 282 (offset 17 lines).
> >>>>>>>> Hunk #2 FAILED at 286.
> >>>>>>>> Hunk #3 succeeded at 319 (offset 17 lines).
> >>>>>>>> Hunk #4 succeeded at 340 (offset 17 lines).
> >>>>>>>> Hunk #5 succeeded at 353 (offset 17 lines).
> >>>>>>>> Hunk #6 succeeded at 368 (offset 17 lines).
> >>>>>>>> Hunk #7 succeeded at 385 (offset 17 lines).
> >>>>>>>> 1 out of 7 hunks FAILED -- saving rejects to file drivers/staging/zram/zram_drv.c.rej
> >>>>>>>>
> >>>>>>>> Please redo this patch and resend it if you wish for it to be applied to
> >>>>>>>> the 3.6-stable tree.
> >>>>>>>>
> >>>>>>>>
> >>>>>>>
> >>>>>>> Please apply this patch to stable tree asap.
> >>>>>>
> >>>>>> 3.6 is now end-of-life, there will not be any more releases for that
> >>>>>> kernel series anymore, sorry.
> >>>>>>
> >>>>>
> >>>>> Then please apply to 3.7.
> >>>>
> >>>> That is impossible to do so, for the obvious reason.
> >>>>
> >>>
> >>> I meant to include it in whatever 3.7.x is released in future. Or put it
> >>> in staging, so it may eventually make it to mainline (by 3.8?).
> >>
> >> {sigh}
> >>
> >> Please think for a moment for how it would be impossible for me to add
> >> this patch to either the 3.7-stable tree, or the 3.8 tree, _again_.
> >>
> >
> > I'm simply not getting it, I'm sorry, I must be missing something
> > obvious -- what's really the problem with this: "whenever 3.8 is
> > released, sometime in the future, just make sure that this fix is
> > included in it" ?  Also, what's stopping it from staging, at least?
> >
> 
> Greg:
> 
> I think there is still some residual confusion from the mix of patches
> sent out for this issue.
> 
> You appear to be saying that this patch as well as "37b51fd: zram:
> factor-out  zram_decompress_page() function" have already been
> applied.
> 
> But I do not see either patch in 3.7.0 or in your message for
> "3.7.1-stable review"
> 
> I see the "37b51fd: zram: factor-out  zram_decompress_page() function"
> patch in Linus' tree for 3.8_rc, but not the patch discussed in this
> thread.

Ok, I'm totally confused.

Please, can someone tell me _exactly_ what commits they wish to see
applied to the 3.7-stable tree.

thanks,

greg k-h

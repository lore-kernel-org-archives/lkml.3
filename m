Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755800AbaHERJY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 13:09:24 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:55503 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276AbaHERJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 13:09:22 -0400
MIME-Version: 1.0
In-Reply-To: <20140805072712.GA14966@mguzik>
References: <1407214617-27317-1-git-send-email-xerofoify@gmail.com>
	<20140805054555.GA1920@kroah.com>
	<CAPDOMVg_Y7VgdM0ovcS=w7juBZ4n3xnV+kzbtzTxNZjEKzC3sA@mail.gmail.com>
	<20140805072712.GA14966@mguzik>
Date: Tue, 5 Aug 2014 13:02:40 -0400
Message-ID: <CAPDOMVj6xxYRk=1_FQ2TbYx5jTJ86E=u2A8T53rJ-xszkDomJA@mail.gmail.com>
Subject: Re: [PATCH] xhci: Merge and Update debugging for patches from 3.6
 kernel tree
From: Nick Krause <xerofoify@gmail.com>
To: Mateusz Guzik <mguzik@redhat.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        "Nyman, Mathias" <mathias.nyman@intel.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Deepak Saxena <dsaxena@linaro.org>,
        "manjunath.goudar" <manjunath.goudar@linaro.org>,
        "jg1.han" <jg1.han@samsung.com>, davidm <davidm@egauge.net>,
        Ksenia Ragiadakou <burzalodowa@gmail.com>,
        hartleys <hartleys@visionengravers.com>,
        "gregory.clement" <gregory.clement@free-electrons.com>,
        oneukum <oneukum@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 5, 2014 at 3:27 AM, Mateusz Guzik <mguzik@redhat.com> wrote:
> On Tue, Aug 05, 2014 at 01:55:34AM -0400, Nick Krause wrote:
>> On Tue, Aug 5, 2014 at 1:45 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
>> > On Tue, Aug 05, 2014 at 12:56:57AM -0400, Nicholas Krause wrote:
>> >> I am adding the fixes to the tree send for adding debugging to the kernel
>> >> tree from a patch sent in 2013 on the the 3.6 release. The patch adds
>> >> debugging over xhci capable debugging usb ports and needed to be updated
>> >> into the latest rc tree. The patch was first sent in this thread,
>> >> http://marc.info/?l=linux-usb&m=135948845511047.
>> >>
>> >> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
>> >
>> > If you send one more patch, I am going to have to ask vger.kernel.org to
>> > ban you from their servers.  You are actively bothering people and
>> > causing problems and wasting time.
>> >
>> > You have been told _numerous_ times to stop, yet you refuse to listen.
>> > You hold the record for getting kicked out of the Eudyptula challenge in
>> > a matter of hours, something no one else has ever had happen.  You
>> > ignore lots of very valid comments and suggestions, for no good reason.
>> > You flail about, making mistakes that are now starting to bother users,
>> > which is not acceptable at all.
>> >
>> > I will not respond to any more of your emails, and ask everyone else to
>> > now stop as well.
>> >
>> > good bye.
>> >
>> > *plonk*
>> >
>> > greg k-h
>>
>> Greg,
>> You haven't even checked my patch, our you just going to assume it's wrong?
>
>
> I don't know this code and I'm not interested in changing that, so just I'm
> just pointing out obvious problems.
>
> 1. You somehow managed to have changes like his all over the patch:
> -#define TT_HS_OVERHEAD (31 + 94)
> -#define TT_DMI_OVERHEAD (25 + 12)
> +#define TT_HS_OVERHEAD (31  94)
> +#define TT_DMI_OVERHEAD (25  12)
>
> Clearly, this will cause compilation problems. But maybe this weird
> corruption happened after you tested your patch?
>
> 2.  In the original patch there were some additions to struct xhci_hcd,
> e.g. dbg_cap_reg.
>
> Let's look at a random user:
> +void xhci_teardown_dbg_cap(struct xhci_hcd *xhci, struct device *dev)
> +{
> +       u32 val;
> +
> +       xhci_dbg(xhci, "xhci_teardown_dbg_cap()\n");
> +       if (!xhci->dbg_cap_regs)
> +               return;
>
> xhci is a pointer to struct xhci_hcd.
>
> Except in your patch all these additions landed in struct xhci_dbg_cap_ctx,
> thus this could not possibly compile.
>
> But what's the most important thing here is this: writing a compilable
> patch is not a problem, writing a working patch is.
>
> Forward porting, like this one, demands that you:
> - understand the patch as applied to the original tree
> - understand current state of the tree and how it influences the patch
>
> As such, foward porting is typically not a task for beginners.
>
> I can only recommend one last time you leave the kernel alone for the
> time being and focus on userspace.
>
> There. This is my last reply, have fun.
>
> --
> Mateusz Guzik
 Matueuz ,
I am going to not send any more patches for now at least. I am
going to just read the lkml.
Regards Nick

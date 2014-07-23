Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757923AbaGWOhM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 10:37:12 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:6685 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753110AbaGWOhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 10:37:11 -0400
Date: Wed, 23 Jul 2014 10:37:07 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Nick Krause <xerofoify@gmail.com>
Cc: Levente Kurusa <lkurusa@redhat.com>, Tony Luck <tony.luck@gmail.com>,
        =?ISO-8859-1?B?Qmr4cm4=?= Mork <bjorn@mork.no>,
        Doug Thompson <dougthompson@xmission.com>,
        Borislav Petkov <bp@alien8.de>,
        "m.chehab@samsung.com" <m.chehab@samsung.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] edac: Remove fixmes in e7xxx_edac.c
Message-ID: <20140723103707.64071c00@gandalf.local.home>
In-Reply-To: <CAPDOMVipLiXuYqndO_gnMYocDLVsHX9zcTdSMUV_EjJo72nx6w@mail.gmail.com>
References: <1406004789-9918-1-git-send-email-xerofoify@gmail.com>
	<874my98p6u.fsf@nemi.mork.no>
	<CA+8MBb+fnCNeQtyEqttxbkWx-4N+GUaKCUoCSdn5X9+bDDvTOg@mail.gmail.com>
	<CAPDOMVjaf+vne4vbUPo8EPs0XnQBbNm2ZOXns8fw5pkg9tRSww@mail.gmail.com>
	<CAAsK9AGtdJiz0xnmfqLBAqxmt=r+WANsmxwB_vQ3O5aKzMW1LQ@mail.gmail.com>
	<CAPDOMVhj72TFKbtw_93juX19WVdfUzh3KM9tCEjbTdUZvUfcUQ@mail.gmail.com>
	<20140722193350.GA486@home.goodmis.org>
	<CAPDOMVipLiXuYqndO_gnMYocDLVsHX9zcTdSMUV_EjJo72nx6w@mail.gmail.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jul 2014 16:56:06 -0400
Nick Krause <xerofoify@gmail.com> wrote:

> On Tue, Jul 22, 2014 at 3:33 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > On Tue, Jul 22, 2014 at 02:25:24PM -0400, Nick Krause wrote:
> >>
> >> I understand what your saying and I should have searched for Page shift.
> >> In addition I am already got commits in the kernel for fix mes so I feel
> >> that your comment on fix mes is incorrect.
> >
> > After seeing your other solutions to "fix mes" around the kernel, I now have to
> > investigate the patches that were accepted, and see if they did not cause
> > any new bugs. If any of them do, I will ask to have all your patches reverted.
> >
> > You are not helping. You are actually doing quite the opposite. Who do you work
> > for? Microsoft or Apple?
> >
> > -- Steve
> >
> 
> I don't work for any companies. And here is one of them that has been accepted.
> I am removing two fix mes in this file as after dicussing then it  seems
> there is no reason to check against Null for usb_device as it can never
> be NULL and this is check is therefore not needed.

http://marc.info/?l=linux-m68k&m=140612440420712&w=2

And your patches seem to be getting reverted. Wow, I think you broke a
new record in having the percentage of patches added to the kernel and
then reverted. Even before they made it to mainline.

You may be the only developer that has all their commits reverted
before they ever make it into the mainline tree!

Congratulations! I think it is wise now for all maintainers to add your
email to their /dev/null folder. It will help them from wasting any
more of their precious time on you.

-- Steve



> 
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> ---
>  drivers/usb/core/hcd.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
> index bec31e2..487abcf 100644
> --- a/drivers/usb/core/hcd.c
> +++ b/drivers/usb/core/hcd.c
> @@ -855,8 +855,6 @@ static ssize_t authorized_default_show(struct device *dev,
>         struct usb_bus *usb_bus = rh_usb_dev->bus;
>         struct usb_hcd *usb_hcd;
> 
> -       if (usb_bus == NULL)    /* FIXME: not sure if this case is possible */
> -               return -ENODEV;
>         usb_hcd = bus_to_hcd(usb_bus);
>         return snprintf(buf, PAGE_SIZE, "%u\n", usb_hcd->authorized_default);
>  }
> @@ -871,8 +869,6 @@ static ssize_t authorized_default_store(
> struct device *dev,
>         struct usb_bus *usb_bus = rh_usb_dev->bus;
>         struct usb_hcd *usb_hcd;
> 
> -       if (usb_bus == NULL)    /* FIXME: not sure if this case is possible */
> -               return -ENODEV;
>         usb_hcd = bus_to_hcd(usb_bus);
>         result = sscanf(buf, "%u\n", &val);
>         if (result == 1) {
> Nick


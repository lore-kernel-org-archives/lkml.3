Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751741AbaKCMam (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 07:30:42 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:60089 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523AbaKCMak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 07:30:40 -0500
Date: Mon, 3 Nov 2014 12:30:35 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: kernel list <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, stable@vger.kernel.org
Subject: Re: [PATCH] mfd: tc6393xb fail ohci suspend if full state restore is
 required
Message-ID: <20141103123035.GD4538@x1>
References: <1414171197-18620-1-git-send-email-dbaryshkov@gmail.com>
 <CALT56yPLnitsAqKJ=ryFE1uXwQqpbqwP3BmOf8L+fYG88kPnhw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALT56yPLnitsAqKJ=ryFE1uXwQqpbqwP3BmOf8L+fYG88kPnhw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Oct 2014, Dmitry Eremin-Solenikov wrote:

> 2014-10-24 20:19 GMT+03:00 Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>:
> > Some boards with TC6393XB chip require full state restore during system
> > resume thanks to chip's VCC being cut off during suspend (Sharp SL-6000
> > tosa is one of them). Failing to do so would result in ohci Oops on
> > resume due to internal memory contentes being changed. Fail ohci suspend
> > on tc6393xb is full state restore is required.
> >
> > Recommended workaround is to unbind tmio-ohci driver before suspend and
> > rebind it after resume.
> 
> ping

Don't do that.  If you think the patch has slipped through the net
please sent it again with a [RESEND] tag in the email's subject line.

As it happens it hasn't been forgotten about, I was on vacation last
week and will get round to reviewing this shortly.

> > Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
> > Cc: stable@vger.kernel.org
> > ---
> >  drivers/mfd/tc6393xb.c | 13 ++++++++++++-
> >  1 file changed, 12 insertions(+), 1 deletion(-)
> 
> 
> 

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060Ab3A3NLX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 08:11:23 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:40091 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753766Ab3A3NLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 08:11:20 -0500
Message-ID: <1359551465.3325.14.camel@thor.lan>
Subject: Re: [PATCH 10/11] staging/fwserial: Fix premature unthrottle
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Stefan Richter <stefanr@s5r6.in-berlin.de>
Date: Wed, 30 Jan 2013 08:11:05 -0500
In-Reply-To: <20130130042947.GA25371@kroah.com>
References: <1359430485-5301-1-git-send-email-peter@hurleysoftware.com>
	 <1359430485-5301-10-git-send-email-peter@hurleysoftware.com>
	 <20130130042947.GA25371@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-01-29 at 23:29 -0500, Greg Kroah-Hartman wrote:
> On Mon, Jan 28, 2013 at 10:34:44PM -0500, Peter Hurley wrote:
> > The unthrottle may restart the writer before the rx push
> > has a chance to start emptying the rx buffer, resulting in an
> > overflowed rx buffer and lost data.
> > 
> > Perform the actual device unthrottle with the rx push instead.
> > 
> > Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
> > ---
> >  drivers/staging/fwserial/fwserial.c | 30 ++++++++++++++----------------
> >  1 file changed, 14 insertions(+), 16 deletions(-)
> 
> this patch fails to apply to my tree, but the 9 previous ones were fine,
> so I'll not apply it, or ght 11/11 patch.  Care to fix it up and resend
> both of them?

Hi Greg,

I can rebase these against your staging-next, if you'd prefer, but it
will make the -next merge non-trivial.

Your tty-next tree is carrying patches to this driver from patch series
  "TTY: switch flipping functions to tty_port"
which is already in -next.

Let me know what you'd like me to do.

Regards,
Peter Hurley


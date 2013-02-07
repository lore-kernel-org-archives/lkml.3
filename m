Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758833Ab3BGP6l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 10:58:41 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:38985 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758674Ab3BGP6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 10:58:39 -0500
Message-ID: <1360252707.4102.41.camel@thor.lan>
Subject: Re: [PATCH v3 02/23] n_tty: Factor packet mode status change for
 reuse
From: Peter Hurley <peter@hurleysoftware.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, Sasha Levin <levinsasha928@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ilya Zykov <ilya@ilyx.ru>, Dave Jones <davej@redhat.com>
Date: Thu, 07 Feb 2013 10:58:27 -0500
In-Reply-To: <5113BF7C.5060201@suse.cz>
References: <1355509370-5883-1-git-send-email-peter@hurleysoftware.com>
	 <1360095638-6624-1-git-send-email-peter@hurleysoftware.com>
	 <1360095638-6624-3-git-send-email-peter@hurleysoftware.com>
	 <5113BF7C.5060201@suse.cz>
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

On Thu, 2013-02-07 at 15:51 +0100, Jiri Slaby wrote:
> On 02/05/2013 09:20 PM, Peter Hurley wrote:
> > Factor the packet mode status change from n_tty_flush_buffer
> > for use by follow-on patch.
> > 
> > Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
> > ---
> >  drivers/tty/n_tty.c | 24 ++++++++++++++----------
> >  1 file changed, 14 insertions(+), 10 deletions(-)
> > 
> > diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
> > index bf6958b..7194a33 100644
> > --- a/drivers/tty/n_tty.c
> > +++ b/drivers/tty/n_tty.c
> > @@ -237,6 +237,18 @@ static void reset_buffer_flags(struct tty_struct *tty)
> >  	n_tty_set_room(tty);
> >  }
> >  
> > +static void packet_mode_flush(struct tty_struct *tty)
> 
> I prefer naming functions according the name space they live in. In this
> case n_tty_flush_packet_mode would be much better. Other than that this
> one looks good.

Ok, I'll do that.

(FWIW, the reason I used that naming was the 'n_tty style' appears to be
un-prefixed file-scope functions and prefixed global-scope functions.)



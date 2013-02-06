Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757476Ab3BFQlO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 11:41:14 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:54675 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756889Ab3BFQlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 11:41:12 -0500
Message-ID: <1360168863.3298.60.camel@thor.lan>
Subject: Re: [PATCH 3/4] pps: Use lookup list to reduce ldisc coupling
From: Peter Hurley <peter@hurleysoftware.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: George Spelvin <linux@horizon.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rodolfo Giometti <giometti@enneenne.com>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 06 Feb 2013 11:41:03 -0500
In-Reply-To: <511282D1.7030200@suse.cz>
References: <20130204010303.24971.qmail@science.horizon.com>
	 <1360166116-30797-1-git-send-email-peter@hurleysoftware.com>
	 <1360166116-30797-4-git-send-email-peter@hurleysoftware.com>
	 <511282D1.7030200@suse.cz>
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

On Wed, 2013-02-06 at 17:20 +0100, Jiri Slaby wrote:
> On 02/06/2013 04:55 PM, Peter Hurley wrote:
> > --- a/drivers/pps/clients/pps-ldisc.c
> > +++ b/drivers/pps/clients/pps-ldisc.c
> > @@ -25,17 +25,47 @@
> ...
> > +struct pps_data {
> > +	struct pps_device *pps;
> > +	struct tty_struct *tty;
> > +	struct list_head link;
> > +};
> > +
> > +DEFINE_SPINLOCK(pps_lock);
> > +static LIST_HEAD(pps_list);
> 
> All 4 look fine, nice cleanup. Except the lock above should be static too.

Whoops. Thanks for catching that!  (rebasing error... :)



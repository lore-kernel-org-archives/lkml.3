Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958Ab3LQIOO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 03:14:14 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:43344 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001Ab3LQIOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 03:14:12 -0500
Subject: Re: [RFC PATCH] net, tun: remove the flow cache
From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Reply-To: wuzhy@linux.vnet.ibm.com
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: Zhi Yong Wu <zwu.kernel@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net, mst@redhat.com,
        jasowang@redhat.com
Date: Tue, 17 Dec 2013 16:13:58 +0800
In-Reply-To: <20131216234736.781457cd@samsung-9.home.lan>
References: <1387265182-27312-1-git-send-email-zwu.kernel@gmail.com>
	 <20131216234736.781457cd@samsung-9.home.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1387268041.7571.10.camel@f15>
Mime-Version: 1.0
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13121708-9332-0000-0000-00000285002B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-12-16 at 23:47 -0800, Stephen Hemminger wrote:
> On Tue, 17 Dec 2013 15:26:22 +0800
> Zhi Yong Wu <zwu.kernel@gmail.com> wrote:
> 
> > From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> > 
> > The flow cache is an extremely broken concept, and it usually brings up
> > growth issues and DoS attacks, so this patch is trying to remove it from
> > the tuntap driver, and insteadly use a simpler way for its flow control.
> > 
> > Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> > ---
> >  drivers/net/tun.c |  208 +++--------------------------------------------------
> >  1 files changed, 10 insertions(+), 198 deletions(-)
> > 
> > diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> > index 7c8343a..7c27fdc 100644
> > --- a/drivers/net/tun.c
> > +++ b/drivers/net/tun.c
> > @@ -32,12 +32,15 @@
> >   *
> >   *  Daniel Podlejski <underley@underley.eu.org>
> >   *    Modifications for 2.3.99-pre5 kernel.
> > + *
> > + *  Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> > + *    Remove the flow cache.
> >   */
> 
> I agree with your patch, but please don't add to the comment changelog.
> These are all historical. The kernel development process has not used
> them for 5+ years.
> 
> Can we get kernel janitors to just remove them, or would that step
> on too many early developers toes by removing credit?
I thought that it is a big code change, and need to add some changelog
for this, but you seem to have a big argue. :) I don't object to
removing my comment in its changelog if other guys also agree with you.


> 

-- 
Regards,

Zhi Yong Wu


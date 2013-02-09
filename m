Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932290Ab3BIAoV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 19:44:21 -0500
Received: from mail-da0-f44.google.com ([209.85.210.44]:59734 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932195Ab3BIAoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 19:44:20 -0500
Date: Fri, 8 Feb 2013 16:44:17 -0800
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: KY Srinivasan <kys@microsoft.com>
Cc: Jiri Kosina <jkosina@suse.cz>, "olaf@aepfle.de" <olaf@aepfle.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "James.Bottomley@HansenPartnership.com" 
	<James.Bottomley@HansenPartnership.com>,
        "apw@canonical.com" <apw@canonical.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH 6/6] Drivers: hv: Execute shutdown in a thread context
Message-ID: <20130209004417.GA31290@kroah.com>
References: <1358991737-22675-1-git-send-email-kys@microsoft.com>
 <1358991765-22715-1-git-send-email-kys@microsoft.com>
 <1358991765-22715-6-git-send-email-kys@microsoft.com>
 <alpine.LNX.2.00.1301241108590.31600@pobox.suse.cz>
 <53da151ef8494d5084ef5aa089b9f102@SN2PR03MB061.namprd03.prod.outlook.com>
 <20130124171740.GA5420@kroah.com>
 <4555fa7d062a4fc18763f3f204c1df8b@SN2PR03MB061.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4555fa7d062a4fc18763f3f204c1df8b@SN2PR03MB061.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 09, 2013 at 12:31:49AM +0000, KY Srinivasan wrote:
> 
> 
> > -----Original Message-----
> > From: gregkh@linuxfoundation.org [mailto:gregkh@linuxfoundation.org]
> > Sent: Thursday, January 24, 2013 12:18 PM
> > To: KY Srinivasan
> > Cc: Jiri Kosina; olaf@aepfle.de; jasowang@redhat.com; linux-
> > kernel@vger.kernel.org; James.Bottomley@HansenPartnership.com;
> > apw@canonical.com; devel@linuxdriverproject.org; davem@davemloft.net
> > Subject: Re: [PATCH 6/6] Drivers: hv: Execute shutdown in a thread context
> > 
> > On Thu, Jan 24, 2013 at 05:06:27PM +0000, KY Srinivasan wrote:
> > >
> > >
> > > > -----Original Message-----
> > > > From: Jiri Kosina [mailto:jkosina@suse.cz]
> > > > Sent: Thursday, January 24, 2013 5:10 AM
> > > > To: KY Srinivasan
> > > > Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> > > > devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> > > > jasowang@redhat.com; davem@davemloft.net;
> > > > James.Bottomley@HansenPartnership.com
> > > > Subject: Re: [PATCH 6/6] Drivers: hv: Execute shutdown in a thread context
> > > >
> > > > On Wed, 23 Jan 2013, K. Y. Srinivasan wrote:
> > > >
> > > > > Execute the shutdown code in a thread context. With recent changes made
> > to
> > > > the
> > > > > shutdown code, shutdown code cannot be invoked from an interrupt
> > context.
> > > > >
> > > > > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > > > > Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
> > > > > ---
> > > > >  drivers/hv/hv_util.c |   12 +++++++++++-
> > > > >  1 files changed, 11 insertions(+), 1 deletions(-)
> > > > >
> > > > > diff --git a/drivers/hv/hv_util.c b/drivers/hv/hv_util.c
> > > > > index 8b7868a..aceb67f 100644
> > > > > --- a/drivers/hv/hv_util.c
> > > > > +++ b/drivers/hv/hv_util.c
> > > > > @@ -49,6 +49,16 @@ static struct hv_util_service util_kvp = {
> > > > >  	.util_deinit = hv_kvp_deinit,
> > > > >  };
> > > > >
> > > > > +static void perform_shutdown(struct work_struct *dummy)
> > > > > +{
> > > > > +		orderly_poweroff(true);
> > > > > +}
> > > >
> > > > Is there any particular reason for this kind of crazy indentation?
> > > I don't know how this extra tab crept through! Greg, if you want I can resend
> > > this patch minus the extra tab. Let me know.
> > 
> > I'll edit it by hand, but someone owes me a beer for it...  :)
> 
> I just saw that you closed the tree. Did these patches go in?

They should have, didn't you get an email saying they were in?  If not,
check my git trees to verify.

thanks,

greg k-h

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751448Ab3CAQLa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 11:11:30 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:52906 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058Ab3CAQL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 11:11:28 -0500
Date: Fri, 1 Mar 2013 08:11:24 -0800
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: KY Srinivasan <kys@microsoft.com>
Cc: "olaf@aepfle.de" <olaf@aepfle.de>, Jiri Kosina <jkosina@suse.cz>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "James.Bottomley@HansenPartnership.com" 
	<James.Bottomley@HansenPartnership.com>,
        "apw@canonical.com" <apw@canonical.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH 6/6] Drivers: hv: Execute shutdown in a thread context
Message-ID: <20130301161124.GA3969@kroah.com>
References: <1358991737-22675-1-git-send-email-kys@microsoft.com>
 <1358991765-22715-1-git-send-email-kys@microsoft.com>
 <1358991765-22715-6-git-send-email-kys@microsoft.com>
 <alpine.LNX.2.00.1301241108590.31600@pobox.suse.cz>
 <53da151ef8494d5084ef5aa089b9f102@SN2PR03MB061.namprd03.prod.outlook.com>
 <20130124171740.GA5420@kroah.com>
 <524a403348d240a8b24db0177e7aaecd@SN2PR03MB061.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524a403348d240a8b24db0177e7aaecd@SN2PR03MB061.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 01, 2013 at 03:15:58PM +0000, KY Srinivasan wrote:
> > > > > Execute the shutdown code in a thread context. With recent changes made
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
> Greg,
> 
> You have already applied this. There has been some customer request for getting this
> patch into 3.7 (3.7 is where the Hyper-V shutdown code ceased to work because of 
> some other patches unrelated to Hyper-V that went in). What is the process for requesting
> that this patch be applied all the way back to 3.7.

You have read the file, Documentation/stable_kernel_rules.txt, right?

But please remember, the 3.7 kernel is now end-of-life, as of the 3.7.10
kernel release, so even if this was a bug fix that was applicable to
stable kernels, it would be impossible to get it into the 3.7.y
releases, without going back in time.

sorry,

greg k-h

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890AbaINWGE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 18:06:04 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:40944 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752765AbaINWGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 18:06:01 -0400
Date: Mon, 15 Sep 2014 00:05:56 +0200
From: Frans Klaver <fransklaver@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Darren Hart <dvhart@infradead.org>,
        Corentin Chary <corentin.chary@gmail.com>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/13] eeepc-laptop: use DEVICE_ATTR to instantiate
 device_attributes
Message-ID: <20140914220555.GA3401@gmail.com>
References: <1410563212-31565-1-git-send-email-fransklaver@gmail.com>
 <1410563212-31565-6-git-send-email-fransklaver@gmail.com>
 <20140912232851.GA17095@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140912232851.GA17095@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2014 at 04:28:51PM -0700, Greg Kroah-Hartman wrote:
> On Sat, Sep 13, 2014 at 01:06:44AM +0200, Frans Klaver wrote:
> > Signed-off-by: Frans Klaver <fransklaver@gmail.com>
> > ---
> >  drivers/platform/x86/eeepc-laptop.c | 35 +++++------------------------------
> >  1 file changed, 5 insertions(+), 30 deletions(-)
> > 
> > diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
> > index f35d008..8225b1e 100644
> > --- a/drivers/platform/x86/eeepc-laptop.c
> > +++ b/drivers/platform/x86/eeepc-laptop.c
> > @@ -308,13 +308,7 @@ static ssize_t show_sys_acpi(struct device *dev, int cm, char *buf)
> >  	{								\
> >  		return store_sys_acpi(dev, _cm, buf, count);		\
> >  	}								\
> > -	static struct device_attribute dev_attr_##_name = {		\
> > -		.attr = {						\
> > -			.name = __stringify(_name),			\
> > -			.mode = _mode },				\
> > -		.show   = show_##_name,					\
> > -		.store  = store_##_name,				\
> > -	}
> > +	static DEVICE_ATTR(_name, _mode, show_##_name, store_##_name)
> >  
> >  EEEPC_CREATE_DEVICE_ATTR(camera, S_IWUSR | S_IRUGO, CM_ASL_CAMERA);
> >  EEEPC_CREATE_DEVICE_ATTR(cardr, S_IWUSR | S_IRUGO, CM_ASL_CARDREADER);
> > @@ -420,29 +414,10 @@ static ssize_t store_cpufv_disabled(struct device *dev,
> >  }
> >  
> >  
> > -static struct device_attribute dev_attr_cpufv = {
> > -	.attr = {
> > -		.name = "cpufv",
> > -		.mode = S_IWUSR | S_IRUGO },
> > -	.show   = show_cpufv,
> > -	.store  = store_cpufv
> > -};
> > -
> > -static struct device_attribute dev_attr_available_cpufv = {
> > -	.attr = {
> > -		.name = "available_cpufv",
> > -		.mode = S_IRUGO },
> > -	.show   = show_available_cpufv
> > -};
> > -
> > -static struct device_attribute dev_attr_cpufv_disabled = {
> > -	.attr = {
> > -		.name = "cpufv_disabled",
> > -		.mode = S_IWUSR | S_IRUGO},
> > -	.show   = show_cpufv_disabled,
> > -	.store  = store_cpufv_disabled
> > -};
> > -
> > +static DEVICE_ATTR(cpufv, S_IWUSR | S_IRUGO, show_cpufv, store_cpufv);
> 
> DEVICE_ATTR_RW()?
> 
> > +static DEVICE_ATTR(available_cpufv, S_IRUGO, show_available_cpufv, NULL);
> 
> DEVICE_ATTR_RO()?
> 
> > +static DEVICE_ATTR(cpufv_disabled, S_IWUSR | S_IRUGO,
> > +		   show_cpufv_disabled, store_cpufv_disabled);
> 
> DEVICE_ATTR_RW()?

Yes, I could have expected that. v2 will use them across the board.

Thanks,
Frans

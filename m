Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756908AbaIOUBT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 16:01:19 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:42203 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756474AbaIOUBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 16:01:16 -0400
Date: Mon, 15 Sep 2014 22:01:12 +0200
From: Frans Klaver <fransklaver@gmail.com>
To: Darren Hart <dvhart@infradead.org>
Cc: Corentin Chary <corentin.chary@gmail.com>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/13] eeepc-laptop: make disp attribute really write-only
Message-ID: <20140915200112.GB7867@gmail.com>
References: <1410563212-31565-1-git-send-email-fransklaver@gmail.com>
 <1410563212-31565-8-git-send-email-fransklaver@gmail.com>
 <20140915200007.GB62440@vmdeb7>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140915200007.GB62440@vmdeb7>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2014 at 01:00:07PM -0700, Darren Hart wrote:
> On Sat, Sep 13, 2014 at 01:06:46AM +0200, Frans Klaver wrote:
> > The disp attribute is write-only, but sysfs doesn't know this. Currently
> > show_sys_acpi() is mimicking sysfs behavior, if the underlying acpi call
> > should fail. This is not ideal; behaving like sysfs is better left to
> > sysfs.
> > 
> > Introduce EEEPC_CREATE_DEVICE_ATTR_WO() to instantiate a write-only
> > attribute, and declare the disp attribute with it. Sysfs makes sure
> > userspace can only write to disp at all times. This also means we can
> > back to propagating any errors from get_acpi().
> > 
> > Signed-off-by: Frans Klaver <fransklaver@gmail.com>
> > ---
> >  drivers/platform/x86/eeepc-laptop.c | 8 ++++++--
> >  1 file changed, 6 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
> > index 3c04b77..4f6490d 100644
> > --- a/drivers/platform/x86/eeepc-laptop.c
> > +++ b/drivers/platform/x86/eeepc-laptop.c
> > @@ -291,7 +291,7 @@ static ssize_t show_sys_acpi(struct device *dev, int cm, char *buf)
> >  	int value = get_acpi(eeepc, cm);
> >  
> >  	if (value < 0)
> > -		return -EIO;
> > +		return value;
> >  	return sprintf(buf, "%d\n", value);
> >  }
> >  
> > @@ -316,9 +316,13 @@ static ssize_t show_sys_acpi(struct device *dev, int cm, char *buf)
> >  	EEEPC_ACPI_STORE_FUNC(_name, _cm)				\
> >  	static DEVICE_ATTR(_name, _mode, show_##_name, store_##_name)
> >  
> > +#define EEEPC_CREATE_DEVICE_ATTR_WO(_name, _mode, _cm)			\
> > +	EEEPC_ACPI_STORE_FUNC(_name, _cm)				\
> > +	static DEVICE_ATTR(_name, _mode, NULL, store_##_name)
> 
> Per Greg's previous reply, I presume DEVICE_ATTR_WO here?

Yes, already taken care of in all similar cases.

Thanks,
Frans

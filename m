Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752451Ab3CFGTP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 01:19:15 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:13400 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788Ab3CFGTO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 01:19:14 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 05 Mar 2013 22:12:40 -0800
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: "jg1.han@samsung.com" <jg1.han@samsung.com>
CC: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "'Tejun Heo'" <tj@kernel.org>, "'Greg KH'" <greg@kroah.com>,
        "'Alessandro Zummo'" <a.zummo@towertech.it>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>
Date: Wed, 6 Mar 2013 11:48:33 +0530
Subject: RE: [PATCH v3] rtc: add devm_rtc_device_{register,unregister}()
Thread-Topic: [PATCH v3] rtc: add devm_rtc_device_{register,unregister}()
Thread-Index: Ac4aMaaTVvxe8MZBTaW0W/+zFuhrCgAABSdA
Message-ID: <D958900912E20642BCBC71664EFECE3E6E4F721A62@BGMAIL02.nvidia.com>
References: <12429277.417351362550362880.JavaMail.weblogic@epml07>
In-Reply-To: <12429277.417351362550362880.JavaMail.weblogic@epml07>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Jingoo Han [mailto:jg1.han@samsung.com]
> Sent: Wednesday, March 06, 2013 11:43 AM
> To: Venu Byravarasu
> Cc: 'Andrew Morton'; linux-kernel@vger.kernel.org; 'Tejun Heo'; 'Greg KH';
> 'Alessandro Zummo'; rtc-linux@googlegroups.com; Jingoo Han
> Subject: Re: [PATCH v3] rtc: add devm_rtc_device_{register,unregister}()
> 
> On Wednesday, March 06, 2013 3:03 PM, Venu Byravarasu wrote:
> >
> > > --- a/drivers/rtc/class.c
> > > +++ b/drivers/rtc/class.c
> >
> > > +/**
> > > + * devm_rtc_device_register - resource managed rtc_device_register()
> > > + * @name: the name of the device
> > > + * @dev: the device to register
> > > + * @ops: the rtc operations structure
> > > + * @owner: the module owner
> > > + *
> > > + * @return a struct rtc on success, or an ERR_PTR on error
> > > + *
> > > + * Managed rtc_device_register(). The rtc_device returned from this
> > > function
> > > + * are automatically freed on driver detach. See rtc_device_register()
> > > + * for more information.
> > > + */
> > > +
> > > +struct rtc_device *devm_rtc_device_register(const char *name,
> > > +					struct device *dev,
> >
> > As most of devm_* functions use  " struct device *dev" as their first param,
> > why not this function also modified to be in sync with them?
> 
> Yes, but, I want to sync with the form of rtc_device_register().
> This function already uses 'struct device *dev' as second argument as below.
> 

IMO any kernel driver developer using devm_* API, expects struct device* as first argument.
Breaking this policy for one module (RTC here) & making this API special, might not be a good idea.
Anyhow, maintainers may add their comments on this.

Thanks,
Venu

>  struct rtc_device *rtc_device_register(const char *name, struct device *dev,
>                                          const struct rtc_class_ops *ops,
>                                          struct module *owner)
> 
> Best regards,
> Jingoo Han
> 
> >
> > > +					const struct rtc_class_ops *ops,
> > > +					struct module *owner)
> > > +{
> > > +	struct rtc_device **ptr, *rtc;

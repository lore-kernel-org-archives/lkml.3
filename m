Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751124AbaHPEUN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2014 00:20:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46100 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbaHPEUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2014 00:20:11 -0400
Date: Fri, 15 Aug 2014 21:19:18 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Rob Herring <robherring2@gmail.com>
Cc: Stepan Moskovchenko <stepanm@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH v2] of: Deep-copy names of platform devices
Message-ID: <20140816041918.GE14338@kroah.com>
References: <53EAC37C.4020203@codeaurora.org>
 <1407897037-6037-1-git-send-email-stepanm@codeaurora.org>
 <CAL_JsqKoikzLsXmXrm0GDM=+5ofX=OvrmvUTw3O-qX2hSTztcw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL_JsqKoikzLsXmXrm0GDM=+5ofX=OvrmvUTw3O-qX2hSTztcw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 15, 2014 at 11:38:33AM -0500, Rob Herring wrote:
> Adding Greg...
> 
> On Tue, Aug 12, 2014 at 9:30 PM, Stepan Moskovchenko
> <stepanm@codeaurora.org> wrote:
> > When we parse the device tree and allocate platform
> > devices, the 'name' of the newly-created platform_device
> > is set to point to the 'name' field of the 'struct device'
> > embedded within the platform_device. This is dangerous,
> > because the name of the 'struct device' is dynamically
> > allocated. Drivers may call dev_set_name() on the device,
> > which will free and reallocate the name of the device,
> > leaving the 'name' of the platform_device pointing to the
> > now-freed memory.
> >
> > Furthermore, if the dev_set_name() call is made from a
> > driver's probe() function and a subsequent request results
> > in probe deferral, the dangling 'name' reference may lead
> > to the device being re-probed using the wrong driver.
> 
> This seems wrong. I don't think we want drivers to change their own
> device's name. The name is not supposed to change after registration.

That is correct.  Well, you can change a name, using device_rename(),
but that's the only way to do it, not through dev_set_name(), as is
pointed out here, that will cause problems.

So I don't think this patch is needed at all.

thanks,

greg k-h

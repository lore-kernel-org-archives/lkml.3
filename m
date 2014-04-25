Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751812AbaDYOf6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 10:35:58 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:38332 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751199AbaDYOfz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 10:35:55 -0400
Message-ID: <1398436499.4724.250.camel@iivanov-dev>
Subject: Re: [RFC PATCH] mfd: pm8x41: Naive function devices registration
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Josh Cartwright <joshc@codeaurora.org>
Cc: Courtney Cavin <courtney.cavin@sonymobile.com>,
        Rob Herring <robherring2@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>
Date: Fri, 25 Apr 2014 17:34:59 +0300
In-Reply-To: <20140425141551.GL5546@joshc.qualcomm.com>
References: <1398429171-8566-1-git-send-email-iivanov@mm-sol.com>
	 <20140425141551.GL5546@joshc.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.1-2ubuntu2~saucy1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-04-25 at 09:15 -0500, Josh Cartwright wrote:
> On Fri, Apr 25, 2014 at 03:32:51PM +0300, Ivan T. Ivanov wrote:
> > From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> > 
> > Currently functions that exist in both the controller at the
> > same address offset can not be specified with the same names.
> 
> The terminology here is a bit confusing.  When I read "controller", I
> hear "SPMI controller", 

Yes, it is badly worded.

> but this is really not a limitation of the SPMI
> core, but rather a limitation of of_platform_populate() used by this
> particular SPMI slave MFD driver.
> 
> > Adding Unique Slave ID device address to prefix function
> > device names fixes this.
> > 
> > Function devices are SPMI devices, so register them on
> > SPMI bus.
> 
> This is a step backwards.  The PMIC functions are not individually
> addressable SPMI slaves, and as such should not be represented as
> independent devices to the SPMI core.
> 
> They really are subfunctions of a particular SPMI slave, and should be
> modeled as children of that slave device.  With this driver, we've
> chosen to model the child devices as platform devices, but it could
> also be a separate bus type.

I tend to agree. My reasoning was that they are part of the 
device which sits on the SPMI bus, so they should also be part
of this bus.

Regards,
Ivan

> 
>   Josh
> 



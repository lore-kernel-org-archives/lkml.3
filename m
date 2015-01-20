Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532AbbATQaB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 11:30:01 -0500
Received: from mail-ig0-f173.google.com ([209.85.213.173]:38517 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474AbbATQ37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 11:29:59 -0500
Date: Tue, 20 Jan 2015 16:29:52 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Olof Johansson <olof@lixom.net>, Doug Anderson <dianders@chromium.org>,
        Bill Richardson <wfrichar@chromium.org>, Simon Glass <sjg@google.com>,
        Gwendal Grignou <gwendal@google.com>, Jonathan Corbet <corbet@lwn.net>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND v2 5/7] mfd: cros_ec: Instantiate ChromeOS EC
 character device
Message-ID: <20150120162952.GB30656@x1>
References: <1420205572-2640-1-git-send-email-javier.martinez@collabora.co.uk>
 <1420205572-2640-6-git-send-email-javier.martinez@collabora.co.uk>
 <20150120082013.GU21886@x1>
 <54BE7C53.8070605@collabora.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <54BE7C53.8070605@collabora.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Jan 2015, Javier Martinez Canillas wrote:

> Hello Lee,
> 
> Thanks a lot for your feedback.
> 
> On 01/20/2015 09:20 AM, Lee Jones wrote:
> > On Fri, 02 Jan 2015, Javier Martinez Canillas wrote:
> > 
> >> The ChromeOS EC character device is an user-space interface to
> >> allow applications to access the Embedded Controller.
> >> 
> >> Add a cell for this device so it's spawned from the mfd driver.
> >> 
> >> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> >> ---
> >> 
> >> Changes since v1: None, new patch.
> >> 
> >>  drivers/mfd/cros_ec.c | 4 ++++
> >>  1 file changed, 4 insertions(+)
> >> 
> >> diff --git a/drivers/mfd/cros_ec.c b/drivers/mfd/cros_ec.c
> >> index c872e1b..70f9ed5 100644
> >> --- a/drivers/mfd/cros_ec.c
> >> +++ b/drivers/mfd/cros_ec.c
> >> @@ -118,6 +118,10 @@ static const struct mfd_cell cros_devs[] = {
> >>  		.id = 2,
> >>  		.of_compatible = "google,cros-ec-i2c-tunnel",
> >>  	},
> >> +	{
> >> +		.name = "cros-ec-dev",
> > 
> > *-dev is seldom suitable for naming things.
> > 
> > Please be more imaginative/descriptive in your naming.
> >
> 
> You know this is one of the two hard problems in CS ;-)
> 
> But seriously, this is the name used in the downstream ChromiumsOS kernel
> and tbh I don't think is that bad since after all is a character device
> interface to access the Embedded Controller from user-space. So in that
> sense is not worse than the i2c-dev or spidev names but I can try to come
> up with something more creative if that will block the patch to be merged.

It's not a blocker, but it is a ridiculous name to use inside the
driver/ directory 'cos almost everything is a dev(ice) here.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

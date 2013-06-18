Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751165Ab3FREFs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 00:05:48 -0400
Received: from nm17-vm0.access.bullet.mail.sp2.yahoo.com ([98.139.44.168]:30914
	"EHLO nm17-vm0.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750763Ab3FREFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 00:05:47 -0400
X-Yahoo-Newman-Id: 184965.4618.bm@smtp105.sbc.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 8ekVoqIVM1k8NL.M9IP3zgO3l2LGAMVurvX8UOwlbl_hkj0
 yinFHrXU9mPfd_bgSCJNVXEUWbTSHMQVcvW.ybZf7F6JivI6cXayxxd9yeyk
 LuzMYp5kmZ6vHMjVDq95D.yols_HPduPYXx3OrkI4SsS0HlZX_E3FV222UcG
 CxO66_FwcUa4Wf0S__TjnQbEK3mKq.wyY3cGIpoezgJv5TVBVSd8aYKkpJSD
 E81b3g49WBf83.OO3_vKUc89YFPQ9vBmqSSoMSho9nqLFoeexHYg97sRabfz
 .LYuL5TfD0rnM.ETSffmdL79FdGXBGOTVYI_B7_azDcRkxWUtkPv6sy12kFf
 2vYC4L8JPYuauBOoHnnpnnQmMKWMDvgqa_4GwHu.Xs0R7soXdAMl61nB6odn
 lWFjWNXFO2C.401hctK5GExy8O2ZDupe.A2CqV_3YhmucRk5i97uaH6EKHoS
 _V_vJh7aNkO87hTVWUwQ61n3JfS0dk31eEgrPGa5uvUqwKpTQ46YNhEviLCo
 aMYfWsxEsXlPD.qkohGAf7MejeWrqb9d.6LWMhzJA_15r.8nk6RGYhxDzL._
 0jFV1LAHt5iCD68PhL0Xhj60gHpM_B9o-
X-Yahoo-SMTP: zfeO.4KswBCc_PdwTE8HfYDCQ1aNmIcSvQHkDP4uSDBNBSXeKQ--
X-Rocket-Received: from localhost (linux@108.223.40.66 with plain)
        by smtp105.sbc.mail.gq1.yahoo.com with SMTP; 17 Jun 2013 21:05:47 -0700 PDT
Date: Mon, 17 Jun 2013 21:05:47 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Ming Lei <ming.lei@canonical.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        nirinA raseliarison <nirina.raseliarison@gmail.com>,
        linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] firmware loader: fix use-after-free by double abort
Message-ID: <20130618040547.GB12181@roeck-us.net>
References: <1371285398-18566-1-git-send-email-ming.lei@canonical.com>
 <20130617235915.GA19162@kroah.com>
 <CACVXFVNahZpH-FdZ=NJ1HZybDCSuoV2aZM2--gBVMD22FVBJcQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVXFVNahZpH-FdZ=NJ1HZybDCSuoV2aZM2--gBVMD22FVBJcQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 08:33:55AM +0800, Ming Lei wrote:
> On Tue, Jun 18, 2013 at 7:59 AM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > On Sat, Jun 15, 2013 at 04:36:38PM +0800, Ming Lei wrote:
> >> fw_priv->buf is accessed in both request_firmware_load() and
> >> writing to sysfs file of 'loading' context, but not protected
> >> by 'fw_lock' entirely. The patch makes sure that access on
> >> 'fw_priv->buf' is protected by the lock.
> >>
> >> So fixes the double abort problem reported by nirinA raseliarison:
> >>
> >>       http://lkml.org/lkml/2013/6/14/188
> >>
> >> Reported-and-tested-by: nirinA raseliarison <nirina.raseliarison@gmail.com>
> >> Cc: Guenter Roeck <linux@roeck-us.net>
> >> Cc: Bjorn Helgaas <bhelgaas@google.com>
> >> Cc: stable <stable@vger.kernel.org>
> >> Signed-off-by: Ming Lei <ming.lei@canonical.com>
> >
> > So this is a 3.9-stable thing?  Anything newer than that?
> 
> Yes, only 3.9-stable need this.
> 
I may be missing something, but why would mainline not need it ?
Or do you mean "mainline plus 3.9" ?

Thanks,
Guenter

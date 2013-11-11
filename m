Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475Ab3KKOu6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 09:50:58 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:59480 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754218Ab3KKOut (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 09:50:49 -0500
Message-ID: <1384181381.23605.32.camel@iivanov-dev.int.mm-sol.com>
Subject: Re: [PATCH 0/4] usb: chipidea: msm: Clean and fix glue layer driver
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Peter Chen <peter.chen@freescale.com>
Cc: alexander.shishkin@linux.intel.com, gregkh@linuxfoundation.org,
        rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ijc+devicetree@hellion.org.uk,
        davidb@codeaurora.org, linux-usb@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 11 Nov 2013 16:49:41 +0200
In-Reply-To: <20131111140235.GC21746@shlinux1.ap.freescale.net>
References: <1384176937-1658-1-git-send-email-iivanov@mm-sol.com>
	 <20131111140235.GC21746@shlinux1.ap.freescale.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Mon, 2013-11-11 at 22:02 +0800, Peter Chen wrote: 
> On Mon, Nov 11, 2013 at 03:35:33PM +0200, Ivan T. Ivanov wrote:
> > From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> > 
> > Hi, 
> > 
> > This series intend to fixup driver, which was broken for a while. It is 
> > used to create peripheral role device, which in coordination with
> > phy-usb-msm driver (still some cleanups pending) will provide again
> > USB2.0 gadget support for MSM targets.
> > 
> 
> We haven't seen msm chipidea patch for a long time, good news they appear.
> Any plans to use the whole chipidea function for msm controller driver
> (otg, host and peripheral)?
> 

Things are little complicated here :-). Currently qcom,echi-host is
supposed to control host role. Not tested this completely, but this how
is handled also by down stream kernel (codeaurora.org). In this
repo there are even 2 slightly different versions of the driver. 

And OTG and PHY control situations is even ... Currently this
functionality is handled by phy-msm-usb. There is a separate gadget
driver downstream, which seems to be used in production targets. 

My plan is to first port minimal set of changes form downstream kernel
to phy-msm-usb, which will bring up peripheral role. 

Regards,
Ivan


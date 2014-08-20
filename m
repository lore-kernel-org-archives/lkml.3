Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948AbaHTV2u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 17:28:50 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:9613 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752629AbaHTV2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 17:28:48 -0400
Date: Wed, 20 Aug 2014 14:28:44 -0700
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
CC: "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 2/6] pinctrl: Introduce pinctrl driver for Qualcomm
 SSBI PMIC's
Message-ID: <20140820212843.GB16274@sonymobile.com>
References: <1407771634-14946-1-git-send-email-iivanov@mm-sol.com>
 <1407771634-14946-3-git-send-email-iivanov@mm-sol.com>
 <53F456F3.3000309@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <53F456F3.3000309@linaro.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 20 Aug 01:06 PDT 2014, Srinivas Kandagatla wrote:

> Hi Bjorn,
> 

Hi Srinivas,

Thanks for the testing. I'm reworking the driver to incorporate yours, Linus'
and Ivans feedback.

> Two things which I noticed while trying out this driver to drive a reset
> line.
> 
> 1> gpio numbering for pinconf vs gpio are not consistent, they differ by
> an offset of 1.
> 

After scratching my head regarding this I now see that there's a off by one in
most of the gpio functions. I've rewroked this to make more sense now.

The gpio numbers has to start at 1, as all documentation is based on that.

[...]
> 
> 2> Looking back at v3.4 kernel, for gpio modes, BIT(0) of bank 0 is set
> to enable gpio mode. without this bit driver does not work for output pins.
> 

Thanks, I missed that.

Unfortunately, setting that bit results in input not working - the interrupt
bits are never set for gpios that have that bit set. I'm trying to figure out
why this is the case before sending out the new version...

Regards,
Bjorn

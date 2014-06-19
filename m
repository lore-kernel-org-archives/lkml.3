Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757941AbaFSLdO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 07:33:14 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:35346 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757383AbaFSLdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 07:33:11 -0400
Date: Thu, 19 Jun 2014 12:32:59 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Lee Jones <lee.jones@linaro.org>
Cc: Thierry Reding <thierry.reding@gmail.com>, linux-pwm@vger.kernel.org,
        kernel@stlinux.com, devicetree@vger.kernel.org,
        srinivas.kandagatla@gmail.com, patrice.chotard@st.com,
        linux-kernel@vger.kernel.org, ajitpal.singh@st.com,
        linux-arm-kernel@lists.infradead.org, maxime.coquelin@st.com
Subject: Re: [PATCH 6/7] pwm: st: Add new driver for ST's PWM IP
Message-ID: <20140619113259.GO32514@n2100.arm.linux.org.uk>
References: <1403103172-19856-1-git-send-email-lee.jones@linaro.org> <1403103172-19856-6-git-send-email-lee.jones@linaro.org> <20140618231127.GF26514@mithrandir> <20140619084404.GA26560@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140619084404.GA26560@lee--X1>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 09:44:04AM +0100, Lee Jones wrote:
> On Thu, 19 Jun 2014, Thierry Reding wrote:
> > On Wed, Jun 18, 2014 at 03:52:51PM +0100, Lee Jones wrote:
> > > +#include <linux/clk.h>
> > > +#include <linux/math64.h>
> > > +#include <linux/module.h>
> > > +#include <linux/of.h>
> > > +#include <linux/platform_device.h>
> > > +#include <linux/pwm.h>
> > > +#include <linux/regmap.h>
> > > +#include <linux/slab.h>
> > > +#include <linux/mfd/syscon.h>
> > > +#include <linux/time.h>
> > 
> > These should be sorted alphabetically.
> 
> Really? :)

Yes, as a general rule, for two reasons:

- It helps to reduce conflicts when two people add two different header
  files at a later date (provided they don't ignore the sorting and add
  them both at the end of the list.)

- It helps reduce the chance of having the same include listed twice
  (sometimes silently caused at git merge time) since it means if two
  people independently add the same include in the same place in the
  list, git will cope.  Eg, if one adds an include in one random place
  in the list, and someone else adds the same in another random place in
  the list, the result will be two includes of the same file.  If they're
  sufficiently far apart, git will not flag a conflict.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.

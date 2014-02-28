Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751807AbaB1S3S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 13:29:18 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:49641 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746AbaB1S3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 13:29:16 -0500
Date: Fri, 28 Feb 2014 10:29:15 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
To: Josh Cartwright <joshc@codeaurora.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-input@vger.kernel.org
Subject: Re: [PATCH v4 4/9] Input: pmic8xxx-keypad - Migrate to DT
Message-ID: <20140228182915.GD2487@codeaurora.org>
References: <1393552520-9068-1-git-send-email-sboyd@codeaurora.org>
 <1393552520-9068-5-git-send-email-sboyd@codeaurora.org>
 <20140228034138.GD7308@joshc.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140228034138.GD7308@joshc.qualcomm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27, Josh Cartwright wrote:
> Looks good, with the exception of one thing...
> 
> On Thu, Feb 27, 2014 at 05:55:15PM -0800, Stephen Boyd wrote:
> > The driver is only supported on DT enabled platforms. Convert the
> > driver to DT so that it can probe properly.
> > 
> > Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> > ---
> >  drivers/input/keyboard/pmic8xxx-keypad.c | 150 ++++++++++++++++++-------------
> > @@ -471,50 +514,27 @@ static void pmic8xxx_kp_close(struct input_dev *dev)
> >   */
> >  static int pmic8xxx_kp_probe(struct platform_device *pdev)
> >  {
> [..]
> > -	keymap_data = pdata->keymap_data;
> > -	if (!keymap_data) {
> > -		dev_err(&pdev->dev, "no keymap data supplied\n");
> > -		return -EINVAL;
> > -	}
> > +	repeat = !of_property_read_bool(pdev->dev.of_node,
> > +					"linux,input-no-autorepeat");
> > +	wakeup = !of_property_read_bool(pdev->dev.of_node,
> > +					"linux,keypad-wakeup");
> 
> I don't think you mean to invert this.
> 

Good catch. Thanks.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

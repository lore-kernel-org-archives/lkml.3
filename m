Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527AbaJTKfS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 06:35:18 -0400
Received: from down.free-electrons.com ([37.187.137.238]:48478 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752950AbaJTKfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 06:35:16 -0400
X-Greylist: delayed 332 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Oct 2014 06:35:15 EDT
Date: Mon, 20 Oct 2014 12:29:39 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Vladimir Zapolskiy <vz@mleia.com>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>, jonsmirl@gmail.com,
        Simon <longsleep@gmail.com>, linux-pwm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv8 1/2] pwm: Add Allwinner SoC support
Message-ID: <20141020102939.GB10616@piout.net>
References: <1413743305-1979-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1413743305-1979-2-git-send-email-alexandre.belloni@free-electrons.com>
 <54442BB1.1080403@mleia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54442BB1.1080403@mleia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 20/10/2014 at 00:22:57 +0300, Vladimir Zapolskiy wrote :
> > +struct sun4i_pwm_chip {
> > +	struct pwm_chip chip;
> > +	struct clk *clk;
> > +	void __iomem *base;
> > +	struct mutex ctrl_lock;
> 
> why do you use mutex? I haven't found any blocking subcalls under
> protection, a spinlock seems to fit better here.
> 

A mutex here will do the right thing. The lock is never taken in
interrupt context and a mutex is spinning for a few cycles before
putting the thread to sleep. I'm not sure why you feel a spinlock would
be better here.

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

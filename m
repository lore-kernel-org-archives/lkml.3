Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751257AbaKYQWC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 11:22:02 -0500
Received: from vps0.lunn.ch ([178.209.37.122]:39188 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751045AbaKYQWA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 11:22:00 -0500
Date: Tue, 25 Nov 2014 17:21:21 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: Grant Likely <grant.likely@linaro.org>
Cc: Andrew Lunn <andrew@lunn.ch>, Leif Lindholm <leif.lindholm@linaro.org>,
        mark.rutland@arm.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, robh+dt@kernel.org, ijc@debian.org,
        plagnioj@jcrosoft.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] of: support passing console options with stdout-path
Message-ID: <20141125162121.GC3443@lunn.ch>
References: <1416867838-18652-1-git-send-email-leif.lindholm@linaro.org>
 <20141124230016.GP20238@lunn.ch>
 <20141125144439.07212C44343@trevor.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141125144439.07212C44343@trevor.secretlab.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > More worrying, barebox does not support the : either. So there is a
> > danger your bootloader suddenly goes silent after a dt blob update.
> 
> Is barebox parsing the property? Or updating it? Or both? I've got no
> problem with this patch, but we can also support things like the
> 'current-speed' property in the UART to set a default when the stdout
> path doesn't have any arguments.

Hi Grant

I'm no export with barebox. So i just grep'ed the code.

It parses the property. Also as with linux, of_find_node_by_path()
does not stop at : as you say it should.

There is one case of the property being updated, but that is only for
the PPC mpc85xx.

Barebox does not appear to use 'current-speed' at all.

	Andrew

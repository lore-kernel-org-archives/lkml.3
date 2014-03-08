Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751878AbaCHMAA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 07:00:00 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:43037 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751130AbaCHL76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 06:59:58 -0500
Date: Sat, 8 Mar 2014 11:59:48 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Grant Likely <grant.likely@linaro.org>
Cc: Jean-Jacques Hiblot <jjhiblot@traphandler.com>, gregkh@linuxfoundation.org,
        robh+dt@kernel.org, gregory.clement@free-electrons.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] dt: platform driver: Fill the resources before
	probe and defer if needed
Message-ID: <20140308115948.GX21483@n2100.arm.linux.org.uk>
References: <20140220153042.DF053C4050F@trevor.secretlab.ca> <1392988720-20976-1-git-send-email-jjhiblot@traphandler.com> <20140308073758.DA63FC408EC@trevor.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140308073758.DA63FC408EC@trevor.secretlab.ca>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 08, 2014 at 07:37:58AM +0000, Grant Likely wrote:
> I believe we already talked about the above test. This function must
> only process devices created by of_platform_populate(). Merely checking
> the of_node pointer is not a sufficient test because there are other
> paths in the kernel for creating platform_devices that might get a node
> pointer attached to it.

There definitely are: there are a number of platform device drivers
which create a new platform device structure, and copy the of_node
pointer across.

However, that's really sick code, and can result in the platform device
driver probing the device it just created... this practise should be
outlawed.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932790AbaHYNeR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 09:34:17 -0400
Received: from jdl.com ([208.123.74.7]:42353 "EHLO jdl.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755778AbaHYNeM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 09:34:12 -0400
X-Greylist: delayed 1492 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Aug 2014 09:34:12 EDT
Message-Id: <E1XLu15-0002DP-6o@jdl.com>
To: Thierry Reding <thierry.reding@gmail.com>
cc: Mark Rutland <mark.rutland@arm.com>,
        Alexander Holler <holler@ahsoftware.de>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh+dt@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 0/9] dt: dependencies (for deterministic driver initialization order based on the DT)
In-reply-to: <20140825093931.GB2399@ulmo>
References: <1399913280-6915-1-git-send-email-holler@ahsoftware.de> <20140514141914.446F7C4153D@trevor.secretlab.ca> <20140821140211.GD19293@ulmo.nvidia.com> <53F64624.5000403@ahsoftware.de> <20140822131919.GX21734@leverpostej> <20140825093931.GB2399@ulmo>
Comments: In-reply-to Thierry Reding <thierry.reding@gmail.com>
   message dated "Mon, 25 Aug 2014 11:39:32 +0200."
Date: Mon, 25 Aug 2014 08:08:59 -0500
From: Jon Loeliger <jdl@jdl.com>
X-Spam-Score: 0.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 

> Anyway, instead of going back and forth between "deferred probe is good"
> and "deferred probe is bad", how about we do something useful now and
> concentrate on how to make use of the information we have in DT with the
> goal to reduce the number of cases where deferred probing is required?

Good idea.

The proposal on the table is to allow the probe code
to make a topological sort of the devices based on
dependency information either implied, explicitly stated
or both.  That is likely a fundamentally correct approach.

I believe some of the issues that need to be resolved are:

    1) What constitutes a dependency?
    2) How is that dependency expressed?
    3) How do we add missing dependencies?
    4) Backward compatability problems.

There are other questions, of course.  Is it a topsort
per bus?  Are there required "early devices"?  Should
the inter-node dependencies be expressed at each node,
or in a separate hierarchy within the DTS?  Others.

HTH,
jdl

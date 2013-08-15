Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755861Ab3HOMqM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 08:46:12 -0400
Received: from mail-qe0-f43.google.com ([209.85.128.43]:53661 "EHLO
	mail-qe0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754353Ab3HOMqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 08:46:10 -0400
MIME-Version: 1.0
In-Reply-To: <1376564133-11286-1-git-send-email-b29396@freescale.com>
References: <1376564133-11286-1-git-send-email-b29396@freescale.com>
From: Grant Likely <grant.likely@linaro.org>
Date: Thu, 15 Aug 2013 13:45:48 +0100
X-Google-Sender-Auth: Go40PhvTMS-8oMBfI7B86Sj-9uc
Message-ID: <CACxGe6tMm=u1jFKUQ59+cj-rYkLLAZUqMhsXamyi-wwpWaOGvw@mail.gmail.com>
Subject: Re: [PATCH 0/3] of: add update device node status via cmdline feature
To: Dong Aisheng <b29396@freescale.com>
Cc: devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 15, 2013 at 11:55 AM, Dong Aisheng <b29396@freescale.com> wrote:
> We meet some boards having a lot of pin conflicts between different devices,
> only one of them can be enabled to run at one time.
>
> e.g. imx6q sabreauto board, i2c, spi, weim, flexcan, uart and etc involved
> with pin conflict.
>
> Instead of changing dts manually or adding a lot dts files according to
> different device availability, we provide feature to dynamically update the
> device node status via command line, then those devices involved with
> pin conflict can be enabled or disabled dynamically.

Ugh, no. If there are dynamic conflicts, then the driver really should
be responsible for handling them. ie. if the driver isn't able to get
the resource it needs because they don't exist, then driver probe
should fail.

Except in very excpetional circumstances (ie. firmware workarounds)
the kernel needs to treat the device tree as immutable*. The tree
passed in at boot should not be manipulated at runtime.

* There are powerpc platforms that modify the FDT at runtime; but in
those cases it is in response to firmware changing the data, not the
kernel.

g.

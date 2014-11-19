Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754438AbaKSCwp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 21:52:45 -0500
Received: from gate.crashing.org ([63.228.1.57]:57541 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753801AbaKSCwn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 21:52:43 -0500
Message-ID: <1416364544.5704.23.camel@kernel.crashing.org>
Subject: Re: [PATCH] drivers/core/of: Add symlink to device-tree from
 devices with an OF node
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Jeremy Kerr <jeremy.kerr@au1.ibm.com>
Cc: Rob Herring <robherring2@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@linaro.org>,
        Greg KH <gregkh@linuxfoundation.org>
Date: Wed, 19 Nov 2014 13:35:44 +1100
In-Reply-To: <546BD8BD.2010605@au1.ibm.com>
References: <1415342031.4925.27.camel@kernel.crashing.org>
	 <1415342117.4925.29.camel@kernel.crashing.org>
	 <1415596626.5769.14.camel@kernel.crashing.org>
	 <CAL_JsqKG=vpeGKj3v-2VW9oGQsnmuYMHRfy6LuXDXE=ROjHT4w@mail.gmail.com>
	 <1415841047.5124.62.camel@kernel.crashing.org>
	 <CAL_Jsq+YyfMWxiOFv4x3g5hZJH0XRqCKj2He1XO9eyXWjHTMrg@mail.gmail.com>
	 <546BD8BD.2010605@au1.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-11-19 at 10:39 +1100, Jeremy Kerr wrote:
> Hi Rob,
> 
> >> diff --git a/drivers/base/core.c b/drivers/base/core.c
> >> index 20da3ad..8c7b607 100644
> >> --- a/drivers/base/core.c
> >> +++ b/drivers/base/core.c
> >> @@ -493,6 +493,15 @@ static int device_add_attrs(struct device *dev)
> >>                         goto err_remove_dev_groups;
> >>         }
> >>
> >> +#ifdef CONFIG_OF
> >> +       if (dev->of_node) {
> > 
> > if (IS_ENABLED(CONFIG_OF) && dev->of_node)
> 
> struct device doesn't have an of_node member if !CONFIG_OF, so we'll
> need to disable this block in the preprocessor.

Actually that's no longer the case since 2.6.39 afaik :-)

Cheers,
Ben.



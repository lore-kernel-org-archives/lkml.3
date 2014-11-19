Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833AbaKSIie (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 03:38:34 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:63897 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbaKSIid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 03:38:33 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Jeremy Kerr <jeremy.kerr@au1.ibm.com>, Rob Herring <robherring2@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@linaro.org>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] drivers/core/of: Add symlink to device-tree from devices with an OF node
Date: Wed, 19 Nov 2014 09:38:13 +0100
Message-ID: <3422452.OFUjscQXRB@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1416364544.5704.23.camel@kernel.crashing.org>
References: <1415342031.4925.27.camel@kernel.crashing.org> <546BD8BD.2010605@au1.ibm.com> <1416364544.5704.23.camel@kernel.crashing.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:XMTM68TDGK6tp3A3eZZTKq71qWOYssXY9wxnxo4p7XI
 md+KkH9JLe1ahCy8qEIn3dcx6rNqstgkKKwlcelJ1pL8ev0KgZ
 j2ofgCLsHCDKS+pnya6XDNskiupKngNdgSbwdKCMiyphlGc3L3
 B/x1GAXxDNVPI+rQkGHOr7a865/lUcc3zSiv0wUgY1x3wjmu6F
 oU0RbzdCzYhnCQJWhqAVnpJGw/JviVvzS0BIYohJKmRKHXC3OX
 zIFwIfr5kZD62yRSp23t6zvuCqKTdzZBco8ygLv0AhfaQlF0fv
 Spwhl7z66lYh95qpUbKPrFIF4kztIw1PiioKM3CWZPYivp8FLi
 8yby6nwAsd6JWwUjd6a4=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 November 2014 13:35:44 Benjamin Herrenschmidt wrote:
> On Wed, 2014-11-19 at 10:39 +1100, Jeremy Kerr wrote:
> > Hi Rob,
> > 
> > >> diff --git a/drivers/base/core.c b/drivers/base/core.c
> > >> index 20da3ad..8c7b607 100644
> > >> --- a/drivers/base/core.c
> > >> +++ b/drivers/base/core.c
> > >> @@ -493,6 +493,15 @@ static int device_add_attrs(struct device *dev)
> > >>                         goto err_remove_dev_groups;
> > >>         }
> > >>
> > >> +#ifdef CONFIG_OF
> > >> +       if (dev->of_node) {
> > > 
> > > if (IS_ENABLED(CONFIG_OF) && dev->of_node)
> > 
> > struct device doesn't have an of_node member if !CONFIG_OF, so we'll
> > need to disable this block in the preprocessor.
> 
> Actually that's no longer the case since 2.6.39 afaik 

I wonder if we should create a small helper for this, like

static inline struct device_node *dev_of_node(struct device *of_node)
{
	if (!IS_ENABLED(CONFIG_OF))
		return NULL;

	return dev->of_node;
}

Adding the IS_ENABLED() in a lot of drivers isn't horrible, but we seem
to be doing it a lot.

	Arnd

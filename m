Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382AbaLDJNI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 04:13:08 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:54207 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123AbaLDJNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 04:13:05 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Pankaj Dubey <pankaj.dubey@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, kgene.kim@samsung.com,
        linux@arm.linux.org.uk, heiko@sntech.de,
        Linus Walleij <linus.walleij@linaro.org>, tomasz.figa@gmail.com,
        Rob Herring <robh+dt@kernel.org>, thomas.ab@samsung.com,
        Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v4 1/2] soc: samsung: add exynos chipid driver support
Date: Thu, 04 Dec 2014 10:12:24 +0100
Message-ID: <4074205.TGQpWxTihh@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <547FEA74.1010900@samsung.com>
References: <1417594658-2931-1-git-send-email-pankaj.dubey@samsung.com> <19026872.NZqUJn3Abb@wuerfel> <547FEA74.1010900@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:rr5gBLzwwV3yGBqF5OoyNuALWUFmWobuEqe/23Au+ly
 +NOIJw30bQsh3GVqvBWeBRJ0uhWPUcJAqr7/BRBGag46ffsynX
 MIyf89RBukN7E2X6dK3mDBeFXe/OeImkZy+ANhWVfgacORpdHM
 pbVNb5X7wkibAGcOtg79gjtpJs2E2m8SPzFqb9t5gIpM8tsn7+
 vehy4B0XJU2a8iXXUaoc0O1t8gu2364Y2Ox+FTg+wawW1/6jEj
 iCmIK+qN9VXKf2rUuyQHY/aS/3saxoOffLTMMiPM/DDjP4BV6I
 IY+d/F2J2De9qEbj4k2klu/9aUSKCyBCQwuD6knW9m3vnQVnN6
 AB0eA/L6DHnV3/5Yh6zk=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 December 2014 10:30:36 Pankaj Dubey wrote:
> >
> > On Wednesday 03 December 2014 13:47:37 Pankaj Dubey wrote:
> >
> >> +       soc_dev_attr->soc_id = exynos_product_id_to_name(soc_product_id);
> >> +
> >> +       soc_dev = soc_device_register(soc_dev_attr);
> >> +       if (IS_ERR(soc_dev))
> >> +               goto free_rev;
> >> +
> >> +       device_create_file(soc_device_to_device(soc_dev), &exynos_product_attr);
> >> +       device_create_file(soc_device_to_device(soc_dev),
> >> +                               &exynos_main_rev_attr);
> >> +       device_create_file(soc_device_to_device(soc_dev), &exynos_sub_rev_attr);
> >> +
> >
> > I don't like the idea of having three extra nonstandard properties here,
> > especially when you are not using the machine field for anything useful.
> >
> 
> I did not get you here. Any suggestions how we can use 'machine' field 
> more useful way.

For instance you could pass the exynos_product_id_to_name() result to
the machine field instead of the soc_id field, and use the soc_id
for a more fine-grained distinction.

> > Also, all three of these just come from the same register, why expose
> > them all as the machine and revision standard properties.
> >
> 
> Agreed. These properties are basically giving same information but with 
> small modification.
> As you said these are getting exposed via standard properties as well, 
> so I have no issue to drop them. Just waiting for more review from 
> Samsung folks, will take care of this in next version.

Ok.

	Arnd

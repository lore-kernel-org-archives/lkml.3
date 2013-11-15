Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453Ab3KON4k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 08:56:40 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:50203 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626Ab3KON4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 08:56:30 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Marek Belisko <marek@goldelico.com>
Subject: Re: [PATCH 2/3] misc: bmp085: Add DT bindings for EOC gpio line and direct irq.
Date: Fri, 15 Nov 2013 14:56:19 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: gregkh@linuxfoundation.org, neilb@suse.de, hns@goldelico.com,
        rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ijc+devicetree@hellion.org.uk, rob@landley.net,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1384465609-26485-1-git-send-email-marek@goldelico.com> <1384465609-26485-3-git-send-email-marek@goldelico.com>
In-Reply-To: <1384465609-26485-3-git-send-email-marek@goldelico.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201311151456.19585.arnd@arndb.de>
X-Provags-ID: V02:K0:HPXZm+L8tE6fS/PdaPzLcqMz4C27+xrCJPMpNoKM7Hy
 kppCPu1fqQlADnnR2ayxtOCoL7jkp0RZeT81qHQR1leZpSzwiL
 Rir225M5UHZOndB6SyJ6vBG/2U0B43KpvS6akeGGy/LyLLtxJy
 CASWNv2aex6J0Ql0ViNdNIn524kGKw7SIJ7M+skD+YbCyrCWrN
 rhmGST3wM8E7GIXrJJxjbvc6eE/BwSjfd8XudRSIOkYjUGNu80
 +5qOHMk+zOdiUfdYeUr8meRWedtZaARqG2tq69fYWLUI5lAvs6
 lvgpQA7l5RZ9VRTCzkFPsr8tPImjRYgA5RLwDs5PlAWeqKEduv
 E3gj9eDlZt9VsiwzAnL8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 November 2013, Marek Belisko wrote:
> +       if (node && !pdata) {
> +               pdata = devm_kzalloc(dev, sizeof(struct bmp085_platform_data),
> +                                       GFP_KERNEL);
> +               if (!pdata)
> +                       return -ENOMEM;
> +       }
> +

I generally recommend against allocating platform data from inside the driver,
as this requires more code and more memory than just adding fields to the
driver-specific data structure and copying over the fields from either
DT or the supplied platform data, depending on which one is used.

	Arnd

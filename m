Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932122Ab3BSB6o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 20:58:44 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:56812 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757872Ab3BSB6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 20:58:43 -0500
MIME-Version: 1.0
X-Originating-IP: [114.39.104.37]
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F792729F1@DQHE02.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998F792729F1@DQHE02.ent.ti.com>
Date: Tue, 19 Feb 2013 09:58:42 +0800
Message-ID: <CAFRkauD-S3hxLJLDmpte4cduKL53F=XDrU1pkBER6C1xVyxG=w@mail.gmail.com>
Subject: Re: [PATCH v3 1/4] regulator: core: support shared enable GPIO concept
From: Axel Lin <axel.lin@ingics.com>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +                       if (pin->request_count <= 1) {
> +                               pin->request_count = 0;
> +                               gpio_free(pin->gpio);
> +                               list_del(&pin->list);
> +                               kfree(pin);
> +                       } else {
> +                               pin->request_count--;
> +                       }

How about change above lines to this:

if (--pin->request_count == 0) {
        gpio_free(pin->gpio);
        list_del(&pin->list);
        kfree(pin);
}

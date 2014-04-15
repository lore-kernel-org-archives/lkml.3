Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751242AbaDOWUH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 18:20:07 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49808 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829AbaDOWUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 18:20:05 -0400
Date: Wed, 16 Apr 2014 00:20:01 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Zhu, Lejun" <lejun.zhu@linux.intel.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        yu-sheng Chen <verylong2@gmail.com>
Subject: Re: Fwd: Re: [PATCH v2] input: misc: Add driver for Intel Bay
 Trail GPIO buttons
Message-ID: <20140415222001.GA2431@amd.pavel.ucw.cz>
References: <5338D095.6020200@linux.intel.com>
 <5338D410.9060406@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5338D410.9060406@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
> 
> Input: misc - Add driver for Intel Bay Trail GPIO buttons
> 
> From: Lejun Zhu <lejun.zhu@linux.intel.com>
> 
> This patch adds support for the GPIO buttons on some Intel Bay Trail
> tablets originally running Windows 8. The ACPI description of these
> buttons follows "Windows ACPI Design Guide for SoC Platforms".

Hmm. Is it time for x86 to adopt device tree? Because this is 200
lines of C code which should really have been 10 lines of .dts...

> +
> +/*
> + * Some of the buttons like volume up/down are auto repeat, while others
> + * are not. To support both, we register two platform devices, and put
> + * buttons into them based on whether the key should be auto repeat.
> + */
> +#define BUTTON_TYPES	2
> +
> +struct soc_button_data {
> +	struct platform_device *children[BUTTON_TYPES];
> +};

Would it be possible to extend device description so that this hack is
not needed?
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

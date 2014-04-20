Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574AbaDTT6x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 15:58:53 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:53429 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755463AbaDTT6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 15:58:50 -0400
Date: Sun, 20 Apr 2014 12:58:46 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Zhu, Lejun" <lejun.zhu@linux.intel.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        yu-sheng Chen <verylong2@gmail.com>
Subject: Re: Fwd: Re: [PATCH v2] input: misc: Add driver for Intel Bay Trail
 GPIO buttons
Message-ID: <20140420195846.GI12454@core.coreip.homeip.net>
References: <5338D095.6020200@linux.intel.com>
 <5338D410.9060406@linux.intel.com>
 <20140415222001.GA2431@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140415222001.GA2431@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2014 at 12:20:01AM +0200, Pavel Machek wrote:
> Hi!
> > 
> > Input: misc - Add driver for Intel Bay Trail GPIO buttons
> > 
> > From: Lejun Zhu <lejun.zhu@linux.intel.com>
> > 
> > This patch adds support for the GPIO buttons on some Intel Bay Trail
> > tablets originally running Windows 8. The ACPI description of these
> > buttons follows "Windows ACPI Design Guide for SoC Platforms".
> 
> Hmm. Is it time for x86 to adopt device tree? Because this is 200
> lines of C code which should really have been 10 lines of .dts...
> 
> > +
> > +/*
> > + * Some of the buttons like volume up/down are auto repeat, while others
> > + * are not. To support both, we register two platform devices, and put
> > + * buttons into them based on whether the key should be auto repeat.
> > + */
> > +#define BUTTON_TYPES	2
> > +
> > +struct soc_button_data {
> > +	struct platform_device *children[BUTTON_TYPES];
> > +};
> 
> Would it be possible to extend device description so that this hack is
> not needed?

It would be not that easy as that would mean we need to control
autorepeat (and thus control repeat delay/repeat rate and also report
them) on a per-key basis.

Having 2 separate devices, one offering autorepeat and another not using
it, is much simpler.

Thanks.

-- 
Dmitry

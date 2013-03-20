Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933448Ab3CTQ3D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 12:29:03 -0400
Received: from mail-da0-f64.google.com ([209.85.210.64]:57598 "EHLO
	mail-da0-f64.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932536Ab3CTQ3A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 12:29:00 -0400
X-Greylist: delayed 4023 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Mar 2013 12:29:00 EDT
Path: glegroupsg2000goo.googlegroups.com!not-for-mail
Newsgroups: fa.linux.kernel
Date: Wed, 20 Mar 2013 06:55:35 -0700 (PDT)
In-Reply-To: <fa.XCuSmq9Zwp3+wqFO8NEjpwADVZ0@ifi.uio.no>
Complaints-To: groups-abuse@google.com
Injection-Info: glegroupsg2000goo.googlegroups.com; posting-host=81.89.61.168; posting-account=Wir-NgoAAAD3fHt5R_IArUNeDZQuo489
NNTP-Posting-Host: 81.89.61.168
References: <fa.WZVD0OA/Ooajh6BejiLf7TwBsJ8@ifi.uio.no> <fa.iIqrS6k+Vb5mLqAeL7iTsNsbKyo@ifi.uio.no>
 <fa.L0b41q+fYFZG0WOFTGKLhn/cGPA@ifi.uio.no> <fa.XCuSmq9Zwp3+wqFO8NEjpwADVZ0@ifi.uio.no>
User-Agent: G2/1.0
X-Google-Web-Client: true
X-Google-IP: 81.89.61.168
MIME-Version: 1.0
Message-ID: <6e120226-8a3c-415f-90f2-c44e7b6bbf96@googlegroups.com>
Subject: Re: [PATCH v3] clk: add si5351 i2c common clock driver
From: michal.bachraty@gmail.com
To: fa.linux.kernel@googlegroups.com
Cc: Mike Turquette <mturquette@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Dom Cobley <popcornmix@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Rabeeh Khoury <rabeeh@solid-run.com>, Daniel Mack <zonque@gmail.com>,
        Jean-Francois Moine <moinejf@free.fr>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sebastian,

Thanks for writing this driver!
I have tested your si5351 clock driver and his tuning capabilities. It works well, it generates proper clock frequency, but when new frequency is generated, little clock gap (1ms) is generated. Si5351 datasheet and WP claims, clock tuning can be without gaps - http://www.silabs.com/Support%20Documents/TechnicalDocs/Si5350-51-Frequency-Shifting-WP.pdf
I made some tests with Si5351A chip and I found that when tuning touch only Multisynth registers, it can tune without gaps. There is no need for soft PLL reset. I found also, accessing Multisynth registers is not atomic, so there can be another frequency at output, while not all registers are written. Writing only to one register seems to be atomic.
I'm using this chip for master audio clock frequency generator and tuning about +-50ppm. The question is, if driver you made has capability for tuning without gaps in +-50pmm (or any other) range with about 1ppm step and if not, it is possible to add this functionality? 

Thanks,

Michal

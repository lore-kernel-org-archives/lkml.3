Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932530Ab3LDN5p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 08:57:45 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:55361 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932515Ab3LDN5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 08:57:42 -0500
Message-ID: <529F34D3.5080806@linaro.org>
Date: Wed, 04 Dec 2013 07:57:39 -0600
From: Alex Elder <alex.elder@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: Christian Daudt <bcm@fixthebug.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Mike Turquette <mturquette@linaro.org>,
        "bcm-kernel-feedback-list@broadcom.com" 
	<bcm-kernel-feedback-list@broadcom.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] clk: bcm281xx: add initial clock framework support
References: <529EA78E.7060904@linaro.org> <529EA80F.3050009@linaro.org> <20131204111457.GF16025@e106331-lin.cambridge.arm.com> <529F28E3.90905@linaro.org>
In-Reply-To: <529F28E3.90905@linaro.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/2013 07:06 AM, Alex Elder wrote:
>>> +       name_size = strlen(node->name) + 1;
>>> >> +       ccu = kzalloc(sizeof(*ccu) + name_size, GFP_KERNEL);
>>> >> +       if (!ccu) {
>>> >> +               pr_err("%s: unable to map allocate CCU struct for %s\n",
>>> >> +                       __func__, node->name);
>>> >> +               return;
>>> >> +       }
>>> >> +       memcpy((char *)ccu->name, node->name, name_size);
>> > 
>> > You could simplify this with kstrdup.
> You are correct, and I will make that change.  I think at
> one point I needed the length but that doesn't appear to
> be the case here.

On second thought, no, you may have missed what was happening here.
I was avoiding two kmallocs() by setting aside space at the end
of the structure to hold its name.  It may seem silly, but this
avoids a possible (well, conceivable) failure case.

However, based on your earlier question about "what about freeing
ccu->name?" I am going to use kstrdup() here.  I'd rather the code
put you at ease than look weird just to avoid an unlikely failure.

					-Alex


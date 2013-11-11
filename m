Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814Ab3KKQyZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 11:54:25 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:64489 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753984Ab3KKQyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 11:54:17 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19gZNaTml1NvCA7QzQYIHBg
Date: Mon, 11 Nov 2013 08:54:04 -0800
From: Tony Lindgren <tony@atomide.com>
To: "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Belisko Marek <marek.belisko@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-fbdev@vger.kernel.org,
        NeilBrown <neilb@suse.de>, Marek Belisko <marek@goldelico.com>
Subject: Re: [PATCH 0/3] omapdss: venc: Add support for bypass and acbias.
Message-ID: <20131111165404.GO15154@atomide.com>
References: <1381784555-18344-1-git-send-email-marek@goldelico.com>
 <CAAfyv34j+YhEjtHyf7zg5oBoCV5ROEXow8VV0PQNHLTF5uDZJg@mail.gmail.com>
 <5280DBA6.50303@ti.com>
 <FB10035C-B13C-4A03-BE9C-0576806F2577@goldelico.com>
 <5280E617.3000004@ti.com>
 <F97741D2-FC6F-4DBD-A0DD-E35304501993@goldelico.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F97741D2-FC6F-4DBD-A0DD-E35304501993@goldelico.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Dr. H. Nikolaus Schaller <hns@goldelico.com> [131111 06:30]:
> Am 11.11.2013 um 15:13 schrieb Tomi Valkeinen:
> > On 2013-11-11 15:57, Dr. H. Nikolaus Schaller wrote:
> >
> > The display.c file is not strictly DSS stuff, but DSS related "glue" for
> > the SoC. For example, the muxing of the DSI pads is also done on the
> > CONTROL module, and it's also in display.c.
> > 
> > The file is getting a bit large, so I'm not against splitting it. But I
> > don't think there's point to add omap3-tvout.c file, which most likely
> > will ever contain only that one function.
> 
> Yes that is very likely true.
> 
> The problem is that there is no other official API to modify the DEFCONF1
> register. Therefore we introduced this (propsal).
> 
> Our first idea was a readDEFCONF1() and writeDEFCONF1() and use the
> constants (bit patterns) you suggested below.

I posted something about accessing the ctrl module regs to the first
patch in the series. It's best to set it up as a separate driver for
now and then maybe handle it with pinctrl-single,bits when DSS is
device tree enabled.

Regards,

Tony

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171AbaFPHci (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 03:32:38 -0400
Received: from gate.crashing.org ([63.228.1.57]:38763 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753992AbaFPHch (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 03:32:37 -0400
Message-ID: <1402903937.7661.33.camel@pasglop>
Subject: Re: [PATCH] offb: Fix little-endian support
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: Cedric Le Goater <clg@fr.ibm.com>, Dinar Valeev <dvaleev@suse.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 16 Jun 2014 17:32:17 +1000
In-Reply-To: <s5h8uq4qm3h.wl%tiwai@suse.de>
References: <1400073709-15012-1-git-send-email-tiwai@suse.de>
	 <5373772D.9060807@fr.ibm.com> <s5hha4sh20d.wl%tiwai@suse.de>
	 <5373A200.6080301@fr.ibm.com> <s5h8uq4qm3h.wl%tiwai@suse.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2014-05-14 at 19:57 +0200, Takashi Iwai wrote:
> 
> Hm, so it actually regressed on BE?
> 
> It's strange because fb_math_be() should be true and the patch won't
> change the values in that case...

Shouldn't the patch be based on foreign endian being set rather than
just "be" anyway ?

IE. If the fb is LE and the host is LE we *also* don't want to change
the ordering, which will be the case when we fix qemu...

Cheers,
Ben.




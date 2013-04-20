Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754946Ab3DTKiP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Apr 2013 06:38:15 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:57650 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754822Ab3DTKiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Apr 2013 06:38:13 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Lars-Peter Clausen" <lars@metafoo.de>
Subject: Re: [PATCH 2/2] dma:of: Use a mutex to protect the of_dma_list
Date: Sat, 20 Apr 2013 12:38:08 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: Jon Hunter <jon-hunter@ti.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org
References: <1366364534-3298-1-git-send-email-lars@metafoo.de> <5171C8F6.6010702@ti.com> <51724393.1060608@metafoo.de>
In-Reply-To: <51724393.1060608@metafoo.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304201238.08908.arnd@arndb.de>
X-Provags-ID: V02:K0:jIBmf3GUQE4KMGEWzoh0jshxIlycuUigH49UhGXgctd
 eMLdIQqccqsuIbi2YEtm9OjggUSLB2wk1QL98K/ARQPOby/Wlf
 2vqn5x5+IvRjFrXFeUmK18w5DdRyRaJ2Il+thh9wXN2JUQhi4e
 IRJD5fApuDIT2505h6QgXCmWPE2U+jRPDOVUUpG5xlGdooIzxd
 DZBwtSgbeDU5GYgqW+HDeLL3DgDr0htuxDrvPM60l2DTl9G0Yf
 Aiaoe+Oc1KrLcvFwaUi50Q086qft/NJsoG8uUOvJxKeSK20U9A
 keXsTLP/g1w585NTsdXP0Us8OHSHyECG/udQW3HrabZiAh/9AM
 MaZPEH2FWKCbjdFG59T0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 20 April 2013, Lars-Peter Clausen wrote:
> On 04/20/2013 12:45 AM, Jon Hunter wrote:
> > I think that there is a problem here. For controllers using the
> > of_dma_simple_xlate(), this will call dma_request_channel() which also
> > uses a mutex.
> 
> That would only be a problem if it'd use the same mutex. Holding two mutexes at
> the same time is not a problem per se.
> 

I guess Jon originlly tried it with a spinlock as the outer lock, which indeed
does not work, but the new version does not have this problem.

	Arnd

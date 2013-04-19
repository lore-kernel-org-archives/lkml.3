Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757565Ab3DSKNy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 06:13:54 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:50618 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756664Ab3DSKNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 06:13:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Lars-Peter Clausen" <lars@metafoo.de>
Subject: Re: [PATCH 2/2] dma:of: Use a mutex to protect the of_dma_list
Date: Fri, 19 Apr 2013 12:13:48 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: Vinod Koul <vinod.koul@intel.com>, Jon Hunter <jon-hunter@ti.com>,
        linux-kernel@vger.kernel.org
References: <1366364534-3298-1-git-send-email-lars@metafoo.de> <1366364534-3298-2-git-send-email-lars@metafoo.de>
In-Reply-To: <1366364534-3298-2-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201304191213.48631.arnd@arndb.de>
X-Provags-ID: V02:K0:gYYfuVFOlhKZ91KWe3L9ChWLJOO+0fmaWqLLilvbQ71
 RNeNCz1+dyOPmneFzE04AMv9OANdEIB13V5Bm8KA6i8D3hgqUP
 evchgfvStMmOr0iPjKbubSJxqU0X87aTLS2QbB4yp6CxhuMXPN
 SEJrv07gJCQuLiU2u3+vwmoBnCDnYCoAi3JAw7xJDbh8ZIvDma
 bvDNicQwy+ZO/rp3cqizcyzpjkpZdrqZkkis5Q85y8jQMLUx8o
 jSJXymy3vW+e6ZTK9j59gLiOJA6xHQoRp2R1Epq5NnZyI+un8z
 NG0zuoL0vxElhblujVXnNapWR958ObgYIyCk516Tmcbv2378UC
 HsNjNMzpL+u7aHfRjlYM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 19 April 2013, Lars-Peter Clausen wrote:

> This is rather ugly and unnecessary and non of the current users of
> of_dma_controller_free() check it's return value anyway. Instead protect the
> list by a mutex. The mutex will be held as long as a request operation is in
> progress. So if of_dma_controller_free() is called while a request operation is
> in progress it will be put to sleep and only wake up once the request operation
> has finished.
> 
> This means that it is no longer possible to register or unregister OF DMA
> controllers from a context where it's not possible to sleep. But I doubt that
> we'll ever need this.
> 
> Also rename of_dma_get_controller back to of_dma_find_controller.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>

I guess we could also fix it by turning the reference count into a proper
kref with kref_put calling the destructor, but your solution seems to solve
the problem just as well.

Acked-by: Arnd Bergmann <arnd@arndb.de>

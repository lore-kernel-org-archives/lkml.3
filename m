Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032AbaIZUOc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 16:14:32 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:57438 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754829AbaIZUOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 16:14:31 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/3] drivers: of: add return value to of_reserved_mem_device_init
Date: Fri, 26 Sep 2014 22:13:31 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, linux-kernel@vger.kernel.org,
        Laura Abbott <lauraa@codeaurora.org>,
        Josh Cartwright <joshc@codeaurora.org>,
        Michal Nazarewicz <mina86@mina86.com>, linaro-mm-sig@lists.linaro.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Grant Likely <grant.likely@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
References: <1410434561-9294-1-git-send-email-m.szyprowski@samsung.com> <1410434561-9294-2-git-send-email-m.szyprowski@samsung.com>
In-Reply-To: <1410434561-9294-2-git-send-email-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201409262213.31848.arnd@arndb.de>
X-Provags-ID: V02:K0:/M1Wj/ZJYN4ejU9BFUQ/4eWaK6jT1QsC6R0O8iDFpcz
 4DfuYXNSjw0+RB5ggYM1WUNwMC8A4wTgiClWJa3z5iHSQ071yK
 drA02wEBQ0qzfUoYJYTKaDZ57dW4XEtgMNSiVFALGwxjMx/PXr
 C9IeA3sC+Z/Ggt7zs6BnkJshe9xI9VTUqGGLpktHLGEVUGPmnr
 c8YyYXc+6xzBWBCAuB3MOOt4B/egMqmWmLx+OIAthtvEDDoHH3
 Ct5nFBAbGZaOXkRS3jg2OSVl2hdidvvNTVbpFSuIh/2yiPtG5i
 pm1XQ4+iHSrXcOeJQhcEtFYGiAk1J6zb+GtO7zSV39uTHh3u+7
 37Ry3HFO9KYFQlNBuKQE=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 September 2014, Marek Szyprowski wrote:
> -void of_reserved_mem_device_init(struct device *dev)
> +int of_reserved_mem_device_init(struct device *dev)
>  {
>         struct reserved_mem *rmem;
>         struct device_node *np;
> @@ -260,6 +260,7 @@ void of_reserved_mem_device_init(struct device *dev)
>  
>         rmem->ops->device_init(rmem, dev);
>         dev_info(dev, "assigned reserved memory node %s\n", rmem->name);
> +       return 0;
>  }

This function has two other 'return' statements that now are missing 
a return value for the error case and cause undefined behavior
in the caller.

	Arnd

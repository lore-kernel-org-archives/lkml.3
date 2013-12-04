Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932321Ab3LDL6K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 06:58:10 -0500
Received: from mail-yh0-f53.google.com ([209.85.213.53]:56509 "EHLO
	mail-yh0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932306Ab3LDL6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 06:58:07 -0500
Date: Wed, 4 Dec 2013 11:58:00 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Stefan Agner <stefan@agner.ch>, swarren@wwwdotorg.org,
        thierry.reding@gmail.com, dev@lynxeye.de, lgirdwood@gmail.com,
        kai.poggensee@avionic-design.de, sameo@linux.intel.com,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/3] mfd: tps6586x: add version detection
Message-ID: <20131204115800.GA6332@lee--X1>
References: <cover.1386108712.git.stefan@agner.ch>
 <77384d24810d9a22fc04cad6f7468f54a9cbaafe.1386108712.git.stefan@agner.ch>
 <20131204081021.GB7469@lee--X1>
 <e2ae7b9602d0c1e11f8e56ced17e9da0@agner.ch>
 <20131204100728.GA907@lee--X1>
 <20131204114909.GK29268@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131204114909.GK29268@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > As I pointed out in the comment above, the struct tps6586x is in the C
> > > file, so I would need to move that too. That's why I did not made that
> > > change in the end. What do you think, should I still move (and move the
> > > struct too?) 
> 
> > Why would the struct have to be moved if the function is inline?
> 
> If the function is in the header and trying to use a struct that's only
> defined in the C file then it's not going to build - keeping the struct
> in the C file only does seem like a worthwhile thing for encapsulation.

Yes, I just carried out my own testing and found that out. Prior to
this I was under the impression that inline functions were directly
transposed into the location of the call, were perhaps it could make
use of any resources declared within that context. It appears that
impression was not correct.

Every day continues to be a school day. :)

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

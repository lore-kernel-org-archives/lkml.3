Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933386Ab3CLTLL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 15:11:11 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:49714 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933318Ab3CLTLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 15:11:09 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [PATCH v2] ARM: tegra: expose chip ID and revision
Date: Tue, 12 Mar 2013 19:10:54 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-8-generic; KDE/4.3.2; x86_64; ; )
Cc: Danny Huang <dahuang@nvidia.com>, linux@arm.linux.org.uk, hdoyu@nvidia.com,
        olof@lixom.net, gregkh@linuxfoundation.org, josephl@nvidia.com,
        pdeschrijver@nvidia.com, pgaikwad@nvidia.com,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1363089667-15737-1-git-send-email-dahuang@nvidia.com> <201303121259.18710.arnd@arndb.de> <513F6E2C.1000101@wwwdotorg.org>
In-Reply-To: <513F6E2C.1000101@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201303121910.55141.arnd@arndb.de>
X-Provags-ID: V02:K0:j73ZIEXmdaN8PHmbkjVjSZEA3PjOIwEidAl4LUKBHeo
 fufmif+b5ARWYwgdIJh+SP7tlTdhnDi1EHuc7NBGpgU8qna9Xn
 cZkRiK7Rk4UPV1u8tnkzK38bLOKe0argwSYjoA2N4+vj6YpOkj
 Os5msvjfwbN0qRN/15CXsn1MqFGc5imQHHk1b1cP6pYR+w2myp
 Ib3skzV4TUoIhMt56Jx8vuuHFGX1apPcpzWSvdEsvc7LZrLE8Z
 UDTN38gWNuY4dVz30ELErViMTx3EYoQeYfPZGphqBCF8LZ41sb
 RA2gMYo1nfwdMKwQHjvSdGexBqsni4JLVFmsF6ogxynLZkrVzS
 EdItkhpbKffCM4qohBYs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 March 2013, Stephen Warren wrote:
> > You are dropping the soc_dev on the floor here by just returning.
> > 
> > The idea of the soc node is to have all on-soc components be children
> > of that node, so you should instead pass it into of_platform_populate
> > as the parent device.
> 
> Tegra DTs don't have a separate node for on-soc vs. off-soc components.
> Wouldn't passing soc_dev into of_platform_populate() make everything a
> child of this soc_dev; is that what we want?

Yes, we had long discussions about this when the soc infrastructure was
merged. Right now, everything is a child of /sys/devices/platform/,
basically saying that all devices are random stuff that cannot be
probed. Moving it to /sys/devices/soc0 would not make the hierarchy
any deeper but show much clearer which devices are part of the
soc, and which ones are added as anonymous platform devices by code
that does not use DT based probing. Ideally the second category is
empty.

	Arnd

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838Ab3LRVUx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 16:20:53 -0500
Received: from mail-la0-f48.google.com ([209.85.215.48]:54399 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567Ab3LRVUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:20:50 -0500
Message-ID: <1387401646.31516.14.camel@host5.omatika.ru>
Subject: Re: [PATCH v2 00/16] ARM: support for ICP DAS LP-8x4x (with dts)
From: Sergei Ianovich <ynvich@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Daniel Mack <zonque@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>
Date: Thu, 19 Dec 2013 01:20:46 +0400
In-Reply-To: <201312182210.30544.arnd@arndb.de>
References: <1386543229-1542-1-git-send-email-ynvich@gmail.com>
	 <201312182150.39037.arnd@arndb.de>
	 <1387400193.31516.10.camel@host5.omatika.ru>
	 <201312182210.30544.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-12-18 at 22:10 +0100, Arnd Bergmann wrote:
> On Wednesday 18 December 2013, Sergei Ianovich wrote:
> > Could we postpone this until someone needs this functionality?
> 
> We have to be sure that any device tree files you write now can remain
> compatible with future kernels if we add it later. My reasoning at first
> was that this wouldn't work if we had to change the "compatible" string
> for the bus node, but after re-thinking it now I believe that it's fine.

Great.

> You would still be able to boot a kernel with an old dts file on a new
> kernel if it just contains a "simple-bus" node here, as long as it doesn't
> need any boot-time setup at the bus controller. We can change the dts
> file later if we need to add this functionality, which would break booting
> old kernels with the new dts files, which isn't much of a problem in
> general.

It should actually only break old kernels which require new
functionally. Otherwise, dts can have

compatible = "marvell,pxa-extbus", "simple-bus";

and an older kernel will be happy with "simple-bus". Please correct me
if I'm wrong.



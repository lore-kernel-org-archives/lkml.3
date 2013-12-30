Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128Ab3L3DOq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Dec 2013 22:14:46 -0500
Received: from gate.crashing.org ([63.228.1.57]:50115 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753422Ab3L3DOp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Dec 2013 22:14:45 -0500
Message-ID: <1388373200.4373.25.camel@pasglop>
Subject: Re: commit e38c0a1f breaks powerpc boards with uli1575 chip
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>
Cc: Rob Herring <robherring2@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Dmitry Krivoschekov <dkrivoschokov@dev.rtsoft.ru>,
        Alexey Lugovskoy <lugovskoy@dev.rtsoft.ru>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        linux-kernel@vger.kernel.org, Grant Likely <grant.likely@linaro.org>,
        linuxppc-dev@lists.ozlabs.org
Date: Mon, 30 Dec 2013 14:13:20 +1100
In-Reply-To: <201312190842.02702@blacky.localdomain>
References: <201312171135.38576@blacky.localdomain>
	 <52B1EC15.5070606@gmail.com> <201312190842.02702@blacky.localdomain>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-12-19 at 08:42 +0400, Nikita Yushchenko wrote:
> No, this does not help.
> 
> I've dumped the actual content of 'range' and 'addr' at the failure
> point 
> (i.e. ar point that returns error with e38c0a1f but passes without 
> e38c0a1f ):
> 
> OF: default map, cp=0, s=10000, da=70
> range:  01 00 00 00 00 00 00 00 00 00 00 00
>  addr:  00 00 00 00 00 00 00 00 00 00 00 70

Something that has a #address-cells larger than 2, or more generally,
an address field that contains more than a single number, must have
a specific translation backend, like we have for PCI.

This is a bit annoying but originates from the original OFW stuff on
which this stuff is based where the bus node would provide the methods
for translation.

Cheers,
Ben.
 


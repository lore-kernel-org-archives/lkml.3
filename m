Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021Ab3CPJ4Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 05:56:16 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:59126 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753754Ab3CPJ4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 05:56:14 -0400
X-Sasl-enc: OJrmWcQrybW7mukOPG/WCWiM6gxNvyL/GAZ0pRNO0lMh 1363427773
Message-ID: <51444171.1080905@ladisch.de>
Date: Sat, 16 Mar 2013 10:54:57 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Prarit Bhargava <prarit@redhat.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hpet, allow user controlled mmap for user processes
References: <1363377610-19196-1-git-send-email-prarit@redhat.com>
In-Reply-To: <1363377610-19196-1-git-send-email-prarit@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prarit Bhargava wrote:
> The CONFIG_HPET_MMAP Kconfig option exposes the memory map of the HPET
> registers to userspace.  The Kconfig help points out that in some cases this
> can be a security risk as some systems may erroneously configure the map such
> that additional data is exposed to userspace.

I'm not aware of any such system (but cannot rule out the possibility).

> In an effort to mitigate this risk, and due to the low number of users
> of the MMAP functionality I've introduced a kernel parameter,
> hpet_mmap_enable, that is required in order to actually have the HPET
> MMAP exposed.

This introduces a regression for all users.  At least make the default
state (allowed/forbidden) configurable.

Also, this patch makes the Kconfig help text a lie.


Regards,
Clemens

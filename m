Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933490Ab3CSHnb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 03:43:31 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:49777 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933075Ab3CSHn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 03:43:29 -0400
X-Sasl-enc: YWqM2Otrevxykj86btem2uRNOCBMrBxflV5rz2JGOQek 1363679008
Message-ID: <5148171D.10807@ladisch.de>
Date: Tue, 19 Mar 2013 08:43:25 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Prarit Bhargava <prarit@redhat.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hpet, allow user controlled mmap for user processes
References: <51444171.1080905@ladisch.de> <1363609488-25250-1-git-send-email-prarit@redhat.com>
In-Reply-To: <1363609488-25250-1-git-send-email-prarit@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prarit Bhargava wrote:
> The CONFIG_HPET_MMAP Kconfig option exposes the memory map of the HPET
> registers to userspace.  The Kconfig help points out that in some cases this
> can be a security risk as some systems may erroneously configure the map such
> that additional data is exposed to userspace.
>
> This is a problem for distributions -- some users want the MMAP functionality
> but it comes with a significant security risk.  In an effort to mitigate this
> risk, and due to the low number of users of the MMAP functionality, I've
> introduced a kernel parameter, hpet_mmap_enable, that is required in order
> to actually have the HPET MMAP exposed.
>
> [v2]: Clemens suggested modifying the Kconfig help text and making the
> default setting configurable.
>
> Signed-off-by: Prarit Bhargava <prarit@redhat.com>
> Cc: Clemens Ladisch <clemens@ladisch.de>

> +++ b/Documentation/kernel-parameters.txt
> +	hpet_mmap_enable [X86, HPET_MMAP] option to expose HPET MMAP to
> +			 userspace.  By default this is disabled.

This now takes a value.

> +	int "Enable HPET MMAP access by default"
> +	range 0 1

Shouldn't this be bool?

> +	default 0

This breaks backwards compatibility.


Regards,
Clemens

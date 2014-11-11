Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751959AbaKKSj1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 13:39:27 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:60107 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbaKKSjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 13:39:25 -0500
Date: Tue, 11 Nov 2014 13:39:21 -0500 (EST)
Message-Id: <20141111.133921.243613958949858000.davem@davemloft.net>
To: rric@kernel.org
Cc: stephen@networkplumber.org, sassmann@redhat.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, sgoutham@cavium.com, rrichter@cavium.com
Subject: Re: [PATCH v2] VNIC: Adding support for Cavium ThunderX network
 controller
From: David Miller <davem@davemloft.net>
In-Reply-To: <1415596445-10061-1-git-send-email-rric@kernel.org>
References: <1415596445-10061-1-git-send-email-rric@kernel.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 11 Nov 2014 10:39:24 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <rric@kernel.org>
Date: Sun,  9 Nov 2014 21:14:05 -0800

> +config NET_VENDOR_CAVIUM
 ...
> +config THUNDER_NIC_PF
...
> +config THUNDER_NIC_VF
 ...
> +config	THUNDER_NIC_BGX

These config options seem excessive, if not confusing.  What would a
distribution be expected to enable?  Everything?

> +# Don't change the order, NICPF driver is dependent on BGX driver init
> +obj-$(CONFIG_THUNDER_NIC_BGX) += thunder_bgx.o
> +obj-$(CONFIG_THUNDER_NIC_PF) += nicpf.o
> +obj-$(CONFIG_THUNDER_NIC_VF) += nicvf.o

Nothing ensures ordering if these things are built all modular.

Such ordering dependencies need to be resolved in another way.

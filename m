Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751394AbaJRJWo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 05:22:44 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:57500 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbaJRJWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 05:22:41 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: atull <atull@opensource.altera.com>
Cc: Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Dinh Nguyen <dinguyen@opensource.altera.com>,
        Philipp Zabel <p.zabel@pengutronix.de>, dinh.linux@gmail.com,
        grant.likely@linaro.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] reset: socfpga: use arch_initcall for early initialization
Date: Sat, 18 Oct 2014 11:22:20 +0200
Message-ID: <2269547.Q1ItkFJzpa@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <alpine.DEB.2.02.1410101123590.11270@atx-linux-37>
References: <1412822646-11257-1-git-send-email-dinguyen@opensource.altera.com> <20141009151935.GK15799@pengutronix.de> <alpine.DEB.2.02.1410101123590.11270@atx-linux-37>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:yj2gYf3VKrmSXPtjd0FcOhHd6TxYeDmN+WZ6meQIV9U
 Ymyyua2MvS27Cq/rLXMjAX34e7aBBqaa4b5ZUtdKNQ07A2gp6j
 aCxenlaO1CZCOnbHRdc8FV2BGnXajS2oaNDxtN9KTKuU5kVnx0
 D/2Hhu2eUkFDMnjWRfjyuPAFFMEsM6DzeZm1abHzrXS8eHIfNz
 kQos/RaCKzuKpgfS6maR+8xf5CF5E19DPVqiBQZCFQfNAucl+m
 no0Si5wTJrUVTNhwpbiJajRj6iHxJlv+xBMPpG5YKAKeHGZJQ3
 OERQfOUs+ZbpygwaQsGgazRYgfncocWfpSeG8Qv+QfAaiafRAi
 TZfGepfQRI9C0nSX9FRc=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 10 October 2014 11:32:35 atull wrote:
> On Thu, 9 Oct 2014, Steffen Trumtrar wrote:
> > Do you have an example where this is really needed?
> 
> My last version of the fpga manager framework 
> (https://lkml.org/lkml/2014/8/1/518)
> added fpga_mgr_firmware_write().  This can be called from a device driver's 
> probe function to request a fpga image be loaded.  I want to support FPGA 
> based functionality being seen pretty similar to really hard hardware.  So 
> the FPGA could have a PCI bus or something else that would want to be 
> early.

Please be more specific. I agree we need a good reason for not just
using deferred probing, and PCI host bridges in general are no longer
something that needs to be probed early.

If you have a particular use case in mind that can't be solved in a
better way, we can talk about making this an earlier initcall (probably
not arch_initcall), but in general we try hard to avoid new ones
like this.

	Arnd

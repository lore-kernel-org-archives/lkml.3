Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751323AbaKZNMA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 08:12:00 -0500
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:56085 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750768AbaKZNL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 08:11:58 -0500
Message-ID: <1417007515.29407.54.camel@x220>
Subject: Re: [PATCH 5/8] of/overlay: Introduce DT overlay support
From: Paul Bolle <pebolle@tiscali.nl>
To: Grant Likely <grant.likely@linaro.org>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        Rob Herring <robh+dt@kernel.org>
Date: Wed, 26 Nov 2014 14:11:55 +0100
In-Reply-To: <1416533715-9758-6-git-send-email-grant.likely@linaro.org>
References: <1416533715-9758-1-git-send-email-grant.likely@linaro.org>
	 <1416533715-9758-6-git-send-email-grant.likely@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Nov 2014 13:11:55.0448 (UTC) FILETIME=[8D447B80:01D0097A]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-11-21 at 01:35 +0000, Grant Likely wrote:
> From: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
> 
> Overlays are a method to dynamically modify part of the kernel's
> device tree with dynamically loaded data. Add the core functionality to
> parse, apply and remove an overlay changeset. The core functionality
> takes care of managing the overlay data format and performing the add
> and remove. Drivers are expected to use the overlay functionality to
> support custom expansion busses commonly found on consumer development
> boards like the BeagleBone or Raspberry Pi.
> 
> The overlay code uses CONFIG_OF_DYNAMIC changesets to perform the low
> level work of modifying the devicetree.
> 
> Documentation about internal and APIs is provided in
> 	Documentation/devicetree/overlay-notes.txt
> 
> v2:
> - Switch from __of_node_alloc() to __of_node_dup()
> - Documentation fixups
> - Remove 2-pass processing of properties
> - Remove separate ov_lock; just use the DT mutex.
> v1:
> - Drop delete capability using '-' prefix. The '-' prefixed names
> are valid properties and nodes and there is no need for it just yet.
> - Do not update special properties - name & phandle ones.
> - Change order of node attachment, so that the special property update
> works.
> 
> Signed-off-by: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
> Signed-off-by: Grant Likely <grant.likely@linaro.org>

Now commit 7518b5890d8a ("of/overlay: Introduce DT overlay support"),
included in today's linux-next (next-20141126).

>  Documentation/devicetree/overlay-notes.txt | 133 +++++++
>  drivers/of/Kconfig                         |   7 +
>  drivers/of/Makefile                        |   1 +
>  drivers/of/overlay.c                       | 562 +++++++++++++++++++++++++++++
>  include/linux/of.h                         |  31 ++
>  5 files changed, 734 insertions(+)
>  create mode 100644 Documentation/devicetree/overlay-notes.txt
>  create mode 100644 drivers/of/overlay.c
> 
>[...]
> diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
> index fbe8f8d418f7..18b2e2539f84 100644
> --- a/drivers/of/Kconfig
> +++ b/drivers/of/Kconfig
> @@ -84,4 +84,11 @@ config OF_RESERVED_MEM
>  config OF_RESOLVE
>  	bool
>  
> +config OF_OVERLAY
> +	bool
> +	depends on OF
> +	select OF_DYNAMIC
> +	select OF_DEVICE

There's currently no Kconfig symbol OF_DEVICE. So this select is now a
nop. Will that symbol be added in a future patch?

> +	select OF_RESOLVE
> +
>  endmenu # OF


Paul Bolle


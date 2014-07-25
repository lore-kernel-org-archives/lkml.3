Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760875AbaGYSKW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 14:10:22 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:58528 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753401AbaGYSKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 14:10:20 -0400
Message-ID: <53D29D87.4060708@austin.ibm.com>
Date: Fri, 25 Jul 2014 13:10:15 -0500
From: Nathan Fontenot <nfont@austin.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        Tyrel Datwyler <turtle.in.the.kernel@gmail.com>,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 00/10] of: Core devicetree changeset support
References: <1406159064-21366-1-git-send-email-grant.likely@linaro.org>
In-Reply-To: <1406159064-21366-1-git-send-email-grant.likely@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14072518-7164-0000-0000-00000361E50C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2014 06:44 PM, Grant Likely wrote:
> Hi all,
> 
> This is a rollup of all the patches that I queued up today for
> linux-next for the devicetree changeset and overlay work. I'm reposting
> these patches because some have been significantly changed since their
> first posting. None of the code is actually live yet, but the test cases
> are there.
> 
> There is one significant functional change which may affect pseries. The
> OF_DYNAMIC code has been changed to emit notifiers after applying a
> change to the tree instead of before. I think I've got all they users
> taken care of correctly, but I'd like to see some testing. I don't have
> access to pseries (and I can't get the QEMU pseries model to boot reliably)
> 
> Nathan/Tyrel, can you give it a spin? The changes can be found in my git tree:

Grant,

I was able to do some sniff testing by adding/removing memory, cpus, and pci
devices and it appears that all device tree nodes and properties were updated
properly.

I would still like to try doing live partition migration where we can update
many pieces of the device tree. I'll be out next week, will try to get
on that when I return.

-Nathan

> 
>   git://git.secretlab.ca/git/linux devicetree/next
> 
> Grant Likely (8):
>       of/platform: Fix of_platform_device_destroy iteration of devices
>       of: Move CONFIG_OF_DYNAMIC code into a separate file
>       of: Make devicetree sysfs update functions consistent.
>       of: Make sure attached nodes don't carry along extra children
>       of: Move dynamic node fixups out of powerpc and into common code
>       of: Reorder device tree changes and notifiers
>       of: Add todo tasklist for Devicetree
>       Merge branch 'devicetree/next-overlay' into devicetree/next
> 
> Pantelis Antoniou (4):
>       of: rename of_aliases_mutex to just of_mutex
>       OF: Utility helper functions for dynamic nodes
>       of: Create unlocked versions of node and property add/remove functions
>       of: Transactional DT support.
> 
>  Documentation/devicetree/changesets.txt         |  40 ++
>  Documentation/devicetree/todo.txt               |  11 +
>  arch/powerpc/kernel/prom.c                      |  70 ---
>  arch/powerpc/platforms/pseries/hotplug-memory.c |   2 +-
>  drivers/crypto/nx/nx-842.c                      |  30 +-
>  drivers/of/Makefile                             |   1 +
>  drivers/of/base.c                               | 423 ++++-----------
>  drivers/of/device.c                             |   4 +-
>  drivers/of/dynamic.c                            | 660 ++++++++++++++++++++++++
>  drivers/of/of_private.h                         |  59 ++-
>  drivers/of/platform.c                           |  32 +-
>  drivers/of/selftest.c                           |  79 +++
>  drivers/of/testcase-data/testcases.dtsi         |  10 +
>  include/linux/of.h                              |  80 ++-
>  include/linux/of_platform.h                     |   7 +-
>  15 files changed, 1065 insertions(+), 443 deletions(-)
>  create mode 100644 Documentation/devicetree/changesets.txt
>  create mode 100644 Documentation/devicetree/todo.txt
>  create mode 100644 drivers/of/dynamic.c
> 


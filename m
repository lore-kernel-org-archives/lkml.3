Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752459AbaCMGkO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 02:40:14 -0400
Received: from li42-95.members.linode.com ([209.123.162.95]:60446 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751188AbaCMGkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 02:40:12 -0400
X-Greylist: delayed 571 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Mar 2014 02:40:12 EDT
Subject: Re: [PATCH] OF: kobj node lifecycle fixes
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <1394664580-23130-1-git-send-email-grant.likely@linaro.org>
Date: Thu, 13 Mar 2014 08:30:37 +0200
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Rob Herring <robh@kernel.org>
Content-Transfer-Encoding: 7bit
Message-Id: <FF624D4F-D74C-48B1-896B-D0E32CBE7DBF@antoniou-consulting.com>
References: <1394664580-23130-1-git-send-email-grant.likely@linaro.org>
To: Grant Likely <grant.likely@linaro.org>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

On Mar 13, 2014, at 12:49 AM, Grant Likely wrote:

> From: Pantelis Antoniou <panto@antoniou-consulting.com>
> 
> After the move to having device nodes be proper kobjects the lifecycle
> of the node needs to be controlled better.
> 
> At first convert of_add_node() in the unflattened functions to
> of_init_node() which initializes the kobject so that of_node_get/put
> work correctly even before of_init is called.
> 
> Afterwards introduce of_node_is_initialized & of_node_is_attached that
> query the underlying kobject about the state (attached means kobj
> is visible in sysfs)
> 
> Using that make sure the lifecycle of the tree is correct at all
> times.
> 
> Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
> [grant.likely: moved of_node_init() calls, fixed up locking, and
>               dropped __of_populate() hunks]
> Signed-off-by: Grant Likely <grant.likely@linaro.org>
> ---
> 
> I've reworked Pantelis' patch to work on my tree. Here's the result.
> I've already got this in my tree and will be pushing it out shortly.
> 
> g.
> 
> drivers/of/base.c  | 35 ++++++++++++++++++++++++++---------
> drivers/of/fdt.c   |  3 +--
> drivers/of/pdt.c   |  3 +--
> include/linux/of.h | 19 +++++++++++++++++++
> 4 files changed, 47 insertions(+), 13 deletions(-)
> 

Looks good; booted and tested overlays with no issues.

Regards

-- Pantelis


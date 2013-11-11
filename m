Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058Ab3KKWQB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 17:16:01 -0500
Received: from mga02.intel.com ([134.134.136.20]:48043 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751716Ab3KKWPv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 17:15:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="433481773"
Message-ID: <528156E4.1030409@intel.com>
Date: Mon, 11 Nov 2013 14:15:00 -0800
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Zhi Yong Wu <zwu.kernel@gmail.com>, viro@zeniv.linux.org.uk
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>,
        Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH v6 07/11] VFS hot tracking: Add a /proc interface to control
 memory usage
References: <1383745544-391-1-git-send-email-zwu.kernel@gmail.com> <1383745544-391-8-git-send-email-zwu.kernel@gmail.com>
In-Reply-To: <1383745544-391-8-git-send-email-zwu.kernel@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2013 05:45 AM, Zhi Yong Wu wrote:
> Introduce a /proc interface hot-mem-high-thresh and
> to cap the memory which is consumed by hot_inode_item
> and hot_range_item, and they will be in the unit of
> 1M bytes.

You don't seem to have any documentation for this, btw... :(

> +		.procname       = "hot-mem-high-thresh",

*Always* put units on these.  I know you mention it in a code comment,
but please also include it in the proc filename too.

In general, why do you have to control the number of these statically?
Shouldn't you just define a shrinker and let memory pressure determine
how many of these we allow to exist?

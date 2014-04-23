Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757423AbaDWIVU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 04:21:20 -0400
Received: from mga09.intel.com ([134.134.136.24]:27321 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754124AbaDWIVR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 04:21:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,910,1389772800"; 
   d="scan'208";a="517799278"
Message-ID: <535777F2.1050501@intel.com>
Date: Wed, 23 Apr 2014 16:21:06 +0800
From: Jet Chen <jet.chen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Dan Williams <dan.j.williams@intel.com>
CC: Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>, lkp@01.org,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [libata/ahci] 8a4aeec8d2d: +138.4% perf-stat.dTLB-store-misses,
 +37.2% perf-stat.dTLB-load-misses
References: <5354C8F3.3050504@intel.com> <CAPcyv4jWnaF6tNfZqf13WnqZ0=U98X-5K-kMWnruQPoBYO21KQ@mail.gmail.com>
In-Reply-To: <CAPcyv4jWnaF6tNfZqf13WnqZ0=U98X-5K-kMWnruQPoBYO21KQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2014 01:11 AM, Dan Williams wrote:
> On Mon, Apr 21, 2014 at 12:29 AM, Jet Chen <jet.chen@intel.com> wrote:
>> HI Dan,
>>
>> we noticed the below changes on
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/tj/libata for-next
>> commit 8a4aeec8d2d6a3edeffbdfae451cdf05cbf0fefd ("libata/ahci: accommodate
>> tag ordered controllers")
> 
> Hi, was this on simulated hardware or a real AHCI controller and disk?
> 

Testing was on a physical machine with a real AHCI controller.

root@bay ~# lspci | grep AHCI
00:1f.2 SATA controller: Intel Corporation 82801IR/IO/IH (ICH9R/DO/DH) 6 port SATA Controller [AHCI mode] (rev 02)

> It does appear this test noticed increased throughput:
> 
>     203893 ~ 0%      +3.7%     211474 ~ 0%  TOTAL iostat.sda.wkB/s
> 
> I wonder if ap->last_tag can be moved to a hotter cacheline, but if
> throughput goes up I can imagine it throws off the cpu statistics
> quite a bit.
> 

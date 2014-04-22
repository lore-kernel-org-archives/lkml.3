Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933478AbaDVRL7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 13:11:59 -0400
Received: from mail-ve0-f175.google.com ([209.85.128.175]:54822 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932737AbaDVRL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 13:11:57 -0400
MIME-Version: 1.0
In-Reply-To: <5354C8F3.3050504@intel.com>
References: <5354C8F3.3050504@intel.com>
Date: Tue, 22 Apr 2014 10:11:56 -0700
Message-ID: <CAPcyv4jWnaF6tNfZqf13WnqZ0=U98X-5K-kMWnruQPoBYO21KQ@mail.gmail.com>
Subject: Re: [libata/ahci] 8a4aeec8d2d: +138.4% perf-stat.dTLB-store-misses,
 +37.2% perf-stat.dTLB-load-misses
From: Dan Williams <dan.j.williams@intel.com>
To: Jet Chen <jet.chen@intel.com>
Cc: Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>, lkp@01.org,
        Fengguang Wu <fengguang.wu@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2014 at 12:29 AM, Jet Chen <jet.chen@intel.com> wrote:
> HI Dan,
>
> we noticed the below changes on
>
> git://git.kernel.org/pub/scm/linux/kernel/git/tj/libata for-next
> commit 8a4aeec8d2d6a3edeffbdfae451cdf05cbf0fefd ("libata/ahci: accommodate
> tag ordered controllers")

Hi, was this on simulated hardware or a real AHCI controller and disk?

It does appear this test noticed increased throughput:

    203893 ~ 0%      +3.7%     211474 ~ 0%  TOTAL iostat.sda.wkB/s

I wonder if ap->last_tag can be moved to a hotter cacheline, but if
throughput goes up I can imagine it throws off the cpu statistics
quite a bit.

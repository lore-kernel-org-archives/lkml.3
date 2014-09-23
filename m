Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756984AbaIWXYB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 19:24:01 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:44770 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732AbaIWXX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 19:23:59 -0400
MIME-Version: 1.0
X-Originating-IP: [2001:470:8:ee7:c074:25b1:7d97:a0af]
In-Reply-To: <ndhwbqvboe9c48.fsf@rasscmlmus001.pdx.intel.com>
References: <c6aff784285e77771ad4edd3d451d95529bfb17d.1411496575.git.ashutosh.dixit@intel.com>
 <5421EA22.6000206@infradead.org> <ndhwbqvboe9c48.fsf@rasscmlmus001.pdx.intel.com>
From: Peter Foley <pefoley2@pefoley.com>
Date: Tue, 23 Sep 2014 19:23:39 -0400
Message-ID: <CAOFdcFMLYJ9qqRB-uwyLwyBpa=KTsHMbzdANJrmRu_wrqNArOA@mail.gmail.com>
Subject: Re: [PATCH linux-next] Documentation: mic: mpssd: Disable mpssd
 builds for kernels < 3.13
To: ashutosh dixit <ashutosh.dixit@intel.com>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Dutt, Sudeep" <sudeep.dutt@intel.com>,
        "Rao, Nikhil" <nikhil.rao@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 6:59 PM, ashutosh dixit
<ashutosh.dixit@intel.com> wrote:
> Correct, if things in Documentation will be compiled against the headers
> in the kernel source tree then this patch is not required. However,
> Andrew had reported the following compile error:
>
>> In file included from Documentation/mic/mpssd/sysfs.c:21:
>> Documentation/mic/mpssd/mpssd.h:55:30: error: linux/virtio_ids.h: No such file or directory
>
> which made it appear to us that Documentation was being compiled against
> headers installed on the system, not headers in the kernel source
> tree. The patch was submitted to address this latter case, but if that
> does not occur it is not required.
>
Alright, if you want to handle the case where somebody is trying to
build against old and incompatible headers,
just have a #error "Your kernel headers are too old, at least 3.13 is
required" at the top of mpssd.c instead of having it fail at runtime.

Thanks,

Peter

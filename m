Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435Ab3DWDXq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 23:23:46 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:39272 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185Ab3DWDXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 23:23:45 -0400
Message-ID: <5175FF0F.9050206@oracle.com>
Date: Tue, 23 Apr 2013 11:25:03 +0800
From: DuanZhenzhong <zhenzhong.duan@oracle.com>
Organization: Oracle Corporation
User-Agent: Thunderbird 2.0.0.24 (X11/20101209)
MIME-Version: 1.0
To: Jean Delvare <jdelvare@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: memcpy_fromio in dmi_scan.c
References: <1366636689.4503.35.camel@chaos.site>
In-Reply-To: <1366636689.4503.35.camel@chaos.site>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jean Delvare wrote:
> Hi Duan, Andrew,
>
> I am looking at the following commit:
>
> commit 9f9c9cbb60576a1518d0bf93fb8e499cffccf377
> Author: Zhenzhong Duan <zhenzhong.duan@oracle.com>
> Date:   Thu Dec 20 15:05:14 2012 -0800
>
>     drivers/firmware/dmi_scan.c: fetch dmi version from SMBIOS if it exists
>
> And I am worried about calls to memcpy_fromio(), or lack thereof. Before
> this commit, the code would take great care to always call
> memcpy_fromio() to get data from the 0xF0000-0xFFFFF memory range (BIOS
> data) and operate on that copy. After this commit, the code is happily
> calling memcmp() directly on an __iomem pointer. It seems to be harmless
> on x86, but it will break on IA64, won't it?
>
>   
Hi Jean,
What's the impact of reading bios data directly on IA64?
Sorry I have little knowledge about IA64.

zduan

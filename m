Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772AbbAZNjM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 08:39:12 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:54625 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbbAZNjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 08:39:09 -0500
Message-ID: <54C64379.7070001@suse.cz>
Date: Mon, 26 Jan 2015 14:39:05 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Ian Campbell <Ian.Campbell@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        david.vrabel@citrix.com, stable@vger.kernel.org,
        Luis Henriques <luis.henriques@canonical.com>
Subject: Re: [Xen-devel] [PATCH 2/2] swiotlb-xen: pass dev_addr to swiotlb_tbl_unmap_single
References: <alpine.DEB.2.02.1411211657430.2675@kaball.uk.xensource.com>	 <1416589220-7720-2-git-send-email-stefano.stabellini@eu.citrix.com> <1422269607.27469.5.camel@citrix.com>
In-Reply-To: <1422269607.27469.5.camel@citrix.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26/2015, 11:53 AM, Ian Campbell wrote:
> On Fri, 2014-11-21 at 17:00 +0000, Stefano Stabellini wrote:
>> Need to pass the pointer within the swiotlb internal buffer to the
>> swiotlb library, that in the case of xen_unmap_single is dev_addr, not
>> paddr.
>>
>> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
>> CC: konrad.wilk@oracle.com
>> CC: stable@vger.kernel.org
> 
> This went into mainline as 2c3fc8d26dd0 "swiotlb-xen: pass dev_addr to
> swiotlb_tbl_unmap_single" but was reverted in dbdd74763f1f.
> 
> However it seems that 2c3fc8d26dd0 has made it into at least some stable
> kernel trees:
>         v3.18.3 as 2129c43d41e9
>         v3.16.7-ckt4 as 94ab279b0c9a
>         v3.14.29 as 3394691d34fc
>         v3.10.65 as 81cb80b578c5
> so it should be reverted there too. This is causing issues in the field
> such as https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=776237.
> 
> v3.17, v3.15, v3.13.11-ckt14, v3.12.x, v3.11.x appear clean, I stopped

Hi, dropped from the 3.12 queue.

thanks,
-- 
js
suse labs

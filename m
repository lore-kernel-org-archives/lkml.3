Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757076Ab3FETBK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 15:01:10 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:40103 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756164Ab3FETBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 15:01:08 -0400
Message-ID: <51AF8AEA.4030702@linux.vnet.ibm.com>
Date: Thu, 06 Jun 2013 00:30:58 +0530
From: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: linuxppc-dev@ozlabs.org, paulus@samba.org, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org
CC: jkenisto@linux.vnet.ibm.com, tony.luck@intel.com,
        mahesh@linux.vnet.ibm.com, cbouatmailru@gmail.com, anton@samba.org,
        ccross@android.com, keescook@chromium.org
Subject: Re: [RFC PATCH 0/3] Nvram-to-pstore: compression support for oops
 data
References: <20130426094923.14323.80567.stgit@aruna-ThinkPad-T420>
In-Reply-To: <20130426094923.14323.80567.stgit@aruna-ThinkPad-T420>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13060518-5564-0000-0000-0000083C26C5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

There is no change in this patchset and it applies cleanly on top of
v4 of Nvram-to-pstorepatches.

> The patchset takes care of compressing oops messages while writing to NVRAM,
> so that more oops data can be captured in the given space.
>
> big_oops_buf (2.22 * oops_data_sz) is allocated for compression.
> oops_data_sz is oops header size less of oops partition size.
>
> Pstore will internally call kmsg_dump to capture messages from printk
> buffer. While returning the data to nvram it adds is own header.
>
> For compression:
> 	Register pstore with big_oops_buf.
>
> In case compression fails, copy header added by pstore and
> last oops_data_sz bytes (recent messages) of big_oops_buf to
> nvram for which we need to know header size.
> 	
> patch 01/03 will add a function in pstore to return the header size.
>
> pstore read callback of nvram will read the compressed data and return the
> decompressed data so that dmesg file (under /dev/pstore) is readable.
>
> In case decompression fails, instead of having the compressed data (junk) in the
> dmesg file it will skip and continue reading other partitions. This results in
> absence of dmesg file but will still have files relating to other parititons.
>
>
> ---
>
> Aruna Balakrishnaiah (3):
>        Retreive header size from pstore.
>        powerpc/pseries: Re-organise the oops compression code
>        powerpc/pseries: Support compression of oops text via pstore
>
>
>   arch/powerpc/platforms/pseries/nvram.c |  236 +++++++++++++++++++++++---------
>   fs/pstore/platform.c                   |    7 +
>   include/linux/pstore.h                 |    6 +
>   3 files changed, 182 insertions(+), 67 deletions(-)
>


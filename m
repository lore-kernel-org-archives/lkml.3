Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415Ab3DYFxb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 01:53:31 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:34258 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213Ab3DYFxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 01:53:30 -0400
Message-ID: <5178C4CE.70201@linux.vnet.ibm.com>
Date: Thu, 25 Apr 2013 11:23:18 +0530
From: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: linuxppc-dev@ozlabs.org, paulus@samba.org,
        LKML <linux-kernel@vger.kernel.org>, benh@kernel.crashing.org,
        jkenisto@linux.vnet.ibm.com, Tony Luck <tony.luck@intel.com>,
        ananth@in.ibm.com, mahesh@linux.vnet.ibm.com,
        Colin Cross <ccross@android.com>, anton@samba.org,
        Anton Vorontsov <cbouatmailru@gmail.com>
Subject: Re: [PATCH v2 0/8] powerpc/pseries: Nvram-to-pstore
References: <20130424061807.7341.909.stgit@aruna-ThinkPad-T420> <CAGXu5jLrtMFXh28b2uV6+U8vdXRfLxmjKRo8i5YF8bmkeK_sKg@mail.gmail.com>
In-Reply-To: <CAGXu5jLrtMFXh28b2uV6+U8vdXRfLxmjKRo8i5YF8bmkeK_sKg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13042505-2674-0000-0000-000008BA738B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kees,

On Thursday 25 April 2013 02:15 AM, Kees Cook wrote:
> On Tue, Apr 23, 2013 at 11:19 PM, Aruna Balakrishnaiah
> <aruna@linux.vnet.ibm.com> wrote:
>> Currently the kernel provides the contents of p-series NVRAM only as a
>> simple stream of bytes via /dev/nvram, which must be interpreted in user
>> space by the nvram command in the powerpc-utils package. This patch set
>> exploits the pstore subsystem to expose each partition in NVRAM as a
>> separate file in /dev/pstore. For instance Oops messages will stored in a
>> file named [dmesg-nvram-2].
>>
>> Changes from v1:
>>          - Reduce #ifdefs by and remove forward declarations of pstore callbacks
>>          - Handle return value of nvram_write_os_partition
>>          - Remove empty pstore callbacks and register pstore only when pstore
>>            is configured
>>
>> ---
>>
>> Aruna Balakrishnaiah (8):
>>        powerpc/pseries: Remove syslog prefix in uncompressed oops text
>>        powerpc/pseries: Add version and timestamp to oops header
>>        powerpc/pseries: Introduce generic read function to read nvram-partitions
>>        powerpc/pseries: Read/Write oops nvram partition via pstore
>>        powerpc/pseries: Read rtas partition via pstore
>>        powerpc/pseries: Distinguish between a os-partition and non-os partition
>>        powerpc/pseries: Read of-config partition via pstore
>>        powerpc/pseries: Read common partition via pstore
>>
>>
>>   arch/powerpc/platforms/pseries/nvram.c |  353 +++++++++++++++++++++++++++-----
>>   fs/pstore/inode.c                      |    9 +
>>   include/linux/pstore.h                 |    4
>>   3 files changed, 313 insertions(+), 53 deletions(-)
> This series looks good! Other than the naming conventions (are these
> new pstore types really PPC-only?) I think it's a fine addition.
>
> Thanks!

The new pstore types are PPC specific. Hence it would be better to have the
(_PPC) in the type ids so that other does not end up using these ids.

> -Kees
>
> --
> Kees Cook
> Chrome OS Security
>


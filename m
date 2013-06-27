Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013Ab3F0PgI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 11:36:08 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:44136 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796Ab3F0PgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 11:36:05 -0400
MIME-Version: 1.0
In-Reply-To: <20130627082941.16749.67023.stgit@aruna-ThinkPad-T420>
References: <20130627082941.16749.67023.stgit@aruna-ThinkPad-T420>
Date: Thu, 27 Jun 2013 08:36:05 -0700
X-Google-Sender-Auth: FBJebdDn8oo3JDRfdSpsVjpNXN8
Message-ID: <CAGXu5j+5G9uwV+NVW1E3YzQtGqJnm0vV1eZWuPEtTC=2wmyG8g@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] Nvram-to-pstore: compression support for oops data
From: Kees Cook <keescook@chromium.org>
To: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
Cc: Tony Luck <tony.luck@intel.com>, benh@kernel.crashing.org,
        LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
        paulus@samba.org, jkenisto@linux.vnet.ibm.com, ananth@in.ibm.com,
        mahesh@linux.vnet.ibm.com, Anton Vorontsov <cbouatmailru@gmail.com>,
        Anton Blanchard <anton@samba.org>, Colin Cross <ccross@android.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27, 2013 at 1:32 AM, Aruna Balakrishnaiah
<aruna@linux.vnet.ibm.com> wrote:
> Changes from v1:
>                 - Add header size argument in the pstore write callback
>                 instead of a separate API to return header size.
>
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
>         Register pstore with big_oops_buf.
>
> In case compression fails, copy header added by pstore and
> last oops_data_sz bytes (recent messages) of big_oops_buf to
> nvram for which we need to know header size.
>
> patch 01/03 adds an additional argument for header size in pstore_write callback.
>
> pstore read callback of nvram will read the compressed data and return the
> decompressed data so that dmesg file (under /dev/pstore) is readable.
>
> In case decompression fails, instead of having the compressed data (junk) in the
> dmesg file it will skip and continue reading other partitions. This results in
> absence of dmesg file but will still have files relating to other parititons.

This seems good to me. I'm starting to ponder if we need to have some
kind of regular header structure that backends can extend, but that
doesn't need to be part of this series. :)

Acked-by: Kees Cook <keescook@chromium.org>

Thanks,

-Kees

--
Kees Cook
Chrome OS Security

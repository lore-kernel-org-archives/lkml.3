Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935519Ab3BTU7q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 15:59:46 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40592 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934854Ab3BTU7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 15:59:45 -0500
Date: Wed, 20 Feb 2013 12:59:43 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Jones <pjones@redhat.com>
Cc: Fabio Estevam <festevam@gmail.com>, sfr@canb.auug.org.au,
        linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Matt Fleming <matt.fleming@intel.com>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] block: partitions: efi: Typecast sizeof(gpt_header)
Message-Id: <20130220125943.df50cc67.akpm@linux-foundation.org>
In-Reply-To: <20130220162748.GA32341@fenchurch.internal.datastacks.com>
References: <1361371930-1520-1-git-send-email-festevam@gmail.com>
	<20130220162748.GA32341@fenchurch.internal.datastacks.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Feb 2013 11:27:48 -0500
Peter Jones <pjones@redhat.com> wrote:

> On Wed, Feb 20, 2013 at 11:52:10AM -0300, Fabio Estevam wrote:
> > From: Fabio Estevam <fabio.estevam@freescale.com>
> > 
> > Since commit ef25bb0fa6e2 (block/partitions/efi.c: ensure that the GPT header is
> > at least the size of the structure.) , when building for a 32-bit architecture, 
> > such as ARM, the following build warning is seen:
> > 
> > block/partitions/efi.c:324:3: warning: format '%lu' expects argument of type 'long unsigned int', but argument 3 has type 'unsigned int' [-Wformat]
> 
> Hi Fabio,
> 
> I sent and updated version of ef25bb0fa6e2 this morning to fix this
> issue.  Thanks for the patch, though.  Andrew, if you'd like you can
> just use this instead of replacing my patch with the new one.

You're both wrong ;)  Print a size_t with %z:

--- a/block/partitions/efi.c~ensure-that-the-gpt-header-is-at-least-the-size-of-the-structure-fix
+++ a/block/partitions/efi.c
@@ -321,7 +321,7 @@ static int is_gpt_valid(struct parsed_pa
 
 	/* Check the GUID Partition Table header size is too small */
 	if (le32_to_cpu((*gpt)->header_size) < sizeof(gpt_header)) {
-		pr_debug("GUID Partition Table Header size is too small: %u < %lu\n",
+		pr_debug("GUID Partition Table Header size is too small: %u < %zu\n",
 			le32_to_cpu((*gpt)->header_size),
 			sizeof(gpt_header));
 		goto fail;
_


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759352AbaDKAWP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 20:22:15 -0400
Received: from mail-ig0-f170.google.com ([209.85.213.170]:57775 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759303AbaDKAWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 20:22:14 -0400
MIME-Version: 1.0
In-Reply-To: <53470E26.2030306@cybernetics.com>
References: <53470E26.2030306@cybernetics.com>
Date: Fri, 11 Apr 2014 02:22:13 +0200
Message-ID: <CANq1E4RWf_VbzF+dPYhzHKJvnrh86me5KajmaaB1u9f9FLzftA@mail.gmail.com>
Subject: Re: [PATCH 2/6] shm: add sealing API
From: David Herrmann <dh.herrmann@gmail.com>
To: Tony Battersby <tonyb@cybernetics.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Thu, Apr 10, 2014 at 11:33 PM, Tony Battersby <tonyb@cybernetics.com> wrote:
> For O_DIRECT the kernel pins the submitted pages in memory for DMA by
> incrementing the page reference counts when the I/O is submitted,
> allowing the pages to be modified by DMA even if they are no longer
> mapped in the address space of the process.  This is different from a
> regular read(), which uses the CPU to copy the data and will fail if the
> pages are not mapped.

Can you please provide an example code-path? For instance,
file_read_actor() does not pin any pages but only keeps the user-space
address and resolves it once it has data to write.

Thanks
David

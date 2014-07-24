Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934100AbaGXAiF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 20:38:05 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:55843 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933187AbaGXAiC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 20:38:02 -0400
MIME-Version: 1.0
In-Reply-To: <20140723141721.d6a58555f124a7024d010067@linux-foundation.org>
References: <1405616598-14798-1-git-send-email-jcmvbkbc@gmail.com>
	<20140723141721.d6a58555f124a7024d010067@linux-foundation.org>
Date: Thu, 24 Jul 2014 04:38:01 +0400
Message-ID: <CAMo8BfJ0zC16ssBDGUxsLNwmVOpgnyk1PjikunB9u-C7x9uaOA@mail.gmail.com>
Subject: Re: [PATCH v2] mm/highmem: make kmap cache coloring aware
From: Max Filippov <jcmvbkbc@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        "Linux/MIPS Mailing List" <linux-mips@linux-mips.org>,
        "linux-xtensa@linux-xtensa.org" <linux-xtensa@linux-xtensa.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>,
        Chris Zankel <chris@zankel.net>, Marc Gauthier <marc@cadence.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

thanks for your feedback, I'll address your points in the next version of this
series.

On Thu, Jul 24, 2014 at 1:17 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> Fifthly, it would be very useful to publish the performance testing
> results for at least one architecture so that we can determine the
> patchset's desirability.  And perhaps to motivate other architectures
> to implement this.

What sort of performance numbers would be relevant?
For xtensa this patch enables highmem use for cores with aliasing cache,
that is access to a gigabyte of memory (typical on KC705 FPGA board) vs.
only 128MBytes of low memory, which is highly desirable. But performance
comparison of these two configurations seems to make little sense.
OTOH performance comparison of highmem variants with and without
cache aliasing would show the quality of our cache flushing code.

-- 
Thanks.
-- Max

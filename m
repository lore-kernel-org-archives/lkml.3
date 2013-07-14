Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093Ab3GNA1L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 20:27:11 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:62594 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903Ab3GNA1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 20:27:10 -0400
Message-ID: <51E1F056.3000108@gmail.com>
Date: Sun, 14 Jul 2013 08:27:02 +0800
From: Sam Ben <sam.bennn@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Colin Cross <ccross@google.com>
CC: lkml <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: RFC: named anonymous vmas
References: <CAMbhsRQU=xrcum+ZUbG3S+JfFUJK_qm_VB96Vz=PpL=vQYhUvg@mail.gmail.com>
In-Reply-To: <CAMbhsRQU=xrcum+ZUbG3S+JfFUJK_qm_VB96Vz=PpL=vQYhUvg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Colin,
On 06/22/2013 07:42 AM, Colin Cross wrote:
> One of the features of ashmem (drivers/staging/android/ashmem.c) that
> hasn't gotten much discussion about moving out of staging is named
> anonymous memory.
>
> In Android, ashmem is used for three different features, and most
> users of it only care about one feature at a time.  One is volatile
> ranges, which John Stultz has been implementing.  The second is
> anonymous shareable memory without having a world-writable tmpfs that
> untrusted apps could fill with files.  The third and most heavily used

How to understand "anonymous shareable memory without having a 
world-writable tmpfs that untrusted apps could fill with files"?

> feature within the Android codebase is named anonymous memory, where a
> region of anonymous memory can have a name associated with it that
> will show up in /proc/pid/maps.  The Dalvik VM likes to use this
> feature extensively, even for memory that will never be shared and
> could easily be allocated using an anonymous mmap, and even malloc has
> used it in the past.  It provides an easy way to collate memory used
> for different purposes across multiple processes, which Android uses
> for its "dumpsys meminfo" and "librank" tools to determine how much
> memory is used for java heaps, JIT caches, native mallocs, etc.
>
> I'd like to add this feature for anonymous mmap memory.  I propose
> adding an madvise2(unsigned long start, size_t len_in, int behavior,
> void *ptr, size_t size) syscall and a new MADV_NAME behavior, which
> treats ptr as a string of length size.  The string would be copied
> somewhere reusable in the kernel, or reused if it already exists, and
> the kernel address of the string would get stashed in a new field in
> struct vm_area_struct.  Adjacent vmas would only get merged if the
> name pointer matched, and naming part of a mapping would split the
> mapping.  show_map_vma would print the name only if none of the other
> existing names rules match.
>
> Any comments as I start implementing it?  Is there any reason to allow
> naming a file-backed mapping and showing it alongside the file name in
> /proc/pid/maps?
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>


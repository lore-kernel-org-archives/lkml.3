Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751687AbaDARwQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 13:52:16 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:57426 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332AbaDARwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 13:52:14 -0400
Message-ID: <533AFCC3.3030504@ahsoftware.de>
Date: Tue, 01 Apr 2014 19:52:03 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@linux-foundation.org>,
        Levente Kurusa <levex@linux.com>, stable@vger.kernel.org
Subject: Re: [PATCH 2/2 v3] initramfs: print error and shell out for unsupported
 content
References: <532CC625.7020509@ahsoftware.de> <1395491361-28069-1-git-send-email-holler@ahsoftware.de> <1395491361-28069-2-git-send-email-holler@ahsoftware.de> <532DD4E7.3070706@ahsoftware.de> <5339D096.4040302@suse.cz> <533AA1A0.10802@ahsoftware.de> <533AAFCB.7060409@suse.cz>
In-Reply-To: <533AAFCB.7060409@suse.cz>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 01.04.2014 14:23, schrieb Michal Marek:
> On 2014-04-01 13:23, Alexander Holler wrote:
>> But as I already said, trying to use arbitrary filenames in a Makefile
>> doesn't really work. There are still other problems, e.g. filenames with
>> a / (directory separator), *, or some of the special make variables like $<.
>>
>> So the really working solution would be to get rid of that generated
>> (and hidden) include. Modifying gen_init_cpio.c to browse and collect
>> all filenames and types itself doesn't look like much work (an evening
>> should be enough).
>>
>> The drawback is that such a solution would build the initramfs every
>> time make is called (while CONFIG_INITRAMFS_SOURCE points to a
>> directory), but I think that time is negligible.
>
> Well, the cpio is embedded in the kernel image, so a rebuild of the cpio
> means a relink of the kernel. One option would be to implement the
> timestamp checking in gen_init_cpio.c, but I'm not sure if that's worth it.

I can't answer that too, but if someone spends the time implement the 
directory traversing and collecting stats, it would just be one stat 
more (to get the timestamp of an maybe already built cpio archive).

But I'm fine with just avoiding the most common problems (in my case 
colons and spaces). And the little patch which makes sure that make 
clean, distclean or mrproper will work always, avoids the need to search 
how to fix the problem (deleting that hidden include) once a broken 
include was generated.

Regards,

Alexander Holler


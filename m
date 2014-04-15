Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757AbaDONGf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 09:06:35 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:52201 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbaDONGc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 09:06:32 -0400
MIME-Version: 1.0
In-Reply-To: <20140415120740.GA8306@nazgul.tnic>
References: <20140415070204.GA4806@pd.tnic>
	<534CFBD7.3070604@amd.com>
	<20140415120740.GA8306@nazgul.tnic>
Date: Tue, 15 Apr 2014 09:06:31 -0400
Message-ID: <CADnq5_PpPa_fbm=1KH__q-W2OuvfoHr2wquimQ8TCq=xwwYq_Q@mail.gmail.com>
Subject: Re: 15-rc1: radeon modesetting fails
From: Alex Deucher <alexdeucher@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Maling list - DRI developers 
	<dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 8:07 AM, Borislav Petkov <bp@alien8.de> wrote:
> Hi Christian,
>
> On Tue, Apr 15, 2014 at 11:28:55AM +0200, Christian König wrote:
>> Hi Borislav,
>>
>> that's a known issue and should be fixed in the next rc, see this
>> bugreport: https://bugs.freedesktop.org/show_bug.cgi?id=77009
>>
>> You might also want to try my branch with 3.15 fixes which includes
>> the necessary patch for this: http://cgit.freedesktop.org/~deathsimple/linux/log/?h=drm-fixes-3.15-wip
>>
>> Let me know if that branch works for you or not.
>
> so I went and merged your branch as you suggested. Btw, on its tip it
> has:
>
> commit ec02666dd0791312b5820e1a9a023681d99d07ec
> Author: Quentin Casasnovas <quentin.casasnovas@oracle.com>
> Date:   Tue Mar 18 17:16:52 2014 +0100
>
>     drm/radeon: memory leak on bo reservation failure. v2
>
> (just checking whether I got the right one)
>
> and, unfortunately, no change - same problem. Let me know if I should
> bisect the subset of 59 radeon patches which went in during the merge
> window...
>
> Btw, just in case, I went and updated radeon firmware in
> /lib/firmware/radeon/ from upstream but it didn't change anything.

Does reverting:
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=32167016076f714f0e35e287fbead7de0f1fb179
fix the issue?  We may need to tweak the pll parameters for older asics.

Alex

>
> Thanks.
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel

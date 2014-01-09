Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551AbaAIOfo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 09:35:44 -0500
Received: from mail-vb0-f44.google.com ([209.85.212.44]:40976 "EHLO
	mail-vb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350AbaAIOfS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 09:35:18 -0500
MIME-Version: 1.0
In-Reply-To: <20140109000735.GA23891@leaf>
References: <b21c9d47bbb72f2134540b852c908a2080f1ed1d.1389018324.git.rashika.kheria@gmail.com>
	<8af55c93ab10b11d473f9c731eddd6710ae7a418.1389018324.git.rashika.kheria@gmail.com>
	<CADnq5_OrzQ+Jr0G6pzLq99ivA7WEc2dnEmY6S3y6FKWwXZ09TA@mail.gmail.com>
	<20140109000735.GA23891@leaf>
Date: Thu, 9 Jan 2014 09:35:15 -0500
Message-ID: <CADnq5_O7S0LPNQ4Z9+m2CeQNcTD-2bAoTd4ru66r=bQF5C+2sQ@mail.gmail.com>
Subject: Re: [PATCH 22/85] drivers: gpu: Mark functions as static in radeon_device.c
From: Alex Deucher <alexdeucher@gmail.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Rashika Kheria <rashika.kheria@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Maling list - DRI developers 
	<dri-devel@lists.freedesktop.org>,
        Jerome Glisse <jglisse@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>,
        =?ISO-8859-1?Q?Christian_K=F6nig?= <christian.koenig@amd.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 8, 2014 at 7:07 PM, Josh Triplett <josh@joshtriplett.org> wrote:
> On Wed, Jan 08, 2014 at 11:40:28AM -0500, Alex Deucher wrote:
>> On Mon, Jan 6, 2014 at 10:21 AM, Rashika Kheria
>> <rashika.kheria@gmail.com> wrote:
>> > Mark functions radeon_doorbell_init() and radeon_doorbell_fini() as
>> > static in drm/radeon/radeon_device.c because they are not used outside
>> > this file.
>> >
>> > This eliminates the following warning in drm/radeon/radeon_device.c:
>> > drivers/gpu/drm/radeon/radeon_device.c:252:5: warning: no previous prototype for ‘radeon_doorbell_init’ [-Wmissing-prototypes]
>> > drivers/gpu/drm/radeon/radeon_device.c:281:6: warning: no previous prototype for ‘radeon_doorbell_fini’ [-Wmissing-prototypes]
>> >
>> > Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
>> > Reviewed-by: Josh Triplett <josh@joshtriplett.org>
>>
>> I've pulled in a subset of these patches:
>> http://cgit.freedesktop.org/~agd5f/linux/log/?h=drm-next-3.14-wip
>> I held off on some of the others as I'd rather fix up the headers
>> properly rather than just cramming everything in radeon.h or
>> radeon-asic.h for now.
>
> Can you elaborate on which patches are putting functions in the wrong
> header, and what header you'd prefer to see them in?

Sure.  atombios.h defines the vbios interface so it shouldn't have any
driver functions defined in it.  radeon_asic.h was only supposed to
include the function definitions for the asic specific callbacks
assigned in radeon_asic.c.  For everything else, I'd rather move to
asic specific headers, e.g., rather than adding r600_*() functions to
radeon.h for example, I'd rather add an r600.h and include that where
r600_*() functions are used, etc.

Thanks,

Alex

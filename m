Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042AbaKJVQ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 16:16:27 -0500
Received: from mail-la0-f42.google.com ([209.85.215.42]:51421 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753019AbaKJVQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 16:16:25 -0500
MIME-Version: 1.0
In-Reply-To: <54606AF7.8070506@amd.com>
References: <1415471865-1893-1-git-send-email-oded.gabbay@amd.com>
	<CAPM=9tyej9J13U0c+-DH-EYw_4JJQbiQM98QREZQLz4PPj+FmQ@mail.gmail.com>
	<54606AF7.8070506@amd.com>
Date: Tue, 11 Nov 2014 07:16:23 +1000
Message-ID: <CAPM=9tyTcgiFqg+DyjzLX82_TV5Pa7wbN0Z_40rfLL5cWT_XKA@mail.gmail.com>
Subject: Re: [PATCH v5 00/24] AMDKFD Kernel Driver
From: Dave Airlie <airlied@gmail.com>
To: Oded Gabbay <oded.gabbay@amd.com>
Cc: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> How does amdkfd interfact with runtime pm on the radeon driver? I'd expect
>> some calls to the runtime get/put functions in some places.
>>
>> Dave.
>>
> Hi Dave,
> Per Jerome's request from the first time he saw the driver, we removed all
> the "register bashing" code from amdkfd and moved them to the interface file
> between amdkfd and radeon, which is part of the radeon driver.
> See "[PATCH v5 05/24] drm/radeon: Add radeon <--> amdkfd interface" for the
> implementation of that interface file.

So in GPU offload mode, how does amdkfd wake the GPU up to execute
stuff?

GPU offload is where the radeon GPU is a secondary GPU and we power it
down automatically.

Granted I think our powerdown should probably check if the GPU is executing
anything a bit more, but I don't think amdkfd can even wake it up to submit
work at the moment.

Dave.

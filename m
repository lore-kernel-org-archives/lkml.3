Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106AbaGINVa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 09:21:30 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37066 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755535AbaGINV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 09:21:28 -0400
Message-ID: <53BD41CE.6000506@canonical.com>
Date: Wed, 09 Jul 2014 15:21:18 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Mike Lothian <mike@fireburn.co.uk>
CC: bskeggs@redhat.com, dri-devel@lists.freedesktop.org,
        christian.koenig@amd.com, alexander.deucher@amd.com, airlied@linux.ie,
        thellstrom@vmware.com, linux-kernel@vger.kernel.org,
        nouveau@lists.freedesktop.org
Subject: Re: [PATCH 00/17] Convert TTM to the new fence interface.
References: <20140709093124.11354.3774.stgit@patser> <CAHbf0-HaFi0px7QGfBErKenH7wDU08B5mxo_QhFJdDPC4WBDrQ@mail.gmail.com>
In-Reply-To: <CAHbf0-HaFi0px7QGfBErKenH7wDU08B5mxo_QhFJdDPC4WBDrQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

op 09-07-14 15:09, Mike Lothian schreef:
> Hi Maarten
>
> Will this stop the stuttering I've been seeing with DRI3 and PRIME? Or will
> other patches / plumbing be required
>
No, that testing was with the whole series including the parts where you synchronized intel with radeon (iirc).
Although it might if lucky, I noticed that I missed a int to long conversion, which resulted in a success being
reported as error, disabling graphics acceleration entirely.

The series here simply convert the drivers to a common fence infrastructure, but shouldn't cause any regressions
or any major behavioral changes. A separate series is needed to make intel and radeon synchronized,
and for that series the support on the intel side is a hack. It should be possible to get the the radeon/nouveau
changes upstreamed, but this conversion is required for that.

~Maarten


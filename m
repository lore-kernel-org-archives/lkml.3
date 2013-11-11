Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589Ab3KKQUC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 11:20:02 -0500
Received: from mail-we0-f176.google.com ([74.125.82.176]:46082 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753897Ab3KKQTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 11:19:51 -0500
MIME-Version: 1.0
In-Reply-To: <cover.1384183054.git.liwang@ubuntukylin.com>
References: <cover.1384183054.git.liwang@ubuntukylin.com>
Date: Mon, 11 Nov 2013 11:19:49 -0500
Message-ID: <CANP1eJE9zGN1ort4DdEdvvG4MVneRnjh+MnrdHkyy==ruEBCnw@mail.gmail.com>
Subject: Re: [PATCH 0/7] Cifs and Ceph: Uncache single no-data page in readpage()
From: Milosz Tanski <milosz@adfin.com>
To: Li Wang <liwang@ubuntukylin.com>
Cc: linux-kernel@vger.kernel.org, ceph-devel <ceph-devel@vger.kernel.org>,
        Sage Weil <sage@inktank.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        linux-cifs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li,

I recommend you CC David Howells who maintains FSCache directly on your emails.

Thanks,
- Milosz

On Mon, Nov 11, 2013 at 10:27 AM, Li Wang <liwang@ubuntukylin.com> wrote:
> Currently, the page allocated into fscache in readpage()
> for Cifs and Ceph does not be uncached if no data read due
> to io error. This patch fixes this. fscache_readpages_cancel()
> is for this kind of job but taking list read * as input, so
> a new routine take page * as input is introduced.
>
> Li Wang (7):
>   Fscache: Introduce new API fscache_readpage_cancel()
>   Fscache: Implement uncaching single no-data page
>   Ceph: Introduce routine for uncaching single no-data page
>   Ceph: Uncaching no-data page in readpage()
>   Cifs: Introduce routine for uncaching single no-data page
>   Cifs: Implement uncaching single no-data page
>   Cifs: Uncaching no-data page in readpage()
>
>  fs/ceph/addr.c          |    1 +
>  fs/ceph/cache.h         |   13 +++++++++++++
>  fs/cifs/file.c          |    4 +++-
>  fs/cifs/fscache.c       |    7 +++++++
>  fs/cifs/fscache.h       |   13 +++++++++++++
>  fs/fscache/page.c       |    8 ++++++++
>  include/linux/fscache.h |   11 +++++++++++
>  7 files changed, 56 insertions(+), 1 deletion(-)
>
> --
> 1.7.9.5
>



-- 
Milosz Tanski
CTO
10 East 53rd Street, 37th floor
New York, NY 10022

p: 646-253-9055
e: milosz@adfin.com

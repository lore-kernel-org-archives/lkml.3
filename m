Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751717AbaHRNHB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 09:07:01 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44187 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbaHRNG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 09:06:59 -0400
Message-ID: <53F1FA6C.2030605@canonical.com>
Date: Mon, 18 Aug 2014 15:06:52 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Sumit Semwal <sumit.semwal@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, devel@driverdev.osuosl.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        John Stultz <john.stultz@linaro.org>, Colin Cross <ccross@google.com>
Subject: Re: [PATCH 1/2] android: fix reference leak in sync_fence_create
References: <53EC8722.4070407@canonical.com> <20140818125719.GA5423@mwanda>
In-Reply-To: <20140818125719.GA5423@mwanda>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

Op 18-08-14 om 14:57 schreef Dan Carpenter:
> On Thu, Aug 14, 2014 at 11:53:38AM +0200, Maarten Lankhorst wrote:
>> According to the documentation sync_fence_create takes ownership of the point,
>> not a reference on the point.
>>
> What are the user visible effects of this bug?  I assume this is a real
> bug but judging solely based on your patch description, it sounds like
> you could just update the documentation instead of changing the code.
>
Small memory leak on every created android fence when you run out of tree android drivers.

But because it happens every frame (or possibly even more often) it's worth fixing.

~Maarten

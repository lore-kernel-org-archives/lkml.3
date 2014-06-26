Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576AbaFZKhA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 06:37:00 -0400
Received: from mailgw1.uni-kl.de ([131.246.120.220]:37718 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbaFZKg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 06:36:58 -0400
Message-ID: <53ABF7C4.1000906@itwm.fraunhofer.de>
Date: Thu, 26 Jun 2014 12:36:52 +0200
From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: dedekind1@gmail.com, Dave Chinner <david@fromorbit.com>
CC: Thomas Knauth <thomas.knauth@gmx.de>, David Rientjes <rientjes@google.com>,
        Maksym Planeta <mcsim.planeta@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysctl: Add a feature to drop caches selectively
References: <1403626213-7691-1-git-send-email-mcsim.planeta@gmail.com>	 <alpine.DEB.2.02.1406241458140.29176@chino.kir.corp.google.com>	 <1403677528.7903.103.camel@sauron.fi.intel.com>	 <CABhLV03_PNFiwsvt+yitcsKxz5TeVECCFavdNkbgQ+XzQqASaw@mail.gmail.com>	 <20140626010606.GT4453@dastard> <1403763199.20275.39.camel@sauron.fi.intel.com>
In-Reply-To: <1403763199.20275.39.camel@sauron.fi.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ITWM-CharSet: UTF-8
X-ITWM-Scanned-By: mail2.itwm.fhg.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2014 08:13 AM, Artem Bityutskiy wrote:
> On Thu, 2014-06-26 at 11:06 +1000, Dave Chinner wrote:
>> Your particular use case can be handled by directing your benchmark
>> at a filesystem mount point and unmounting the filesystem in between
>> benchmark runs. There is no ned to adding kernel functionality for
>> somethign that can be so easily acheived by other means, especially
>> in benchmark environments where *everything* is tightly controlled.
>
> If I was a benchmark writer, I would not be willing running it as root
> to be able to mount/unmount, I would not be willing to require the
> customer creating special dedicated partitions for the benchmark,
> because this is too user-unfriendly. Or do I make incorrect assumptions?

But why a sysctl then? And also don't see a point for that at all, why 
can't the benchmark use posix_fadvise(POSIX_FADV_DONTNEED)?


Cheers,
Bernd



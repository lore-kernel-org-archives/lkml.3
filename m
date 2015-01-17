Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582AbbAQAd2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 19:33:28 -0500
Received: from svenfoo.org ([82.94.215.22]:60196 "EHLO mail.zonque.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752097AbbAQAd1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 19:33:27 -0500
X-Greylist: delayed 406 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Jan 2015 19:33:26 EST
Message-ID: <54B9AC3E.9070105@zonque.org>
Date: Sat, 17 Jan 2015 01:26:38 +0100
From: Daniel Mack <daniel@zonque.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Josh Boyer <jwboyer@fedoraproject.org>
CC: Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Tom Gundersen <teg@jklm.no>, Jiri Kosina <jkosina@suse.cz>,
        Andy Lutomirski <luto@amacapital.net>, linux-api@vger.kernel.org,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        David Herrmann <dh.herrmann@gmail.com>, tixxdz@opendz.org
Subject: Re: [PATCH v3 00/13] Add kdbus implementation
References: <1421435777-25306-1-git-send-email-gregkh@linuxfoundation.org> <CA+5PVA7idthaLM_VTLdLEU=z=mbYnEkdQOSGSXqdJHJTNAHkzA@mail.gmail.com> <20150116221824.GA512@kroah.com>
In-Reply-To: <20150116221824.GA512@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Josh,

On 01/16/2015 11:18 PM, Greg Kroah-Hartman wrote:
> On Fri, Jan 16, 2015 at 05:07:25PM -0500, Josh Boyer wrote:
>> The code.google.com tree has commits
>> from 2 days ago, but it still calls d_materialise_unique in fs.c
>> whereas the patchset you've posted uses the correct d_splice_alias.
>> So the code.google.com tree doesn't actually compile against 3.19-rcX.
>>
>> I'm confused where we're supposed to track things now.

The code.google.com repository is where we do all the development, and
the code is made to build external kernel modules for 3.18. The patches
sent in this series are meant for 3.19 and 3.20 kernels, and while they
are based on the exact same sources, the patches differ in the following
minor details:

 * Code is moved to appropriate locations, such as ipc/kdbus,
   include/uapi, tools/testing/selftests/kdbus/, Documentation/ etc.

 * Include file location amendments, "kdbus.h" vs. <uapi/linux/kdbus.h>

 * Added iov_iter_kvec() usage, as that's a new API in v3.19

 * The file system magic number is moved to include/uapi/linux/magic.h

 * d_materialise_unique() is renamed to d_splice_alias() to catch up
   with changes in 3.19


The commit this patch set is based on is tagged as "lkml-v3" in the
upstream repository now.


Thanks,
Daniel


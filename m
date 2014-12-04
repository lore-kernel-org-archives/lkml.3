Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932325AbaLDPlo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 10:41:44 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55805 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754717AbaLDPln (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 10:41:43 -0500
Message-ID: <548080B5.2000307@suse.cz>
Date: Thu, 04 Dec 2014 16:41:41 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: j.glisse@gmail.com, linux-kernel@vger.kernel.org
CC: =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>
Subject: Re: [PATCH] scripts/package: binrpm-pkg do not create source and
 devel package v3
References: <1417553159-11632-1-git-send-email-j.glisse@gmail.com>
In-Reply-To: <1417553159-11632-1-git-send-email-j.glisse@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-12-02 21:45, j.glisse@gmail.com wrote:
> From: Jérôme Glisse <jglisse@redhat.com>
> 
> When doing make binrpm-pkg we only want to build the binary and header
> package as the documentation of binrpm-pkg target claims. Hence this
> patch avoid building the source and devel package. This makes binrpm-pkg
> target lot faster and way more usefull.
> 
> Changed since v2 :
>   - Avoid symlinks in /usr/src/kernel.
>   - Update subject line and changelog.

Thanks, much better!


>  echo 'rm -f $RPM_BUILD_ROOT'"/lib/modules/$KERNELRELEASE/{build,source}"
>  echo "mkdir -p "'$RPM_BUILD_ROOT'"/usr/src/kernels/$KERNELRELEASE"

One last nitpick, then I'll merge the patch (promise!) -- the
/usr/src/kernels/$KERNELRELEASE directory is not needed and in fact the
rm -f above is also irrelevant. So please wrap the whole block in if !
$PREBUILT.

Thanks,
Michal

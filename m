Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960AbaFPJSj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 05:18:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53679 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754551AbaFPJSi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 05:18:38 -0400
Message-ID: <539EB66B.7020402@suse.cz>
Date: Mon, 16 Jun 2014 11:18:35 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Ilya Dryomov <idryomov@gmail.com>
CC: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Regression: make O=... deb-pkg broken in 3.16
References: <CAOi1vP9YvbroujXEut6Xn-tvv07MNuxanwDrRvDFhS_-HT_5Lg@mail.gmail.com>
In-Reply-To: <CAOi1vP9YvbroujXEut6Xn-tvv07MNuxanwDrRvDFhS_-HT_5Lg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-06-15 12:51, Ilya Dryomov wrote:
> Hi Michal,
> 
> Your relative path changes in the first kbuild pull request for 3.16
> broke make O=...  deb-pkg.
> 
> /home/ubuntu/foo/linux-a/scripts/package/builddeb: line 291:
> ./debian/hdrsrcfiles: No such file or directory
> 
> 290 # Build header package
> 291 (cd $srctree; find . -name Makefile\* -o -name Kconfig\* -o -name
> \*.pl > "$objtree/debian/hdrsrcfiles")
> 292 (cd $srctree; find arch/$SRCARCH/include include scripts -type f
>>> "$objtree/debian/hdrsrcfiles")
> 
> The $objtree passed in is a '.' and hence the hdrsrcfiles path is
> interpreted relative to the $srctree, which, if building with O=,
> doesn't have a 'debian' directory.

Thanks for the report, I'll have a look.

Michal

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751414AbaIXEvO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 00:51:14 -0400
Received: from mga02.intel.com ([134.134.136.20]:22204 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751201AbaIXEvM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 00:51:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,586,1406617200"; 
   d="scan'208";a="607598430"
From: ashutosh dixit <ashutosh.dixit@intel.com>
To: Peter Foley <pefoley2@pefoley.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc\@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "Dutt\, Sudeep" <sudeep.dutt@intel.com>,
        "Rao\, Nikhil" <nikhil.rao@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH linux-next] Documentation: mic: mpssd: Disable mpssd builds for kernels < 3.13
References: <c6aff784285e77771ad4edd3d451d95529bfb17d.1411496575.git.ashutosh.dixit@intel.com>
	<5421EA22.6000206@infradead.org>
	<ndhwbqvboe9c48.fsf@rasscmlmus001.pdx.intel.com>
	<CAOFdcFMLYJ9qqRB-uwyLwyBpa=KTsHMbzdANJrmRu_wrqNArOA@mail.gmail.com>
	<20140923163816.2f3cf938c7815424e55e444f@linux-foundation.org>
	<CAOFdcFMiqS6-QFUo-QbwroOMmXnUL5mJd=Pjei_RjT3mhO8P5g@mail.gmail.com>
	<20140923175137.aa87c1ea.akpm@linux-foundation.org>
	<CAOFdcFOG0hfeUZz6QkjgfAYbsFN3uVHgSn25hWqwtd6bNU0d5A@mail.gmail.com>
Date: Tue, 23 Sep 2014 21:51:09 -0700
In-Reply-To: <CAOFdcFOG0hfeUZz6QkjgfAYbsFN3uVHgSn25hWqwtd6bNU0d5A@mail.gmail.com>
	(Peter Foley's message of "Tue, 23 Sep 2014 18:58:19 -0600")
Message-ID: <ndhwbqd2alaaf6.fsf@rasscmlmus001.pdx.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23 2014 at 05:58:19 PM, Peter Foley <pefoley2@pefoley.com> wrote:
> On Tue, Sep 23, 2014 at 8:51 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
>> Can't we just fix the Makefiles?  Cook up a rule which makes
>> headers_install (if needed) before building Documentation/?
>
> Currently, the ordering is enforced by
> http://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/tree/Makefile#n946
> I'll take a look at making Documentation/ depend on headers_install.
>
I would think it is preferable to keep the 'make headers_install' and
'make Documentation/' steps separate, as they currently are, so that
only the people who need to upgrade system headers do that, rather than
forcing people to upgrade system headers each time something in
Documentation/ is recompiled and moreover doing that compile/install as
root.

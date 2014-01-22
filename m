Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932AbaAVBbj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 20:31:39 -0500
Received: from mga02.intel.com ([134.134.136.20]:9264 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754507AbaAVBbh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 20:31:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,697,1384329600"; 
   d="scan'208";a="442616255"
From: "Drokin, Oleg" <oleg.drokin@intel.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: "Dilger, Andreas" <andreas.dilger@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Peng Tao <tao.peng@emc.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Marek Szyprowski" <m.szyprowski@samsung.com>
Subject: Re: [PATCH] staging: lustre: fix GFP_ATOMIC macro usage
Thread-Topic: [PATCH] staging: lustre: fix GFP_ATOMIC macro usage
Thread-Index: AQHPE2C8z70eL8jSIUCfqXMMm5K1JJqJgYiAgAAFBgCAAAdMgIAFWv6AgAFBt4CAAFgqAA==
Date: Wed, 22 Jan 2014 01:31:34 +0000
Message-ID: <FEF2568E-0250-434D-9D1C-E3BB3F970762@intel.com>
References: <1389948416-26390-1-git-send-email-m.szyprowski@samsung.com>
 <20140117143329.GA6877@kroah.com> <20140117145128.GR7444@mwanda>
 <20140117151735.GB16623@kroah.com> <CF037522.8B804%andreas.dilger@intel.com>
 <20140121201601.GZ7444@mwanda>
In-Reply-To: <20140121201601.GZ7444@mwanda>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.12.20]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BCF316BECE60304E876AD0D1F576B47F@intel.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

On Jan 21, 2014, at 3:16 PM, Dan Carpenter wrote:

> We have a leak checker in the kernel but most people disable it.  I
> forget the config name.  There are a bunch of useful debug configs.

I actually use it at times too and it's useful (e.g. it works even if you did not wrap the allocation in the lustre macro, and this did happen before),
but it comes with it's own problems.
E.g. it gobbles on memory like there's no tomorrow (at least in my case), it has horrible false failure ratio with zfs in place (and probably
that's why it uses even more memory then), it has otherwise quite significant failure ratio too.
But yes, it is useful and I am glad it's there. It does not solve some other usecases outlined by Andreas, though.

Bye,
    Oleg
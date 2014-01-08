Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526AbaAHA5g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 19:57:36 -0500
Received: from mga09.intel.com ([134.134.136.24]:37363 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753627AbaAHA5a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 19:57:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,621,1384329600"; 
   d="scan'208";a="455152024"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Jeff Liu <jeff.liu@oracle.com>,
        "dchinner@redhat.com" <dchinner@redhat.com>,
        "bpm@sgi.com" <bpm@sgi.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xfs@oss.sgi.com" <xfs@oss.sgi.com>
Subject: RE: [PATCH 2/3] xfs: Calling destroy_work_on_stack() to pair with
 INIT_WORK_ONSTACK()
Thread-Topic: [PATCH 2/3] xfs: Calling destroy_work_on_stack() to pair with
 INIT_WORK_ONSTACK()
Thread-Index: AQHPC5qYQmjzfqd2qEutZ7QADabuJZp5/4og
Date: Wed, 8 Jan 2014 00:57:26 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A01BED1C3@SHSMSX101.ccr.corp.intel.com>
References: <1389084605.3650.66.camel@cliu38-desktop-build>
 <1389084814.3650.70.camel@cliu38-desktop-build> <52CBE321.4050906@oracle.com>
In-Reply-To: <52CBE321.4050906@oracle.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jeff,

> -----Original Message-----
> From: Jeff Liu [mailto:jeff.liu@oracle.com]
> Sent: Tuesday, January 07, 2014 7:21 PM
> To: Liu, Chuansheng; dchinner@fromorbit.com; bpm@sgi.com
> Cc: linux-kernel@vger.kernel.org; xfs@oss.sgi.com
> Subject: Re: [PATCH 2/3] xfs: Calling destroy_work_on_stack() to pair with
> INIT_WORK_ONSTACK()
> 
> Hi Chuansheng,
> 
> On 01/07 2014 16:53 PM, Chuansheng Liu wrote:
> >
> > In case CONFIG_DEBUG_OBJECTS_WORK is defined, it is needed to
> > call destroy_work_on_stack() which frees the debug object to pair
> > with INIT_WORK_ONSTACK().
> >
> > Signed-off-by: Liu, Chuansheng <chuansheng.liu@intel.com>
> > ---
> Thanks for your patch and it work fine for my testing.  I missed this in an
> old commit: [ 3b876c8f2a xfs: fix debug_object WARN at xfs_alloc_vextent() ]
Thanks your testing.

> 
> Just out of curious, do you notice memory leaks or other hints which help you
> finding out this problem?
I am trying to use the INIT_WORK_ONSTACK() in my code, then I found in some places
Calling destroy_work_on_stack() is missed.


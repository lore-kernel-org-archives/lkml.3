Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759654Ab3EOQyO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 12:54:14 -0400
Received: from sentry-two.sandia.gov ([132.175.109.14]:48534 "EHLO
	sentry-two.sandia.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758319Ab3EOQyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 12:54:12 -0400
X-WSS-ID: 0MMUMY9-0B-0OO-02
X-M-MSG: 
X-Server-Uuid: AF72F651-81B1-4134-BA8C-A8E1A4E620FF
Message-ID: <5193BD96.1000005@sandia.gov>
Date: Wed, 15 May 2013 10:53:42 -0600
From: "Jim Schutt" <jaschut@sandia.gov>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402
 Thunderbird/17.0.5
MIME-Version: 1.0
To: "Alex Elder" <elder@inktank.com>
cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] ceph: ceph_pagelist_append might sleep while
 atomic
References: <1368635894-114707-1-git-send-email-jaschut@sandia.gov>
 <1368635894-114707-4-git-send-email-jaschut@sandia.gov>
 <5193BC89.6030807@inktank.com>
In-Reply-To: <5193BC89.6030807@inktank.com>
X-TMWD-Spam-Summary: TS=20130515165346; ID=1; SEV=2.3.1;
 DFV=B2013022509; IFV=NA; AIF=B2013022509; RPD=5.03.0010; ENG=NA;
 RPDID=7374723D303030312E30413031303230332E35313933424439412E303036463A534346535441543838363133332C73733D312C6667733D30;
 CAT=NONE; CON=NONE; SIG=AAABAJsKIgAAAAAAAAAAAAAAAAAAAH0=
X-MMS-Spam-Filter-ID: B2013022509_5.03.0010
X-WSS-ID: 7D8D621D2IW2831081-01-01
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-RSA-Inspected: yes
X-RSA-Classifications: public
X-RSA-Action: allow
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2013 10:49 AM, Alex Elder wrote:
> On 05/15/2013 11:38 AM, Jim Schutt wrote:
>> > Ceph's encode_caps_cb() worked hard to not call __page_cache_alloc() while
>> > holding a lock, but it's spoiled because ceph_pagelist_addpage() always
>> > calls kmap(), which might sleep.  Here's the result:
> This looks good to me, but I admit I didn't take as close
> a look at it this time.
> 
> I appreciate your updating the series to include the things
> I mentioned.
> 
> I'll commit these for you, and I'll get confirmation on the
> byte order thing as well.

Cool.  Thanks, Alex.

-- Jim

> 
> Reviewed-by: Alex Elder <elder@inktank.com>
> 
> 



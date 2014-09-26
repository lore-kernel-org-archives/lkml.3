Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557AbaIZI5i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 04:57:38 -0400
Received: from bay004-omc2s26.hotmail.com ([65.54.190.101]:58523 "EHLO
	BAY004-OMC2S26.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752170AbaIZI5e convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 04:57:34 -0400
X-Greylist: delayed 306 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Sep 2014 04:57:34 EDT
X-TMN: [9eSrM1AnY5MnjnnEE8wGjo6Fhm4xdqm9Vxsm8kidpSI=]
X-Originating-Email: [pintu.k@outlook.com]
Message-ID: <BAY169-W38291C97E5E42E5DCA8787EFBF0@phx.gbl>
From: Pintu Kumar <pintu.k@outlook.com>
To: "mgorman@suse.de" <mgorman@suse.de>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        PINTU KUMAR <pintu_agarwal@yahoo.com>,
        "pintu.k@samsung.com" <pintu.k@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Changing PAGE_ALLOC_COSTLY_ORDER from 3 to 2
Date: Fri, 26 Sep 2014 14:22:27 +0530
Importance: Normal
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 26 Sep 2014 08:52:28.0276 (UTC) FILETIME=[334FCB40:01CFD967]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I wanted to know about the impact of changing PAGE_ALLOC_COSTLY_ORDER value from 3 to 2.
This macro is defined in include/linux/mmzone.h
#define PAGE_ALLOC_COSTLY_ORDER   3

As I know this value should never be changed irrespective of the type of the system.
Is it good to change this value for RAM size: 512MB, 256MB or 128MB?
If anybody have changed this value and experience any kind of problem or benefits please let us know.

We noticed that for one of the Android product with 512MB RAM, the PAGE_ALLOC_COSTLY_ORDER was set to 2.
We could not figure out why this value was decreased from 3 to 2.

As per my analysis, I observed that kmalloc fails little early, if we change this value to 2.
This is also visible from the _slowpath_ in page_alloc.c

Apart from this we could not find any other impact.
If anybody is aware of any other impact, please let us know.



Thank you!
Regards,
Pintu Kumar

 		 	   		  
Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934219Ab3IDBAM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 21:00:12 -0400
Received: from mga03.intel.com ([143.182.124.21]:56295 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934084Ab3IDBAK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 21:00:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,1017,1367996400"; 
   d="scan'208";a="290497695"
From: "Nelson, Shannon" <shannon.nelson@intel.com>
To: Joe Perches <joe@perches.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
CC: "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [E1000-devel] [PATCH 0/4] i40e: Neatening and object size
 reductions
Thread-Topic: [E1000-devel] [PATCH 0/4] i40e: Neatening and object size
 reductions
Thread-Index: AQHOpdX1NRXzP6/TyEu240MAQhoiJZm0lXnQ
Date: Wed, 4 Sep 2013 01:00:01 +0000
Message-ID: <FC41C24E35F18A40888AACA1A36F3E416C61C0E5@FMSMSX102.amr.corp.intel.com>
References: <cover.1377903831.git.joe@perches.com>
In-Reply-To: <cover.1377903831.git.joe@perches.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.200.107]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Joe Perches [mailto:joe@perches.com]
> Sent: Friday, August 30, 2013 4:06 PM
> 
> Just some potential cleanings...

>   i40e: Whitespace cleaning

Hmmm, we hadn't noticed the new experimental "--fix" option before.  There are a lot of good suggestions there, but obviously it needs a lot of reading and tweaking before it can be used.  There are cases here where function call parameters are adjusted to line up with the opening '(' but that pushes the parameter(s) beyond 80 columns - we're trying to stay within the 80 column line and checkpatch clean.  Also, there are several where the first continued parameter line indent is changed but the next line or two are not.

We'll spend time going through these and try to take care of what makes sense.

>   i40e: Add and use pf_<level>

We had considered this kind of macro awhile ago, but nixed it for a few different reasons, but primarily because it seems like yet-another-print-macro and not necessarily worth the effort.

>   i40e: pf_<level> remove "%s: " ... __func__

We're beginning to remove many of the __func__ uses, so these prints are no longer all doing the __func__ thing.  We originally had them there for early development and debugging and are currently removing them from the normal path messages.

>   i40e: Convert pf_<level> macros to functions

Doesn't this create a problem with polluting the kernel namespace?  These don't apply to any other driver.  I suppose we could lessen the namespace problem with i40e_ prefix, but I'm still not sold on it.  I suspect we can still get much of the text savings replacing the __func__ with __builtin_return_address(0) where needed, and remove them where no longer needed.  Does that work for you? 

>   i40e: Fix 32 bit shift compilation warnings

Sure.

sln




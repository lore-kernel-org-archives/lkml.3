Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590AbaHLB7K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 21:59:10 -0400
Received: from mga14.intel.com ([192.55.52.115]:52101 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750959AbaHLB7I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 21:59:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="371145496"
From: "Drokin, Oleg" <oleg.drokin@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: Benedict Boerger <benedict.boerger@cs.tu-dortmund.de>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>,
        "<devel@driverdev.osuosl.org>" <devel@driverdev.osuosl.org>,
        "Dilger, Andreas" <andreas.dilger@intel.com>
Subject: Re: [PATCH] drivers: staging: lustre: fix sparse warnings / delete
 unused function
Thread-Topic: [PATCH] drivers: staging: lustre: fix sparse warnings / delete
 unused function
Thread-Index: AQHPsyWZlmkhRekHbkOzjFiDAJeH9JvJt92AgAL5FoA=
Date: Tue, 12 Aug 2014 01:58:45 +0000
Message-ID: <4F91D9A1-B87D-498F-8089-7008F6BD4F30@intel.com>
References: <1407515182-24287-1-git-send-email-benedict.boerger@cs.tu-dortmund.de>
 <20140810043443.GA12200@kroah.com>
In-Reply-To: <20140810043443.GA12200@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.254.188.74]
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <A4934B15A8B37343A55DFC10FD4CB560@intel.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 10, 2014, at 12:34 AM, Greg KH wrote:
> Very odd, with this patch applied, I now get a build warning:
> 
> drivers/staging/lustre/lnet/lnet/config.c: In function ‘lnet_parse_ip2nets’:
> drivers/staging/lustre/lnet/lnet/config.c:1193:2: warning: ‘ipaddrs’ may be used uninitialized in this function [-Wmaybe-uninitialized]
>  lnet_ipaddr_free_enumeration(ipaddrs, nip);
>  ^

What's even more odd is that the very previous line also uses ipaddrs, yet it does not trigger the warning.
In any case I believe it's a false positive, since the only way it could remain unitialized is if
libcfs_ipif_enumerate returned negative value (stored in nif in this function) and we check for it being more than zero
before getting to that part of code.

I'll submit a patch assigning ipaddrs to NULL as a workaround shortly.

Bye,
    Oleg
Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825AbaHLCDL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 22:03:11 -0400
Received: from linuxhacker.ru ([217.76.32.60]:34387 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753121AbaHLCDJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 22:03:09 -0400
Subject: Re: [PATCH] drivers: staging: lustre: fix sparse warnings / delete unused function
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=windows-1252
From: Oleg Drokin <green@linuxhacker.ru>
In-Reply-To: <4F91D9A1-B87D-498F-8089-7008F6BD4F30@intel.com>
Date: Mon, 11 Aug 2014 22:02:54 -0400
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Benedict Boerger <benedict.boerger@cs.tu-dortmund.de>,
        <linux-kernel@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        <andreas.dilger@intel.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <1A7F74DC-3922-4626-BDDF-E8E6C90C221C@linuxhacker.ru>
References: <1407515182-24287-1-git-send-email-benedict.boerger@cs.tu-dortmund.de> <20140810043443.GA12200@kroah.com> <4F91D9A1-B87D-498F-8089-7008F6BD4F30@intel.com>
To: Oleg Drokin <oleg.drokin@intel.com>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 11, 2014, at 9:58 PM, Oleg Drokin wrote:

> 
> On Aug 10, 2014, at 12:34 AM, Greg KH wrote:
>> Very odd, with this patch applied, I now get a build warning:
>> 
>> drivers/staging/lustre/lnet/lnet/config.c: In function ‘lnet_parse_ip2nets’:
>> drivers/staging/lustre/lnet/lnet/config.c:1193:2: warning: ‘ipaddrs’ may be used uninitialized in this function [-Wmaybe-uninitialized]
>> lnet_ipaddr_free_enumeration(ipaddrs, nip);
>> ^
> 
> What's even more odd is that the very previous line also uses ipaddrs, yet it does not trigger the warning.
> In any case I believe it's a false positive, since the only way it could remain unitialized is if
> libcfs_ipif_enumerate returned negative value (stored in nif in this function) and we check for it being more than zero
> before getting to that part of code.
> 
> I'll submit a patch assigning ipaddrs to NULL as a workaround shortly.

Err, looking at the wrong function there, it's lnet_ipaddr_enumerate that returns negative if ipaddrs was not changed.
Anyway still false positive.


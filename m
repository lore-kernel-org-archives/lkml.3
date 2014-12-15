Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750882AbaLOSvM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 13:51:12 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:32983 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbaLOSvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 13:51:08 -0500
Date: Mon, 15 Dec 2014 10:51:04 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Andy Whitcroft <apw@canonical.com>
Cc: KY Srinivasan <kys@microsoft.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "mcb30@ipxe.org" <mcb30@ipxe.org>
Subject: Re: [PATCH V3 1/1] Drivers: hv: vmbus: Fix a bug in
 vmbus_establish_gpadl()
Message-ID: <20141215185104.GA25345@hudson.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	Andy Whitcroft <apw@canonical.com>,
	KY Srinivasan <kys@microsoft.com>,
	"gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"olaf@aepfle.de" <olaf@aepfle.de>,
	"jasowang@redhat.com" <jasowang@redhat.com>,
	"mcb30@ipxe.org" <mcb30@ipxe.org>
References: <1418260380-8774-1-git-send-email-kys@microsoft.com>
 <20141211021019.GA5648@hudson.localdomain>
 <BY2PR0301MB0711EC29782DB872564AB81AA06F0@BY2PR0301MB0711.namprd03.prod.outlook.com>
 <20141215075919.GA12088@newt.localdomain>
 <20141215154704.GA5259@bark>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141215154704.GA5259@bark>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy,

On Mon, Dec 15, 2014 at 03:47:04PM +0000, Andy Whitcroft wrote:
> On Sun, Dec 14, 2014 at 11:59:19PM -0800, Jeremiah Mahler wrote:
[...]
> 
> The calculation appears identical to my reading, the original form was:
> 
>   next_gpadl_handle = atomic_read(&vmbus_connection.next_gpadl_handle);
>   atomic_inc(&vmbus_connection.next_gpadl_handle);
> 
> or:
> 
>   y = x;
>   x++;
> 
> so y == x' (x before incrementing)
> 
> the new code is:
> 
>   next_gpadl_handle = (atomic_inc_return(&vmbus_connection.next_gpadl_handle) - 1);
> 
> or:
> 
>   y = ++x - 1;
> 
> Also making y = x' (x before incrementing)
> 
> -apw

Ah, you are right.  The increment before/after messed me up.

Thanks for clearing that up for me :-)

-- 
- Jeremiah Mahler

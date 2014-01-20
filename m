Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093AbaATMbL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 07:31:11 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:31982 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560AbaATMbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 07:31:07 -0500
Date: Mon, 20 Jan 2014 15:30:46 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: James Hogan <james.hogan@imgtec.com>
Cc: Chen Gang <gang.chen.5i5j@gmail.com>, devel@driverdev.osuosl.org,
        andreas.dilger@intel.com, Greg KH <gregkh@linuxfoundation.org>,
        bergwolf@gmail.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        oleg.drokin@intel.com, jacques-charles.lafoucriere@cea.fr,
        jinshan.xiong@intel.com, linux-metag@vger.kernel.org
Subject: Re: [PATCH] drivers: staging: lustre: lustre: include: add
 "__attribute__((packed))" for the related union
Message-ID: <20140120123045.GV7444@mwanda>
References: <52DA4E6A.1000308@gmail.com>
 <20140118100547.GS7444@mwanda>
 <52DA56C2.5010802@gmail.com>
 <20140118142404.GT7444@mwanda>
 <52DBA3D4.3090308@gmail.com>
 <52DD0EFF.2010305@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52DD0EFF.2010305@imgtec.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ah.  From so metag is a new arch and not a compiler like the changelog
says.

On Mon, Jan 20, 2014 at 11:56:47AM +0000, James Hogan wrote:
> struct a {
> 	struct b {
> 		unsigned int x;
> 		unsigned short y;
> 	} x;
> 	unsigned short y;
> } __packed;

This is not the code we are discussing.  It should look like:

struct a {
	union {
		short x;
		short y;
	}
	short z;
};

Any normal person would assume that sizeof(struct a) would be 4 but
apparently on metag it is 8.  That totally defeats the point of using
a union in the first place.  It's easy enough to add a __packed to the
lustre declaration but I expect this to cause an endless stream of bugs.

It it is really stupid.

regards,
dan carpenter


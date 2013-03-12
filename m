Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933166Ab3CLQcz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 12:32:55 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:50006 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933109Ab3CLQcy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 12:32:54 -0400
Message-ID: <1363105973.2125.11.camel@joe-AO722>
Subject: Re: [PATCH 12/18] driver: scsi: remove cast for kmalloc/kzalloc
 return value
From: Joe Perches <joe@perches.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 12 Mar 2013 09:32:53 -0700
In-Reply-To: <1363080469.2401.26.camel@dabdike.int.hansenpartnership.com>
References: <513EB23D.7020303@cn.fujitsu.com>
	 <513EBC2F.6030601@cn.fujitsu.com>
	 <1363080469.2401.26.camel@dabdike.int.hansenpartnership.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-03-12 at 09:27 +0000, James Bottomley wrote:
> On Tue, 2013-03-12 at 13:25 +0800, Zhang Yanfei wrote:
> > remove cast for kmalloc/kzalloc return value.
> 
> I've got to ask why?  Just because void * can be assigned to any pointer
> doesn't mean we should religiously eliminate all casts of void *.  If
> the driver writer believes there's value making sure of the pointer
> type, I'm happy to keep the cast.

This view is why scsi has many different styles
instead of a more consistent kernel style.

For the cciss/hpsa example shown:

Do you suggest indirecting structs with typedefs like
BIG_IOCTL_Command_struct is a good thing as well
because the driver writer thinks it so?



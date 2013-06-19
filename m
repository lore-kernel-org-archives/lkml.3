Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935038Ab3FSR6N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 13:58:13 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:39890 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933869Ab3FSR6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 13:58:08 -0400
Date: Wed, 19 Jun 2013 19:57:58 +0200
From: Alessandro Rubini <rubini@gnudd.com>
To: joe@perches.com
Cc: dan.carpenter@oracle.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch -next] FMC: NULL dereference on allocation failure
Message-ID: <20130619175758.GA23533@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
In-Reply-To: <1371658504.2038.25.camel@joe-AO722>
References: <1371658504.2038.25.camel@joe-AO722>
  <20130619160101.GA29108@mwanda>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> +	arr->record = kzalloc(sizeof(arr->record[0]) * n, GFP_KERNEL);
>> +	arr->subtree = kzalloc(sizeof(arr->subtree[0]) * n, GFP_KERNEL);

> n comes from the hardware no?

Yes. Length of hardware description array.

> Maybe make these kcalloc too.

I'm not a fan of kcalloc. I think it removes readability. I remeber
kernel patches to swap the arguments, because people get them wrong.
Even Kernighan said it was a design error (in "the practice of
programming").  That said, I'm not the leader here.

thanks
/alessandro

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753AbaCFTt4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 14:49:56 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35113 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbaCFTtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 14:49:55 -0500
Date: Thu, 6 Mar 2014 11:51:42 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "Maxin B. John" <maxin.john@gmail.com>, devel@driverdev.osuosl.org,
        andreas.dilger@intel.com, bergwolf@gmail.com,
        alexey.zhuravlev@intel.com, linux-kernel@vger.kernel.org,
        dulshani.gunawardhana89@gmail.com, josh@joshtriplett.org,
        jinshan.xiong@intel.com, "Maxin B. John" <maxin.john@enea.com>
Subject: Re: [PATCH 1/2] lustre/mdc_lib: fix possible null pointer dereference
Message-ID: <20140306195142.GA3403@kroah.com>
References: <1394024676-35160-1-git-send-email-maxin.john@enea.com>
 <20140305185048.GC26722@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140305185048.GC26722@mwanda>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2014 at 09:53:06PM +0300, Dan Carpenter wrote:
> On Wed, Mar 05, 2014 at 02:04:35PM +0100, Maxin B. John wrote:
> > From: "Maxin B. John" <maxin.john@enea.com>
> > 
> > cppcheck reported possible null pointer dereference in mdc_lib.c
> > 
> > [lustre/lustre/mdc/mdc_lib.c:233]: (error) Possible null pointer dereference
> > : op_data - otherwise it is redundant to check if op_data is null at line 226
> > 
> 
> There is only one caller and "op_data" is not NULL.

I agree, John, please fix your tools.  Or check the result and fix the
code so that there isn't false-positives (by not checking for NULL at
all here...)

thanks,

greg k-h

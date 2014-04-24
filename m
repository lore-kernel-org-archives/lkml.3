Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758582AbaDXWb2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 18:31:28 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:30877 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755353AbaDXWbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 18:31:24 -0400
Date: Fri, 25 Apr 2014 01:30:59 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: KY Srinivasan <kys@microsoft.com>
Cc: Andev <debiandev@gmail.com>, "olaf@aepfle.de" <olaf@aepfle.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH V1 net-next 1/1] hyperv: Enable sendbuf mechanism on the
 send path
Message-ID: <20140424223059.GE26890@mwanda>
References: <1398288285-16268-1-git-send-email-kys@microsoft.com>
 <CAJUuVQ7V+Se0auKdaiqPZr8i2WcNqWhHUwz8r85DKKCjnjtrvQ@mail.gmail.com>
 <cdb70820bcd0467586ce6893753c7065@BY2PR03MB299.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cdb70820bcd0467586ce6893753c7065@BY2PR03MB299.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 10:06:24PM +0000, KY Srinivasan wrote:
> > From: Andev [mailto:debiandev@gmail.com]
> > Your use of goto exit/cleanup in some functions and returning directly on
> > errors in others could use a cleanup. Please consider doing that while you are
> > touching those files.
> 
> Will do. The most recent changes I made to netvsc.c, I think was
> consistent with the existing code; going forward we will certainly
> move towards a more consistent coding style.

It scares me when you talk about being consistent with the existing
code...  Just do it the correct way.

1) Don't do the "return ret;" if you know ret is zero.

2) Replace:
	ret = vmbus_sendpacket(...);

	return ret;
   with
  	return vmbus_sendpacket(...);

3) Don't do "goto cleanup;" when "return ret;" will suffice.  The
   do-nothing goto is misleading because you assume it will cleanup
   somthing.  Some people used to misread CodingStyle to think that all
   functions should only have one return but I have updated it so it is
   more clear.

regards,
dan carpenter


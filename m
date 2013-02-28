Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760624Ab3B1VgD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 16:36:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58680 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756136Ab3B1Vf6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 16:35:58 -0500
Date: Thu, 28 Feb 2013 16:35:35 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        linux-security-module@vger.kernel.org
Subject: Re: IMA: How to manage user space signing policy with others
Message-ID: <20130228213534.GF11360@redhat.com>
References: <20130228151333.GB11360@redhat.com>
 <1362079419.2908.390.camel@falcor1.watson.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362079419.2908.390.camel@falcor1.watson.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2013 at 02:23:39PM -0500, Mimi Zohar wrote:

[..]
> I would suggest that the ima_appraise_tcb, which is more restrictive, be
> permitted to replace the secureboot policy.

Also ima_appraise_tcb is not necessarily more restrictive. It takes
appraises only for root user. Files for rest of users are not appraised.

In general case of "memory locked execution of signed binary" I was
hoping to give user a flexibility to do appraisal either for root
or both root and non-root user.

For the time being I can hardcode things only for root user but the
moment somebody will extend functionality for non-root user, again
we will run into the issue that ima_appraise_tcb is not superset so
we can't allow that.

Thanks
Vivek

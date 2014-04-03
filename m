Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154AbaDCEua (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 00:50:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25603 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932759AbaDCEtu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 00:49:50 -0400
Date: Thu, 3 Apr 2014 00:49:30 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: neelegup@linux.vnet.ibm.com, benh@kernel.crashing.org
Subject: Re: powerpc/powernv: Enable reading and updating of system parameters
Message-ID: <20140403044930.GA10707@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	neelegup@linux.vnet.ibm.com, benh@kernel.crashing.org
References: <20140402205401.9031B660EE0@gitolite.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140402205401.9031B660EE0@gitolite.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2014 at 08:54:01PM +0000, Linux Kernel wrote:
 > Gitweb:     http://git.kernel.org/linus/;a=commit;h=4029cd66545f0a45258eda5313b7559bfeaaaae4
 > Commit:     4029cd66545f0a45258eda5313b7559bfeaaaae4
 > Parent:     8d724823220862ce289be3b50119235e03537597
 > Author:     Neelesh Gupta <neelegup@linux.vnet.ibm.com>
 > AuthorDate: Fri Mar 7 11:02:09 2014 +0530
 > Committer:  Benjamin Herrenschmidt <benh@kernel.crashing.org>
 > CommitDate: Mon Mar 24 09:47:30 2014 +1100
 > 
 >     powerpc/powernv: Enable reading and updating of system parameters
 >     
 >     This patch enables reading and updating of system parameters through
 >     OPAL call.
 >     
 
 ...

 > +		/* If the parameter is read-only or read-write */
 > +		switch (perm[i] & 3) {
 > +		case OPAL_SYSPARAM_READ:
 > +			attr[i].kobj_attr.attr.mode = S_IRUGO;
 > +			break;
 > +		case OPAL_SYSPARAM_WRITE:
 > +			attr[i].kobj_attr.attr.mode = S_IWUGO;
 > +			break;
 > +		case OPAL_SYSPARAM_RW:
 > +			attr[i].kobj_attr.attr.mode = S_IRUGO | S_IWUGO;
 > +			break;
 > +		default:
 > +			break;
 
Is world-writable really appropriate for this ?

	Dave
 

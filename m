Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932677AbaAaRuX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 12:50:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44710 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932170AbaAaRuW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 12:50:22 -0500
Date: Fri, 31 Jan 2014 12:50:09 -0500
From: Dave Jones <davej@redhat.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, hpa@linux.intel.com
Subject: Re: x86, x32: Correct invalid use of user timespec in the kernel
Message-ID: <20140131175009.GA27231@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>, hpa@linux.intel.com
References: <20140131025453.B594B660CA3@gitolite.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140131025453.B594B660CA3@gitolite.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 31, 2014 at 02:54:53AM +0000, Linux Kernel wrote:

 > Commit:     2def2ef2ae5f3990aabdbe8a755911902707d268
 > 
 > ...
 >  
 > -	if (get_compat_timespec(&ktspec, timeout))
 > +	if (compat_get_timespec(&ktspec, timeout))
 >  		return -EFAULT;
 >  
 >  	datagrams = __sys_recvmmsg(fd, (struct mmsghdr __user *)mmsg, vlen,
 >  				   flags | MSG_CMSG_COMPAT, &ktspec);
 > -	if (datagrams > 0 && put_compat_timespec(&ktspec, timeout))
 > +	if (datagrams > 0 && compat_put_timespec(&ktspec, timeout))
 >  		datagrams = -EFAULT;
 >  

Can we rename one of each of those functions ?
It's not really surprising they got mixed up given they look so alike.

It looks like an accident just waiting to happen again.

	Dave


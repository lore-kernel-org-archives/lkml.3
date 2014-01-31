Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932952AbaAaSGy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 13:06:54 -0500
Received: from mga02.intel.com ([134.134.136.20]:5182 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932170AbaAaSGx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 13:06:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,759,1384329600"; 
   d="scan'208";a="447768032"
Message-ID: <52EBE62E.70102@linux.intel.com>
Date: Fri, 31 Jan 2014 10:06:38 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: x86, x32: Correct invalid use of user timespec in the kernel
References: <20140131025453.B594B660CA3@gitolite.kernel.org> <20140131175009.GA27231@redhat.com>
In-Reply-To: <20140131175009.GA27231@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2014 09:50 AM, Dave Jones wrote:
> On Fri, Jan 31, 2014 at 02:54:53AM +0000, Linux Kernel wrote:
> 
>  > Commit:     2def2ef2ae5f3990aabdbe8a755911902707d268
>  > 
>  > ...
>  >  
>  > -	if (get_compat_timespec(&ktspec, timeout))
>  > +	if (compat_get_timespec(&ktspec, timeout))
>  >  		return -EFAULT;
>  >  
>  >  	datagrams = __sys_recvmmsg(fd, (struct mmsghdr __user *)mmsg, vlen,
>  >  				   flags | MSG_CMSG_COMPAT, &ktspec);
>  > -	if (datagrams > 0 && put_compat_timespec(&ktspec, timeout))
>  > +	if (datagrams > 0 && compat_put_timespec(&ktspec, timeout))
>  >  		datagrams = -EFAULT;
>  >  
> 
> Can we rename one of each of those functions ?
> It's not really surprising they got mixed up given they look so alike.
> 
> It looks like an accident just waiting to happen again.
> 

Very much so, I made the same comment.

My feeling is that {get,put}_compat_timespec() should at the very least
have leading underscores to flag it as a low-level function, but better
suggestions would be appreciated.

	-hpa



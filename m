Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932232AbaEITqD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 15:46:03 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:56294 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008AbaEITqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 15:46:01 -0400
Message-ID: <1399664699.2232.59.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: IMA + O_DIRECT (Re: [PATCH 0/1] fix IMA + Apparmor kernel panic)
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: "J. R. Okajima" <hooanon05g@gmail.com>
Cc: Dmitry Kasatkin <d.kasatkin@samsung.com>, viro@zeniv.linux.org.uk,
        ebiederm@xmission.com, linux-security-module@vger.kernel.org,
        eparis@redhat.com, dmitry.kasatkin@gmail.com,
        linux-kernel@vger.kernel.org
Date: Fri, 09 May 2014 15:44:59 -0400
In-Reply-To: <18674.1399651287@jrobl>
References: <cover.1399554584.git.d.kasatkin@samsung.com>
	 <29977.1399605003@jrobl> <536C8E64.6000009@samsung.com>
	 <11673.1399627021@jrobl>
	 <1399647534.2232.8.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <18674.1399651287@jrobl>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14050919-1542-0000-0000-000001B1011F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-05-10 at 01:01 +0900, J. R. Okajima wrote: 
> Mimi Zohar:
> > Another approach was posted here
> > http://marc.info/?l=linux-security-module&m=138919062430367&w=2 which
> > also was not upstreamed.
> 
> It might be better a little than previous one which handles the flag
> temporarily. But, in order to make the code cleaner particulary for
> do_blockdev_direct_IO(), I'd suggest
> - make two new static inline functions like
>   r = ima_aware_file_inode_mutex_lock(file) and ..._unlock(r, file).
> - these new functions are complied when CONFIG_IMA is enabled, otherwise
>   they are plain mutex_lock/unlock().
> - then do_blockdev_direct_IO() can call them blindly.
> - of course, O_DIRECT_HAVELOCK should be complied only when CONFIG_IMA
>   is enabled too.
> 
> I can guess that several people thinks that is still "ugly locking", but
> the deadlock is much ugly in real world. And we need some workaround for
> it.

I assume so, as there wasn't any comment.  As a temporary fix, would it
make sense not to measure/appraise/audit files opened with the direct-io
flag based policy?  Define a new IMA policy option 'directio'.  A sample
rule would look like:  

dont_appraise bprm_check directio fsuuid=... 

Mimi


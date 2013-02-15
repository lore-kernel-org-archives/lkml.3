Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935954Ab3BOPwQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 10:52:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33782 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932519Ab3BOPwP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 10:52:15 -0500
Date: Fri, 15 Feb 2013 10:52:09 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: ebiederm@xmission.com, cpw@sgi.com, kumagai-atsushi@mxc.nes.nec.co.jp,
        lisa.mitchell@hp.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/13] vmcore: remove unused helper function
Message-ID: <20130215155209.GG27784@redhat.com>
References: <20130214100945.22466.4172.stgit@localhost6.localdomain6>
 <20130214101227.22466.12503.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130214101227.22466.12503.stgit@localhost6.localdomain6>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2013 at 07:12:27PM +0900, HATAYAMA Daisuke wrote:
> Remove map_offset_to_paddr(), which is no longer used.

This along with how read logic is changed should be one patch. And
on top of it should be second patch which reads some part of memory
from current kernel instead of old kernel.

Thanks
Vivek

> 
> Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
> ---
> 
>  fs/proc/vmcore.c |   21 ---------------------
>  1 files changed, 0 insertions(+), 21 deletions(-)
> 
> diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
> index 4125a65..3aedb52 100644
> --- a/fs/proc/vmcore.c
> +++ b/fs/proc/vmcore.c
> @@ -117,27 +117,6 @@ static ssize_t read_from_oldmem(char *buf, size_t count,
>  	return read;
>  }
>  
> -/* Maps vmcore file offset to respective physical address in memroy. */
> -static u64 map_offset_to_paddr(loff_t offset, struct list_head *vc_list,
> -					struct vmcore **m_ptr)
> -{
> -	struct vmcore *m;
> -	u64 paddr;
> -
> -	list_for_each_entry(m, vc_list, list) {
> -		u64 start, end;
> -		start = m->offset;
> -		end = m->offset + m->size - 1;
> -		if (offset >= start && offset <= end) {
> -			paddr = m->paddr + offset - start;
> -			*m_ptr = m;
> -			return paddr;
> -		}
> -	}
> -	*m_ptr = NULL;
> -	return 0;
> -}
> -
>  /* Read from the ELF header and then the crash dump. On error, negative value is
>   * returned otherwise number of bytes read are returned.
>   */

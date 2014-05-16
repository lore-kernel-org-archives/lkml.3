Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757941AbaEPSXj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 14:23:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49759 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757880AbaEPSXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 14:23:38 -0400
Date: Fri, 16 May 2014 11:26:57 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Himangi Saraogi <himangi774@gmail.com>
Cc: jslaby@suse.cz, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: question about hvc_opal.c
Message-ID: <20140516182657.GA15475@kroah.com>
References: <CAB78YHynbQ=cR-jDTHpwwVGgDO24fjXETO1Zp88QD=Vkjf+6GQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAB78YHynbQ=cR-jDTHpwwVGgDO24fjXETO1Zp88QD=Vkjf+6GQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2014 at 11:34:13PM +0530, Himangi Saraogi wrote:
> Hi,
>  
> In function hvc_opal_probe I find :
> 
>         hp = hvc_alloc(termno, 0, ops, MAX_VIO_PUT_CHARS);
>         if (IS_ERR(hp))
>                 return PTR_ERR(hp);
> 
> Earlier, hpc_opal_privs[termno] is assigned pv which is allocated using
> kzalloc. Shouldn't there be a kfree(pv) and the array element (which is global)
> be made NULL before the return. Also, if array element is set to NULL on the
> failure, then some cleanup must be done to undo the effect of hvc_instantiate
> as well. Please let me know if the change is desirable.

Sounds reasonable, please send a patch.

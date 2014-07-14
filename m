Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078AbaGNQ6t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 12:58:49 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:22676 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756099AbaGNQ6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 12:58:42 -0400
Date: Mon, 14 Jul 2014 12:58:35 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Andy Lutomirski <luto@amacapital.net>, david.vrabel@citrix.com
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Is espfix64's double-fault thing OK on Xen?
Message-ID: <20140714165835.GA9969@laptop.dumpdata.com>
References: <CALCETrXrVNKNQtxncfOth5OqaSOC7KygerbB-+QQb4_VKESVsA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrXrVNKNQtxncfOth5OqaSOC7KygerbB-+QQb4_VKESVsA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2014 at 04:17:57PM -0700, Andy Lutomirski wrote:
> This part in __do_double_fault looks fishy:
> 
>     cmpl $__KERNEL_CS,CS(%rdi)
>     jne do_double_fault
> 
> Shouldn't that be:
> 
>     test $3,CS(%rdi)
>     jnz do_double_fault
> 

Let me rope in David, who was playing with that recently.

> --Andy

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933125AbaLBN3m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 08:29:42 -0500
Received: from smtp113.iad3a.emailsrvr.com ([173.203.187.113]:51187 "EHLO
	smtp113.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753363AbaLBN3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 08:29:41 -0500
X-Sender-Id: abbotti@mev.co.uk
Message-ID: <547DBEC2.5010505@mev.co.uk>
Date: Tue, 02 Dec 2014 13:29:38 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: haver@linux.vnet.ibm.com
CC: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Thadeu Lima De Souza Cascardo <thadeul@br.ibm.com>
Subject: Re: [PATCH] misc: genwqe: check for error from get_user_pages_fast()
References: <1415291019-6178-1-git-send-email-abbotti@mev.co.uk> <1417525160.2010.4.camel@oc7383187364.ibm.com>
In-Reply-To: <1417525160.2010.4.camel@oc7383187364.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/14 12:59, Frank Haverkamp wrote:
> Hi Ian,
>
> thanks for reviewing our code and sorry for not answering immediately.
>
> Am Donnerstag, den 06.11.2014, 16:23 +0000 schrieb Ian Abbott:
>> `genwqe_user_vmap()` calls `get_user_pages_fast()` and if the return
>> value is less than the number of pages requested, it frees the pages and
>> returns an error (`-EFAULT`).  However, it fails to consider a negative
>> error return value from `get_user_pages_fast()`.  In that case, the test
>> `if (rc < m->nr_pages)` will be false (due to promotion of `rc` to a
>> large `unsigned int`) and the code will continue on to call
>> `genwqe_map_pages()` with an invalid list of page pointers.  Fix it by
>> bailing out if `get_user_pages_fast()` returns a negative error value.
>
> True. Did you find this by manual inspection of the code or did you use
> tools to figure it out?

I just spotted it while grepping for examples of drivers that used 
get_user_pages() or get_user_pages_fast() as I want to use it in a 
driver for some custom hardware.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk> )=-
-=(                          Web: http://www.mev.co.uk/  )=-

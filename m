Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935207Ab3E2V2G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 17:28:06 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:48791 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935124Ab3E2V2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 17:28:00 -0400
Message-ID: <51A672CC.9020403@linux.vnet.ibm.com>
Date: Wed, 29 May 2013 14:27:40 -0700
From: Cody P Schafer <cody@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Nathan Fontenot <nfont@linux.vnet.ibm.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH updated] drivers/base: Use attribute groups to create
 sysfs memory files
References: <51A58F4D.3020804@linux.vnet.ibm.com>
In-Reply-To: <51A58F4D.3020804@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052921-7606-0000-0000-00000BEE02B6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2013 10:17 PM, Nathan Fontenot wrote:
> Update the sysfs memory code to create/delete files at the time of device
> and subsystem registration.
>
> The current code creates files in the root memory directory explicitly
> through
> the use of init_* routines. The files for each memory block are created and
> deleted explicitly using the mem_[create|delete]_simple_file macros.
>
> This patch creates attribute groups for the memory root files and files in
> each memory block directory so that they are created and deleted implicitly
> at subsys and device register and unregister time.
>
> This did necessitate moving the register_memory() routine and update
> it to set the dev.groups field.
>
> Signed-off-by: Nathan Fontenot <nfont@linux.vnet.ibm.com>
>
> Updated to apply cleanly to rc2.
>
> Please cc me on responses/comments.
> ---
>   drivers/base/memory.c |  143
> +++++++++++++++++++++-----------------------------
>   1 file changed, 62 insertions(+), 81 deletions(-)
>
> Index: linux/drivers/base/memory.c
> ===================================================================
> --- linux.orig/drivers/base/memory.c    2013-05-28 22:53:58.000000000 -0500
> +++ linux/drivers/base/memory.c 2013-05-28 22:56:49.000000000 -0500

These changes look good, but this email doesn't play nice with `git am`. ex:

	"fatal: corrupt patch at line 80"

There is nothing particularly bad about line 80. Please fix and resend 
(git format-patch generally gets this right, maybe use that?)



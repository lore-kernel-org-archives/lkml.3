Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932760Ab3BSMbr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 07:31:47 -0500
Received: from mail-ee0-f52.google.com ([74.125.83.52]:42326 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754510Ab3BSMbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 07:31:46 -0500
Message-ID: <512370AD.6040901@suse.cz>
Date: Tue, 19 Feb 2013 13:31:41 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
CC: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Len Brown <len.brown@intel.com>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, Andy Ross <andy.ross@windriver.com>
Subject: Re: [PATCH] vt: add init_hide parameter to suppress boot output
References: <1361266690-19382-1-git-send-email-kirill.shutemov@linux.intel.com>
In-Reply-To: <1361266690-19382-1-git-send-email-kirill.shutemov@linux.intel.com>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2013 10:38 AM, Kirill A. Shutemov wrote:
> From: Andy Ross <andy.ross@windriver.com>
> 
> When vt.init_hide=1 is set, suppress output on newly created consoles
> until an affirmative switched to that console.  This prevents boot
> output from displaying (and clobbering splash screens, etc...) without
> disabling the console entirely.
> 
> Signed-off-by: Andy Ross <andy.ross@windriver.com>
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> ---
>  drivers/tty/vt/vt.c            |    7 +++++++
>  include/linux/console_struct.h |    3 ++-
>  include/linux/vt.h             |    2 ++
>  kernel/power/console.c         |    2 --
>  4 files changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
> index 8fd8968..3966ff5 100644
> --- a/drivers/tty/vt/vt.c
> +++ b/drivers/tty/vt/vt.c
> @@ -165,6 +165,9 @@ module_param(global_cursor_default, int, S_IRUGO | S_IWUSR);
>  static int cur_default = CUR_DEFAULT;
>  module_param(cur_default, int, S_IRUGO | S_IWUSR);
>  
> +static int init_hide;
> +module_param(init_hide, int, S_IRUGO);

So this should actually be a bool, right? Could you change that
appropriately?

thanks,
-- 
js
suse labs

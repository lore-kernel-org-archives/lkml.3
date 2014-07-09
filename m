Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932397AbaGITTE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 15:19:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47441 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932289AbaGITTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 15:19:02 -0400
Date: Wed, 9 Jul 2014 12:23:27 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Sami Laine <laine.j.sami@gmail.com>
Cc: sachin.kamat@linaro.org, devel@driverdev.osuosl.org, trivial@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH next-20140704]: staging/rtl8821ae/debug.c: sparse warning
 correction
Message-ID: <20140709192327.GA4593@kroah.com>
References: <20140706090553.GB16760@acer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140706090553.GB16760@acer>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 06, 2014 at 12:05:53PM +0300, Sami Laine wrote:
> From: Sami Laine <laine.j.sami@gmail.com>
> 
> Sparse warning correction:
> 
> vers/staging/rtl8821ae/debug.c:80:23: warning: symbol 'proc_topdir' was
> not declared. Should it be static?
> 
> Signed-off-by: Sami Laine <laine.j.sami@gmail.com>
> ---
> diff --git a/drivers/staging/rtl8821ae/debug.c b/drivers/staging/rtl8821ae/debug
> index 8aefbf1..e4a19ba 100644
> --- a/drivers/staging/rtl8821ae/debug.c
> +++ b/drivers/staging/rtl8821ae/debug.c
> @@ -77,7 +77,7 @@ void rtl_dbgp_flag_init(struct ieee80211_hw *hw)
>         /*Init Debug flag enable condition */
>  }
>  
> -struct proc_dir_entry *proc_topdir;
> +static struct proc_dir_entry *proc_topdir;
>  static int rtl_proc_get_mac_0(struct seq_file *m, void *v)
>  {
>         struct ieee80211_hw *hw = m->private;

This does not apply properly, and given the lack of testing of your
other patch, I'm loath to try to fix it up by hand myself :(

greg k-h

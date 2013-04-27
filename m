Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754349Ab3D0NRT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Apr 2013 09:17:19 -0400
Received: from mail-da0-f53.google.com ([209.85.210.53]:56750 "EHLO
	mail-da0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975Ab3D0NRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Apr 2013 09:17:18 -0400
Date: Sat, 27 Apr 2013 06:17:15 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Qiaowei Ren <qiaowei.ren@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Richard L Maliszewski <richard.l.maliszewski@intel.com>,
        Shane Wang <shane.wang@intel.com>, Gang Wei <gang.wei@intel.com>,
        linux-kernel@vger.kernel.org, Xiaoyan Zhang <xiaoyan.zhang@intel.com>
Subject: Re: [PATCH 3/5] driver: provide sysfs interfaces to access TXT log
Message-ID: <20130427131715.GB32432@kroah.com>
References: <1367074580-16530-1-git-send-email-qiaowei.ren@intel.com>
 <1367074580-16530-4-git-send-email-qiaowei.ren@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367074580-16530-4-git-send-email-qiaowei.ren@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 27, 2013 at 10:56:18PM +0800, Qiaowei Ren wrote:
> +ssize_t sysfs_create_log(struct kobject *parent)
> +{
> +	struct kobject *log_kobj;
> +	int retval;
> +
> +	log_kobj = kobject_create_and_add("log", parent);
> +	if (!log_kobj)
> +		return -ENOMEM;
> +
> +	retval = sysfs_create_group(log_kobj, &log_attr_grp);
> +	if (retval)
> +		kobject_put(log_kobj);
> +	return retval;
> +}
> +EXPORT_SYMBOL_GPL(sysfs_create_log);

Seriously?  That's what you are calling this function?

{sigh}

Please, go get this patch series reviewed by other, experienced, Intel
developers, before you send it out again.  There's loads of things wrong
with this series, and they can help you out much easier, and nicer, than
I'm going to be here.

Oh, and NEVER use "raw" kobjects, by doing that, you know you are doing
something wrong in a driver.

greg k-h

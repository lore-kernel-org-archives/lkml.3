Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244AbaJ1OON (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 10:14:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56987 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbaJ1OOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 10:14:12 -0400
Date: Tue, 28 Oct 2014 22:12:55 +0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Qais Yousef <qais.yousef@imgtec.com>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH 09/11] drivers: char: axd: add sysfs setup files
Message-ID: <20141028141255.GC18384@kroah.com>
References: <1414495589-8579-1-git-send-email-qais.yousef@imgtec.com>
 <1414495589-8579-10-git-send-email-qais.yousef@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414495589-8579-10-git-send-email-qais.yousef@imgtec.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 11:26:27AM +0000, Qais Yousef wrote:
> +/* Control Device Sysfs Attributes */
> +/* version */
> +static ssize_t show_version(struct device *dev, struct device_attribute *attr,
> +							char *buf)
> +{
> +	struct axd_cmd *cmd = (struct axd_cmd *)dev->platform_data;
> +	int major, minor, patch;
> +
> +	axd_cmd_get_version(cmd, &major, &minor, &patch);
> +	return sprintf(buf, "%u.%u.%u\n", major, minor, patch);
> +}
> +static DEVICE_ATTR(version, RD_PERMS, show_version, NULL);

DEVICE_ATTR_RO() please.  Same for all other instances, you should never
use DEVICE_ATTR() anymore.

thanks,

greg k-h

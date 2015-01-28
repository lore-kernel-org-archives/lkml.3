Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933173AbbA2Bw1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:52:27 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46063 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755553AbbA2BwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:52:21 -0500
Date: Wed, 28 Jan 2015 13:06:23 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] drivers/base/node: Use device_create_files() and
 device_remove_files()
Message-ID: <20150128210623.GB18649@kroah.com>
References: <1422477974-8369-1-git-send-email-tiwai@suse.de>
 <1422477974-8369-3-git-send-email-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1422477974-8369-3-git-send-email-tiwai@suse.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2015 at 09:46:14PM +0100, Takashi Iwai wrote:
> Use the new helper functions to simplify the code.
> 
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> ---
>  drivers/base/node.c | 24 ++++++++++++------------
>  1 file changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/base/node.c b/drivers/base/node.c
> index a3b82e9c7f20..e567e7bde333 100644
> --- a/drivers/base/node.c
> +++ b/drivers/base/node.c
> @@ -200,6 +200,16 @@ static ssize_t node_read_distance(struct device *dev,
>  }
>  static DEVICE_ATTR(distance, S_IRUGO, node_read_distance, NULL);
>  
> +static const struct device_attribute *node_dev_attrs[] = {
> +	&dev_attr_cpumap,
> +	&dev_attr_cpulist,
> +	&dev_attr_meminfo,
> +	&dev_attr_numastat,
> +	&dev_attr_distance,
> +	&dev_attr_vmstat,
> +	NULL
> +};
> +
>  #ifdef CONFIG_HUGETLBFS
>  /*
>   * hugetlbfs per node attributes registration interface:
> @@ -276,12 +286,7 @@ static int register_node(struct node *node, int num, struct node *parent)
>  	error = device_register(&node->dev);
>  
>  	if (!error){
> -		device_create_file(&node->dev, &dev_attr_cpumap);
> -		device_create_file(&node->dev, &dev_attr_cpulist);
> -		device_create_file(&node->dev, &dev_attr_meminfo);
> -		device_create_file(&node->dev, &dev_attr_numastat);
> -		device_create_file(&node->dev, &dev_attr_distance);
> -		device_create_file(&node->dev, &dev_attr_vmstat);
> +		device_create_files(&node->dev, node_dev_attrs);

This should just be using an attribute group instead of these files all
being created at once, care to switch the code to use that instead?

thanks,

greg k-h

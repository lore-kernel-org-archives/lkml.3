Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122Ab3H0GHk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 02:07:40 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51239 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085Ab3H0GHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 02:07:37 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.0.1
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-3
Message-ID: <521C41FD.8050302@jp.fujitsu.com>
Date: Tue, 27 Aug 2013 15:06:53 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/base/memory.c: introduce help macro to_memory_block
References: <521B2ED2.2010501@cn.fujitsu.com>
In-Reply-To: <521B2ED2.2010501@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/08/26 19:32), Gu Zheng wrote:
> Introduce help macro to_memory_block to hide the conversion(device-->memory_block),
> just clean up.
>
> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
> ---

It looks good to me.

Reviewed-by: Yasuaki Ishimatsu  <isimatu.yasuaki@jp.fujitsu.com>

Thanks,
Yasuaki Ishimatsu

>   drivers/base/memory.c |   27 ++++++++++++---------------
>   1 files changed, 12 insertions(+), 15 deletions(-)
>
> diff --git a/drivers/base/memory.c b/drivers/base/memory.c
> index 2b7813e..4a874c6 100644
> --- a/drivers/base/memory.c
> +++ b/drivers/base/memory.c
> @@ -30,6 +30,8 @@ static DEFINE_MUTEX(mem_sysfs_mutex);
>
>   #define MEMORY_CLASS_NAME	"memory"
>
> +#define to_memory_block(dev) container_of(dev, struct memory_block, dev)
> +
>   static int sections_per_block;
>
>   static inline int base_memory_block_id(int section_nr)
> @@ -77,7 +79,7 @@ EXPORT_SYMBOL(unregister_memory_isolate_notifier);
>
>   static void memory_block_release(struct device *dev)
>   {
> -	struct memory_block *mem = container_of(dev, struct memory_block, dev);
> +	struct memory_block *mem = to_memory_block(dev);
>
>   	kfree(mem);
>   }
> @@ -110,8 +112,7 @@ static unsigned long get_memory_block_size(void)
>   static ssize_t show_mem_start_phys_index(struct device *dev,
>   			struct device_attribute *attr, char *buf)
>   {
> -	struct memory_block *mem =
> -		container_of(dev, struct memory_block, dev);
> +	struct memory_block *mem = to_memory_block(dev);
>   	unsigned long phys_index;
>
>   	phys_index = mem->start_section_nr / sections_per_block;
> @@ -121,8 +122,7 @@ static ssize_t show_mem_start_phys_index(struct device *dev,
>   static ssize_t show_mem_end_phys_index(struct device *dev,
>   			struct device_attribute *attr, char *buf)
>   {
> -	struct memory_block *mem =
> -		container_of(dev, struct memory_block, dev);
> +	struct memory_block *mem = to_memory_block(dev);
>   	unsigned long phys_index;
>
>   	phys_index = mem->end_section_nr / sections_per_block;
> @@ -137,8 +137,7 @@ static ssize_t show_mem_removable(struct device *dev,
>   {
>   	unsigned long i, pfn;
>   	int ret = 1;
> -	struct memory_block *mem =
> -		container_of(dev, struct memory_block, dev);
> +	struct memory_block *mem = to_memory_block(dev);
>
>   	for (i = 0; i < sections_per_block; i++) {
>   		pfn = section_nr_to_pfn(mem->start_section_nr + i);
> @@ -154,8 +153,7 @@ static ssize_t show_mem_removable(struct device *dev,
>   static ssize_t show_mem_state(struct device *dev,
>   			struct device_attribute *attr, char *buf)
>   {
> -	struct memory_block *mem =
> -		container_of(dev, struct memory_block, dev);
> +	struct memory_block *mem = to_memory_block(dev);
>   	ssize_t len = 0;
>
>   	/*
> @@ -280,7 +278,7 @@ static int __memory_block_change_state(struct memory_block *mem,
>
>   static int memory_subsys_online(struct device *dev)
>   {
> -	struct memory_block *mem = container_of(dev, struct memory_block, dev);
> +	struct memory_block *mem = to_memory_block(dev);
>   	int ret;
>
>   	mutex_lock(&mem->state_mutex);
> @@ -295,7 +293,7 @@ static int memory_subsys_online(struct device *dev)
>
>   static int memory_subsys_offline(struct device *dev)
>   {
> -	struct memory_block *mem = container_of(dev, struct memory_block, dev);
> +	struct memory_block *mem = to_memory_block(dev);
>   	int ret;
>
>   	mutex_lock(&mem->state_mutex);
> @@ -349,7 +347,7 @@ store_mem_state(struct device *dev,
>   	bool offline;
>   	int ret = -EINVAL;
>
> -	mem = container_of(dev, struct memory_block, dev);
> +	mem = to_memory_block(dev);
>
>   	lock_device_hotplug();
>
> @@ -392,8 +390,7 @@ store_mem_state(struct device *dev,
>   static ssize_t show_phys_device(struct device *dev,
>   				struct device_attribute *attr, char *buf)
>   {
> -	struct memory_block *mem =
> -		container_of(dev, struct memory_block, dev);
> +	struct memory_block *mem = to_memory_block(dev);
>   	return sprintf(buf, "%d\n", mem->phys_device);
>   }
>
> @@ -525,7 +522,7 @@ struct memory_block *find_memory_block_hinted(struct mem_section *section,
>   		put_device(&hint->dev);
>   	if (!dev)
>   		return NULL;
> -	return container_of(dev, struct memory_block, dev);
> +	return to_memory_block(dev);
>   }
>
>   /*
>



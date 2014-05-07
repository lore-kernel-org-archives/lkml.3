Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295AbaEGFYy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 01:24:54 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:36802 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830AbaEGFYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 01:24:53 -0400
Message-ID: <5369C3A1.2070502@gmail.com>
Date: Tue, 06 May 2014 22:24:49 -0700
From: Florian Fainelli <f.fainelli@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: David Decotigny <decot@googlers.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Eric Dumazet <edumazet@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Weilong Chen <chenweilong@huawei.com>, Jiri Pirko <jiri@resnulli.us>,
        Michael Dalton <mwdalton@google.com>,
        Al Viro <viro@ZenIV.linux.org.uk>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v1] net-sysfs: expose permanent hardware address in sysfs
References: <cover.1399347193.git.decot@googlers.com> <cd90d330753ff145d209240a72caafac32f5e750.1399347193.git.decot@googlers.com>
In-Reply-To: <cd90d330753ff145d209240a72caafac32f5e750.1399347193.git.decot@googlers.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 05/05/2014 20:34, David Decotigny a écrit :
> Tested:
>    grep . /sys/class/net/*/*addr*

Please also include the relevant sysfs documentation changes in 
Documentation/ABI/testing/sysfs-class-net.

Thanks!

>
> Signed-off-by: David Decotigny <decot@googlers.com>
> ---
>   net/core/net-sysfs.c | 15 +++++++++++++++
>   1 file changed, 15 insertions(+)
>
> diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
> index 1cac29e..bf57024 100644
> --- a/net/core/net-sysfs.c
> +++ b/net/core/net-sysfs.c
> @@ -127,6 +127,20 @@ static ssize_t address_show(struct device *dev, struct device_attribute *attr,
>   }
>   static DEVICE_ATTR_RO(address);
>
> +static ssize_t perm_addr_show(struct device *dev, struct device_attribute *attr,
> +			      char *buf)
> +{
> +	struct net_device *net = to_net_dev(dev);
> +	ssize_t ret = -EINVAL;
> +
> +	read_lock(&dev_base_lock);
> +	if (dev_isalive(net))
> +		ret = sysfs_format_mac(buf, net->perm_addr, net->addr_len);
> +	read_unlock(&dev_base_lock);
> +	return ret;
> +}
> +static DEVICE_ATTR_RO(perm_addr);
> +
>   static ssize_t broadcast_show(struct device *dev,
>   			      struct device_attribute *attr, char *buf)
>   {
> @@ -391,6 +405,7 @@ static struct attribute *net_class_attrs[] = {
>   	&dev_attr_addr_len.attr,
>   	&dev_attr_link_mode.attr,
>   	&dev_attr_address.attr,
> +	&dev_attr_perm_addr.attr,
>   	&dev_attr_broadcast.attr,
>   	&dev_attr_speed.attr,
>   	&dev_attr_duplex.attr,
>

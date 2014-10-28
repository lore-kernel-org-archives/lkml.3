Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576AbaJ1OjW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 10:39:22 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:60377 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753945AbaJ1OjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 10:39:21 -0400
Message-ID: <544FAA96.9080006@imgtec.com>
Date: Tue, 28 Oct 2014 14:39:18 +0000
From: Qais Yousef <qais.yousef@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.8.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        <alsa-devel@alsa-project.org>
Subject: Re: [PATCH 09/11] drivers: char: axd: add sysfs setup files
References: <1414495589-8579-1-git-send-email-qais.yousef@imgtec.com> <1414495589-8579-10-git-send-email-qais.yousef@imgtec.com> <20141028141255.GC18384@kroah.com>
In-Reply-To: <20141028141255.GC18384@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/2014 02:12 PM, Greg Kroah-Hartman wrote:
> On Tue, Oct 28, 2014 at 11:26:27AM +0000, Qais Yousef wrote:
>> +/* Control Device Sysfs Attributes */
>> +/* version */
>> +static ssize_t show_version(struct device *dev, struct device_attribute *attr,
>> +							char *buf)
>> +{
>> +	struct axd_cmd *cmd = (struct axd_cmd *)dev->platform_data;
>> +	int major, minor, patch;
>> +
>> +	axd_cmd_get_version(cmd, &major, &minor, &patch);
>> +	return sprintf(buf, "%u.%u.%u\n", major, minor, patch);
>> +}
>> +static DEVICE_ATTR(version, RD_PERMS, show_version, NULL);
> DEVICE_ATTR_RO() please.  Same for all other instances, you should never
> use DEVICE_ATTR() anymore.
>
> thanks,
>
> greg k-h

OK. I missed the transition to the new macro. I'll fix that.

Thanks,
Qais

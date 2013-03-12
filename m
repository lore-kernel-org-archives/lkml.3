Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933212Ab3CLSEf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 14:04:35 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:36416 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754504Ab3CLSEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 14:04:33 -0400
Message-ID: <513F6E2C.1000101@wwwdotorg.org>
Date: Tue, 12 Mar 2013 12:04:28 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Danny Huang <dahuang@nvidia.com>, linux@arm.linux.org.uk, hdoyu@nvidia.com,
        olof@lixom.net, gregkh@linuxfoundation.org, josephl@nvidia.com,
        pdeschrijver@nvidia.com, pgaikwad@nvidia.com,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ARM: tegra: expose chip ID and revision
References: <1363089667-15737-1-git-send-email-dahuang@nvidia.com> <201303121259.18710.arnd@arndb.de>
In-Reply-To: <201303121259.18710.arnd@arndb.de>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2013 06:59 AM, Arnd Bergmann wrote:
> On Tuesday 12 March 2013, Danny Huang wrote:
>>
>> +void __init tegra_soc_device_init(void)
>> +{
>> +       struct soc_device *soc_dev;
>> +       struct soc_device_attribute *soc_dev_attr;
>> +
>> +       soc_dev_attr = kzalloc(sizeof(*soc_dev_attr), GFP_KERNEL);
>> +       if (!soc_dev_attr)
>> +               return;
>> +
>> +       soc_dev_attr->soc_id = kasprintf(GFP_KERNEL, "%d", tegra_chip_id);
>> +       soc_dev_attr->revision = kasprintf(GFP_KERNEL, "%d", tegra_revision);
>> +       soc_dev_attr->family = kasprintf(GFP_KERNEL, "Tegra");
>> +
>> +       soc_dev = soc_device_register(soc_dev_attr);
>> +       if (IS_ERR_OR_NULL(soc_dev))
>> +               kfree(soc_dev_attr);
>> +
>> +       return;
> 
> You are dropping the soc_dev on the floor here by just returning.
> 
> The idea of the soc node is to have all on-soc components be children
> of that node, so you should instead pass it into of_platform_populate
> as the parent device.

Tegra DTs don't have a separate node for on-soc vs. off-soc components.
Wouldn't passing soc_dev into of_platform_populate() make everything a
child of this soc_dev; is that what we want?

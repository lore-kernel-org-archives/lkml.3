Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036AbaIXReU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 13:34:20 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:58574 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753049AbaIXReS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 13:34:18 -0400
Message-ID: <54230093.2060303@linux.vnet.ibm.com>
Date: Wed, 24 Sep 2014 13:34:11 -0400
From: Stefan Berger <stefanb@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
CC: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [tpmdd-devel] [PATCH v1 12/12] tpm: TPM2 sysfs attributes
References: <1411549562-24242-1-git-send-email-jarkko.sakkinen@linux.intel.com> <1411549562-24242-13-git-send-email-jarkko.sakkinen@linux.intel.com> <20140924171338.GG8898@obsidianresearch.com>
In-Reply-To: <20140924171338.GG8898@obsidianresearch.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14092417-7182-0000-0000-0000008A0A95
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2014 01:13 PM, Jason Gunthorpe wrote:
> On Wed, Sep 24, 2014 at 12:06:02PM +0300, Jarkko Sakkinen wrote:
>> +static ssize_t durations_show(struct device *dev, struct device_attribute *attr,
>> +			      char *buf)
>> +{
>> +	struct tpm_chip *chip = dev_get_drvdata(dev);
>> +
>> +	if (chip->vendor.duration[TPM_LONG] == 0)
>> +		return 0;
>> +
>> +	return sprintf(buf, "%d %d %d [%s]\n",
>> +		       jiffies_to_usecs(chip->vendor.duration[TPM_SHORT]),
>> +		       jiffies_to_usecs(chip->vendor.duration[TPM_MEDIUM]),
>> +		       jiffies_to_usecs(chip->vendor.duration[TPM_LONG]),
>> +		       chip->vendor.duration_adjusted
>> +		       ? "adjusted" : "original");
>> +}
>> +static DEVICE_ATTR_RO(durations);
> Seem useless since the durations are constant, drop it?

We show them for TPM 1.2 as well, so I'd keep them fo TPM2.

>
>> +static ssize_t timeouts_show(struct device *dev, struct device_attribute *attr,
>> +			     char *buf)
>> +{
>> +	struct tpm_chip *chip = dev_get_drvdata(dev);
>> +
>> +	return sprintf(buf, "%d %d %d %d [%s]\n",
>> +		       jiffies_to_usecs(chip->vendor.timeout_a),
>> +		       jiffies_to_usecs(chip->vendor.timeout_b),
>> +		       jiffies_to_usecs(chip->vendor.timeout_c),
>> +		       jiffies_to_usecs(chip->vendor.timeout_d),
>> +		       chip->vendor.timeout_adjusted
>> +		       ? "adjusted" : "original");
>> +}
>> +static DEVICE_ATTR_RO(timeouts);

With all the problems we had with TPM 1.2 TPM's wrong timeouts and 
showing them in sysfs, why not show them for TPM2 as well?


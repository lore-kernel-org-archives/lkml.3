Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752533AbaATAuh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 19:50:37 -0500
Received: from mail-ob0-f182.google.com ([209.85.214.182]:53709 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233AbaATAue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 19:50:34 -0500
Message-ID: <52DC72CA.3090403@landley.net>
Date: Sun, 19 Jan 2014 18:50:18 -0600
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>, Christophe Leroy <christophe.leroy@c-s.fr>
CC: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Krzysztof Halasa <khc@pm.waw.pl>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, marc.balemboy@c-s.fr
Subject: Re: ping [PATCH v3] WAN: Adding support for Lantiq PEF2256 E1 chipset
 (FALC56)
References: <20140119180732.A1D99432AF@localhost.localdomain> <1390160095.2290.9.camel@joe-AO722>
In-Reply-To: <1390160095.2290.9.camel@joe-AO722>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19/14 13:34, Joe Perches wrote:
> On Sun, 2014-01-19 at 19:07 +0100, Christophe Leroy wrote:
>> Pinging this watch as we got no feedback since 22 Nov, although we have taken
>> into account reviews from v1 and v2.
>>
>> The patch adds WAN support for Lantiq FALC56 - PEF2256 E1 Chipset.
...
>> +static ssize_t fs_attr_Tx_TS_store(struct device *dev,
>> +			struct device_attribute *attr,  const char *buf,
>> +			size_t count)
>> +{
>> +	struct net_device *ndev = dev_get_drvdata(dev);
>> +	struct pef2256_dev_priv *priv = dev_to_hdlc(ndev)->priv;
>> +	unsigned long value;
>> +	int ret = kstrtoul(buf, 16, (long int *)&value);
>
> unportable cast

How is that not portable? It's long == pointer on Linux, which supports 
LP64 on all targets. (As do BSD, MacOSX, android, and iOS.)

   http://www.unix.org/whitepapers/64bit.html
   http://www.unix.org/version2/whatsnew/lp64_wp.html

Do you mean it's not portable to Windows?

   http://blogs.msdn.com/oldnewthing/archive/2005/01/31/363790.aspx

Rob

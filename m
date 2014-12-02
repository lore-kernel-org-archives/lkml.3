Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933002AbaLBUJ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 15:09:56 -0500
Received: from mail-oi0-f42.google.com ([209.85.218.42]:58724 "EHLO
	mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932469AbaLBUJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 15:09:55 -0500
From: Ashley Lai <ashley@ashleylai.com>
X-Google-Original-From: Ashley Lai <alai@ant>
Date: Tue, 2 Dec 2014 14:09:49 -0600 (CST)
To: =?ISO-8859-15?Q?Peter_H=FCwe?= <PeterHuewe@gmx.de>
cc: Ashley Lai <ashley@ashleylai.com>, Anton Blanchard <anton@samba.org>,
        Marcel Selhorst <tpmdd@selhorst.net>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] tpm/tpm_ibmvtpm: Fail in ibmvtpm_get_data if
 driver_data is bad
In-Reply-To: <201412022046.04376.PeterHuewe@gmx.de>
Message-ID: <alpine.DEB.2.10.1412021406190.15589@ant>
References: <20140920072942.27c28768@kryten> <alpine.DEB.2.10.1412021307180.15589@ant> <201412022046.04376.PeterHuewe@gmx.de>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-1543629757-1417550994=:15589"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1543629757-1417550994=:15589
Content-Type: TEXT/PLAIN; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT

I recommend not applying this patch until we hear back from IBM.

Thanks,
--Ashley

On Tue, 2 Dec 2014, Peter Hüwe wrote:

> Hi,
>
> so shall I apply this patch? or not?
>
> Thanks,
> Peter
>
> Am Dienstag, 2. Dezember 2014, 20:22:35 schrieb Ashley Lai:
>>> @@ -63,9 +63,9 @@ static int ibmvtpm_send_crq(struct vio_dev *vdev, u64
>>> w1, u64 w2) static struct ibmvtpm_dev *ibmvtpm_get_data(const struct
>>> device *dev) {
>>>
>>> 	struct tpm_chip *chip = dev_get_drvdata(dev);
>>>
>>> -	if (chip)
>>> -		return (struct ibmvtpm_dev *)TPM_VPRIV(chip);
>>> -	return NULL;
>>> +
>>> +	BUG_ON(!chip);
>>
>> With the recent patch from Vicky, it is possible to have a NULL value for
>> chip which will trigger a false positive for BUG_ON(!chip).
>>
>>> +	return (struct ibmvtpm_dev *)TPM_VPRIV(chip);
>>> }
>>>
>>> /**
>
>
--8323329-1543629757-1417550994=:15589--

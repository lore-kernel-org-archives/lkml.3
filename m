Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706Ab3HPCP2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 22:15:28 -0400
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:52707 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753543Ab3HPCP0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 22:15:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=message-id:date
	:from:mime-version:to:cc:subject:references:in-reply-to
	:content-type:content-transfer-encoding; q=dns; s=sasl; b=XMknzm
	BlK91nILd+Vt75gjAaQFUdv7FZXDoLqFv/9M3xZnW7ABSDHsLzIiEIAW2PHG2cRN
	c7qWS82zGyejJSP/C7SKcsvxwLY86ZOh8bDVfOHVA57BoJ4yHRp+y30gag9gAblt
	SfUKLVTH7q2HRZRQPb7ww+OkPEG20wsKODYtk=
Message-ID: <520D8B30.9000602@pobox.com>
Date: Fri, 16 Aug 2013 11:15:12 +0900
From: Shinya Kuribayashi <skuribay@pobox.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: christian.ruppert@abilis.com
CC: mika.westerberg@linux.intel.com, linux-i2c@vger.kernel.org,
        wsa@the-dreams.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] i2c-designware: make *CNT values configurable
References: <20130710165634.GA30693@ab42.lan> <20130711073600.GG4898@intel.com> <20130711101330.GP4898@intel.com> <51DFB6C1.4040001@pobox.com> <20130712085140.GY4898@intel.com> <51E0E76B.1040304@pobox.com> <20130716111616.GA25835@ab42.lan> <51E6ACBE.7000509@pobox.com> <20130722131706.GA24081@ab42.lan> <51EFE550.1000507@pobox.com> <20130805093126.GE20936@ab42.lan>
In-Reply-To: <20130805093126.GE20936@ab42.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Pobox-Relay-ID: B5BAB512-0619-11E3-BCCF-CA9B8506CD1E-47602734!b-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 8/5/13 6:31 PM, Christian Ruppert wrote:> On Wed, Jul 24, 2013 at 11:31:44PM +0900, Shinya Kuribayashi wrote:
>> As said before, all t_SCL things should go away.  Please forget
>> about 100kbps, 400kbps, and so on.  Bus/clock speed is totally
>> pointless concept for the I2C bus systems.  For example, as long
>> as tr/tf, tHIGH/tLOW, tHD;STA, etc. are met by _all_ devices in a
>> certain I2C bus, it doesn't matter that the resulting clock speed
>> is, say 120 kbps with Standard-mode, or even 800 kbps for Fast-mode.
>> Nobody in the I2C bus doesn't care about actual bus/clock speed.
>>
>> We don't have to care about the resulting bus speed, or rather
>> we should/must not check to see if it's within the proper range.
>
> Actually, the I2C specification clearly defines f_SCL;max (and thus
> implies t_SCL;min), both in the tables and the timing diagrams. Why can
> we ignore this constraint while having to meet all the others?

If we meet t_r, t_f, t_HIGH, t_LOW (and t_HIGH in this DW case),
f_SCL;max will be met by itself.  And again, all I2C master and
slave devices in the bus don't care about f_SCL; what they do care
are t_f, t_r, t_HIGH, t_LOW, and so on.  That's why I'm saying
f_SCL is pointless and has no value for HCNT/LCNT calculations.

Is that clear?  What is the point to make sure whether f_SCL
constraint is met or not?  Is there any combination where t_f,
t_r, t_HIGH, t_LOW, t_HD;SATA are met, but f_SCL is out of range?
I don't think there is.

I'd make a compromise proposal; it's fine to make sure whether the
resulting f_SCL is within a supported range, but should not make a
correction of HCNT/LCNT values.  Just report warning messages that
some parameters/calculations might be mis-configured an/or wrong.

   Shinya

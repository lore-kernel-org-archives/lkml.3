Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751530Ab3HSMWz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 08:22:55 -0400
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:63660 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751336Ab3HSMWx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 08:22:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=message-id:date
	:from:mime-version:to:cc:subject:references:in-reply-to
	:content-type:content-transfer-encoding; q=dns; s=sasl; b=PMov2z
	/qk8gAm/n+X/I0XlscKcZEVTMpcv+jkh92z0XOBoGzq6QX380wFF5aTCdpasHqiY
	7AaQWm2Mo1dpJFskcx+Ck1OmqU4B2rvNpgtg6zKhDNlZjHV6vgEZqMHIOVF93ejk
	HM+RioqeVENv1gkaQ0eFZEpMxObhxBewpX/0U=
Message-ID: <52120E16.8010503@pobox.com>
Date: Mon, 19 Aug 2013 21:22:46 +0900
From: Shinya Kuribayashi <skuribay@pobox.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: mika.westerberg@linux.intel.com
CC: christian.ruppert@abilis.com, linux-i2c@vger.kernel.org, wsa@the-dreams.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] i2c-designware: make *CNT values configurable
References: <20130711101330.GP4898@intel.com> <51DFB6C1.4040001@pobox.com> <20130712085140.GY4898@intel.com> <51E0E76B.1040304@pobox.com> <20130716111616.GA25835@ab42.lan> <51E6ACBE.7000509@pobox.com> <20130722131706.GA24081@ab42.lan> <51EFE550.1000507@pobox.com> <20130805093126.GE20936@ab42.lan> <520D8B30.9000602@pobox.com> <20130819113604.GN4898@intel.com>
In-Reply-To: <20130819113604.GN4898@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Pobox-Relay-ID: 1044EF86-08CA-11E3-9320-CA9B8506CD1E-47602734!b-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 8/19/13 8:36 PM, Mika Westerberg wrote:
> On Fri, Aug 16, 2013 at 11:15:12AM +0900, Shinya Kuribayashi wrote:
>>> Actually, the I2C specification clearly defines f_SCL;max (and thus
>>> implies t_SCL;min), both in the tables and the timing diagrams. Why can
>>> we ignore this constraint while having to meet all the others?
>>
>> If we meet t_r, t_f, t_HIGH, t_LOW (and t_HIGH in this DW case),
>> f_SCL;max will be met by itself.  And again, all I2C master and
>> slave devices in the bus don't care about f_SCL; what they do care
>> are t_f, t_r, t_HIGH, t_LOW, and so on.  That's why I'm saying
>> f_SCL is pointless and has no value for HCNT/LCNT calculations.
>
> One thing that comes to mind regarding the bus speed is that even if we
> have all the minimal timing requirements met we still prefer resulting bus
> speeds closer to 400kHz than 315.41kHz for the reasons that we get more
> data transferred that way, no?

That depends I2C slave devices in the bus in your target systems.
As long as your slave devices can detect START/STOP conditions and
recognize SDA/SCL transitions properly, that should be Ok (you can
use HCNT/LCNT settings for 400 kHz without having all the minimal
timing requirements met).

My comments above was a reply to Christian's snippet code and how to
treat f_SCL;mas constraints, and unrelated to your case in question.
I'm for having a way to override HCNT/LCNT values as said before, and
that should nicely work for you.

   Shinya

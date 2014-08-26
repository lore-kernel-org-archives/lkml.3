Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751989AbaHZQVd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 12:21:33 -0400
Received: from 132.79-246-81.adsl-static.isp.belgacom.be ([81.246.79.132]:44272
	"EHLO viper.mind.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879AbaHZQVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 12:21:31 -0400
Message-ID: <53FCB3FE.2050308@mind.be>
Date: Tue, 26 Aug 2014 18:21:18 +0200
From: Arnout Vandecappelle <arnout@mind.be>
Organization: Essensium/Mind
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: David Brown <davidb@codeaurora.org>
Subject: Re: [PATCH v2] tps65910: Work around silicon erratum SWCZ010
References: <1408709666-5927-1-git-send-email-arnout@mind.be> <1408721456-8101-1-git-send-email-arnout@mind.be> <53FC5DF0.2040205@nvidia.com>
In-Reply-To: <53FC5DF0.2040205@nvidia.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/14 12:14, Laxman Dewangan wrote:
> Because this patch is dropped from Mark's tree, here is opportunity to revisit
> patch.
> 
> On Friday 22 August 2014 09:00 PM, Arnout Vandecappelle (Essensium/Mind) wrote:
>>  From http://www.ti.com/lit/pdf/SWCZ010 :
>>
>>
>> Workaround:
>> Repeat I2C access.
> 
>> A simpler workaround is to make a dummy transfer just before the first
>> access to the tps65910 chip. This can be done unconditionally.
>> >id = chip_id;
>>   +    /* Work around silicon erratum SWCZ010: the tps65910 may miss the
>> +     * first I2C transfer. So issue a dummy transfer before the first
>> +     * real transfer.
>> +     */
>> +    i2c_master_send(i2c, "", 1);
> 
> I think dummy read is more safe operation than dummy write.
> Dummy write can create the write on any register which can damage the critical
> settings or it may be possible that it will be incomplete calls. Datasheet has
> not been explained this clearly.

 We're just sending the register address 0 of the SMBus transfer, without an
actual read/write request. If we do an i2c_master_recv, it's not a valid SMBus
transfer so we're equally unsure about how the chip will react to that.

 But if you like, I can check how the chip reacts to it - most likely it'll just
ignore it, possibly it won't even ack it.


 Regards,
 Arnout
-- 
Arnout Vandecappelle                          arnout at mind be
Senior Embedded Software Architect            +32-16-286500
Essensium/Mind                                http://www.mind.be
G.Geenslaan 9, 3001 Leuven, Belgium           BE 872 984 063 RPR Leuven
LinkedIn profile: http://www.linkedin.com/in/arnoutvandecappelle
GPG fingerprint:  7CB5 E4CC 6C2E EFD4 6E3D A754 F963 ECAB 2450 2F1F

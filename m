Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751830Ab3FJHLc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 03:11:32 -0400
Received: from eu1sys200aog122.obsmtp.com ([207.126.144.153]:38725 "EHLO
	eu1sys200aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751511Ab3FJHLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 03:11:31 -0400
Message-ID: <51B57BA0.3060702@st.com>
Date: Mon, 10 Jun 2013 08:09:20 +0100
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Reply-To: srinivas.kandagatla@st.com
Organization: STMicroelectronics
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Mark Brown <broonie@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] regmap: Add regmap_field APIs
References: <1369753080-1929-1-git-send-email-srinivas.kandagatla@st.com> <51B4A693.4080503@metafoo.de>
In-Reply-To: <51B4A693.4080503@metafoo.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/13 17:00, Lars-Peter Clausen wrote:
> [...]
>> +int regmap_field_write(struct regmap_field *field, unsigned int val)
>> +{
>> +	int field_bits;
>> +	unsigned int reg_mask;
>> +	field_bits = field->msb - field->lsb + 1;
>> +	reg_mask = ((BIT(field_bits) - 1) << field->lsb);
>> +	return regmap_update_bits(field->regmap, field->reg,
>> +				reg_mask, val << field->lsb);
> 
> Considering that you'd do the same calculations over and over again it would
> probably make more sense store the mask rather than the msb in the struct
It makes sense, I will do that change.

Thanks,
srini
> 
>> +}
>> +EXPORT_SYMBOL_GPL(regmap_field_write);


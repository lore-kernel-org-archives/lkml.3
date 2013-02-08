Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759916Ab3BHHqu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 02:46:50 -0500
Received: from vsp-authed02.binero.net ([195.74.38.226]:42606 "HELO
	vsp-authed-03-02.binero.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757921Ab3BHHqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 02:46:49 -0500
Message-ID: <5114AD62.1070909@gaisler.com>
Date: Fri, 08 Feb 2013 08:46:42 +0100
From: Andreas Larsson <andreas@gaisler.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Anton Vorontsov <anton@enomsg.org>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        spi-devel-general@lists.sourceforge.net,
        Mingkai Hu <Mingkai.hu@freescale.com>,
        Joakim Tjernlund <Joakim.Tjernlund@transmode.se>,
        Kumar Gala <galak@kernel.crashing.org>,
        Peter Korsgaard <jacmet@sunsite.dk>, linux-kernel@vger.kernel.org,
        software@gaisler.com
Subject: Re: [PATCH v2 7/7] spi: spi-fsl-spi: Add support for gpio chipselects
 for GRLIB type cores
References: <1360242731-13700-1-git-send-email-andreas@gaisler.com> <1360242731-13700-8-git-send-email-andreas@gaisler.com> <20130207160821.GA22224@lizard.gateway.2wire.net>
In-Reply-To: <20130207160821.GA22224@lizard.gateway.2wire.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-02-07 17:08, Anton Vorontsov wrote:
> On Thu, Feb 07, 2013 at 02:12:11PM +0100, Andreas Larsson wrote:
>>   	struct fsl_spi_reg *reg_base;
>> -	int retval;
>> +	int retval, desel;
>
> We don't usually place variable declarations on the same line, unless the
> variables are closely related.
>
>>   	u32 hw_mode;
>>   	struct spi_mpc8xxx_cs	*cs = spi->controller_state;
>>
>> @@ -456,12 +456,45 @@ static int fsl_spi_setup(struct spi_device *spi)
>>   		return retval;
>>   	}
>>
>> +	if (mpc8xxx_spi->type == TYPE_GRLIB) {
>> +		if (gpio_is_valid(spi->cs_gpio)) {
>
> <- You can place the 'int desel;' here, limiting the visibility for it.

Thanks for the feedback!

I'll put that in v3. This last patch needs to wait for the other 
patchset I mentioned anyway.

Cheers,
Andreas


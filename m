Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751428AbaDPBG0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 21:06:26 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:49475 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358AbaDPBGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 21:06:17 -0400
X-AuditID: 85900ec0-d1d29b9000001514-08-534dd786f79f
Message-ID: <534DD786.7090702@hitachi.com>
Date: Wed, 16 Apr 2014 10:06:14 +0900
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120604 Thunderbird/13.0
MIME-Version: 1.0
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Stephen Warren <swarren@nvidia.com>, Jingoo Han <jg1.han@samsung.com>,
        linux-kernel@vger.kernel.org,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        linux-serial@vger.kernel.org, yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Aaron Sierra <asierra@xes-inc.com>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: Re: [PATCH V5.1] serial/uart/8250: Add tunable RX interrupt
 trigger I/F of FIFO buffers
References: <20140415055216.14660.18270.stgit@yunodevel> <20140415080649.19209.60645.stgit@yunodevel> <20140415111033.102bc5af@alan.etchedpixels.co.uk>
In-Reply-To: <20140415111033.102bc5af@alan.etchedpixels.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

Thank you for your review.

(2014/04/15 19:10), One Thousand Gnomes wrote:
>
>> +static int convert_val2rxtrig(struct uart_8250_port *up, unsigned char val)
>> +{
>> +	const struct serial8250_config *conf_type = &uart_config[up->port.type];
>> +	int i;
>> +
>> +	if (!conf_type->rx_trig_byte[FCR_RX_TRIG_BITS(UART_FCR_R_TRIG_00)]) {
>> +		pr_info("Not support RX-trigger setting for this serial %s\n",
>> +			conf_type->name);
>> +		return -EOPNOTSUPP;
>
> We don't want the pr_info here - otherwise users can flood the logs. The
> err code is sufficient.

OK, I'll delete this pr_info().

>> +	for (i = 1; i < FCR_RX_TRIG_MAX_STATE; i++) {
>> +		if (val < conf_type->rx_trig_byte[i])
>> +			/* Use the nearest lower value */
>> +			return (--i) << FCR_RX_TRIG_OFFSET;
>
> Odd case here - your 16654 entry has a minimum of 8 so if I pass 1 then
> it'll return -1 ? I guess for that case the best we can do is to set 8.

No, in that case, this function returns 0.

Note that the "i" starts from 1, so the minimal value is 0.
Actually convert_val2rxtrig() returns the index of rx_trig_byte, and
when val == 1, it returns 0 and caller gets rx_trig_byte[0] == 8.

> Other trivial thing to tweak - you have "uaser" in spot instead of "user".

Oops, I'll fix it.

Thanks,
Yoshihiro YUNOMAE

> With those two fixed it looks good to me.
>
> Alan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com



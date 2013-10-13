Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361Ab3JMTaE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 15:30:04 -0400
Received: from smtprelay0156.hostedemail.com ([216.40.44.156]:45620 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755059Ab3JMTaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 15:30:02 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:421:541:599:960:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:1801:2393:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3871:3872:3873:4321:4605:4823:5007:7652:10004:10400:10848:11026:11233:11473:11658:11914:12043:12295:12438:12517:12519:12740:13069:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: rule12_5766b62d6475a
X-Filterd-Recvd-Size: 2671
Message-ID: <1381692599.25528.5.camel@joe-AO722>
Subject: Re: [PATCH 2/2] i2c: i2c-core: fix coding style issues in i2c-core.c
From: Joe Perches <joe@perches.com>
To: RAGHAVENDRA GANIGA <ravi23ganiga@gmail.com>
Cc: wsa@the-dreams.de, linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 13 Oct 2013 12:29:59 -0700
In-Reply-To: <525AF0ED.7050209@gmail.com>
References: <525AF0ED.7050209@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-10-14 at 00:43 +0530, RAGHAVENDRA GANIGA wrote:
[]
> diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
[]
> @@ -1737,9 +1735,10 @@ int i2c_transfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
>  	if (adap->algo->master_xfer) {
>  #ifdef DEBUG
>  		for (ret = 0; ret < num; ret++) {
> -			dev_dbg(&adap->dev, "master_xfer[%d] %c, addr=0x%02x, "
> -				"len=%d%s\n", ret, (msgs[ret].flags & I2C_M_RD)
> -				? 'R' : 'W', msgs[ret].addr, msgs[ret].len,
> +			dev_dbg(&adap->dev, "master_xfer[%d] %c, addr=0x%02x, len=%d%s\n",
> +				ret,
> +				((msgs[ret].flags & I2C_M_RD) ? 'R' : 'W'),
> +				msgs[ret].addr, msgs[ret].len,
>  				(msgs[ret].flags & I2C_M_RECV_LEN) ? "+" : "");
>  		}

You added an unnecessary set of parentheses here and
you made it different from the similar line below.

Neither test really needs any parenthesis and this
could be written as:

			dev_dbg(&adap->dev, "master_xfer[%d] %c, addr=0x%02x, len=%d%s\n",
				ret,
				msgs[ret].flags & I2C_M_RD ? 'R' : 'W',
				msgs[ret].addr, msgs[ret].len,
				msgs[ret].flags & I2C_M_RECV_LEN ? "+" : "";

> @@ -2118,7 +2120,7 @@ EXPORT_SYMBOL(i2c_smbus_read_byte);
>  s32 i2c_smbus_write_byte(const struct i2c_client *client, u8 value)
>  {
>  	return i2c_smbus_xfer(client->adapter, client->addr, client->flags,
> -	                      I2C_SMBUS_WRITE, value, I2C_SMBUS_BYTE, NULL);
> +				I2C_SMBUS_WRITE, value, I2C_SMBUS_BYTE, NULL);

Not an improvement.

Yes, the deleted line should use tabs but
the alignment of the new line is not correct.
Please align the indentation to the open parenthesis

	return i2c_smbus_xfer(client->adapter, client->addr, client->flags,
			      I2C_SMBUS_WRITE, value, I2C_SMBUS_BYTE, NULL);

Using maximal tabs at start of line, and up to 7 spaces
to align properly.

(using 3 tabs, 6 spaces)

